<?php
require_once __DIR__ . '/database.php';
require_once __DIR__ . '/puntuacion.php';

define('AUTOSYNC_INTERVALO_HORAS', 6);

function autoSyncCarrerasPendientes(): array
{
    $pdo = getDB();

    $carreras = $pdo->query("
        SELECT c.id_carrera, c.nombre, c.fecha
        FROM carreras c
        WHERE c.fecha < NOW()
        AND NOT EXISTS (
            SELECT 1 FROM resultados_carrera rc WHERE rc.id_carrera = c.id_carrera
        )
        ORDER BY c.fecha DESC
        LIMIT 3
    ")->fetchAll();

    $sincronizadas = [];
    $errores = [];

    foreach ($carreras as $c) {
        $ultimaSync = $pdo->prepare("
            SELECT MAX(fecha_sync) FROM sync_log WHERE id_carrera = ?
        ");
        $ultimaSync->execute([$c['id_carrera']]);
        $ts = $ultimaSync->fetchColumn();

        if ($ts && (time() - strtotime($ts)) < AUTOSYNC_INTERVALO_HORAS * 3600) {
            continue;
        }

        $res = sincronizarDesdeErgast((int)$c['id_carrera']);
        if ($res['ok']) {
            $sincronizadas[] = $c['nombre'];
        } else {
            $errores[] = $c['nombre'] . ': ' . $res['mensaje'];
        }
    }

    return ['sincronizadas' => $sincronizadas, 'errores' => $errores];
}

function autoSyncCarrerasConResultados(): array
{
    $pdo = getDB();

    $carreras = $pdo->query("
        SELECT c.id_carrera, c.nombre, c.fecha,
               MAX(sl.fecha_sync) AS ultima_sync
        FROM carreras c
        LEFT JOIN sync_log sl ON sl.id_carrera = c.id_carrera AND sl.estado = 'ok'
        WHERE c.fecha < NOW()
        AND EXISTS (
            SELECT 1 FROM resultados_carrera rc WHERE rc.id_carrera = c.id_carrera
        )
        GROUP BY c.id_carrera
        HAVING ultima_sync IS NULL
            OR (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(ultima_sync)) > " . (AUTOSYNC_INTERVALO_HORAS * 3600) . "
        ORDER BY c.fecha DESC
        LIMIT 2
    ")->fetchAll();

    $sincronizadas = [];
    $errores = [];

    foreach ($carreras as $c) {
        $res = sincronizarDesdeErgast((int)$c['id_carrera']);
        if ($res['ok']) {
            $sincronizadas[] = $c['nombre'];
        } else {
            $errores[] = $c['nombre'] . ': ' . $res['mensaje'];
        }
    }

    return ['sincronizadas' => $sincronizadas, 'errores' => $errores];
}

if (isset($_GET['ajax']) && $_GET['ajax'] === '1') {
    header('Content-Type: application/json');
    $r1 = autoSyncCarrerasPendientes();
    $r2 = autoSyncCarrerasConResultados();
    echo json_encode([
        'ok' => true,
        'sincronizadas' => array_merge($r1['sincronizadas'], $r2['sincronizadas']),
        'errores'       => array_merge($r1['errores'],       $r2['errores']),
    ]);
    exit;
}
