<?php

require_once __DIR__ . '/../private/funciones_auth.php';
require_once __DIR__ . '/../private/puntuacion.php';
requiereAutenticacion();

$pdo        = getDB();
$idUsuario  = (int) $_SESSION['id_usuario'];

$stmtEq = $pdo->prepare("SELECT id_equipo, nombre_equipo, presupuesto FROM equipos_fantasy WHERE id_usuario = ? LIMIT 1");
$stmtEq->execute([$idUsuario]);
$equipo = $stmtEq->fetch();

if (!$equipo) {
    // Crear equipo si no existe
    $nombreEquipo = "Equipo de " . $_SESSION['nombre'];
    $pdo->prepare("INSERT INTO equipos_fantasy (id_usuario, nombre_equipo) VALUES (?, ?)")
         ->execute([$idUsuario, $nombreEquipo]);
    $idEquipoNuevo = (int) $pdo->lastInsertId();
    $equipo = [
        'id_equipo' => $idEquipoNuevo,
        'nombre_equipo' => $nombreEquipo,
        'presupuesto' => 40000000
    ];
}

$idEquipo = (int) $equipo['id_equipo'];

$flash = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $accion   = $_POST['accion']    ?? '';
    $idPiloto = (int) ($_POST['id_piloto'] ?? 0);
    $slot     = (int) ($_POST['slot']      ?? 0);   // 1 = Capitán ×2, 2 = Segundo Piloto

    if ($accion === 'añadir' && $idPiloto > 0 && in_array($slot, [1, 2])) {

        $stmtP = $pdo->prepare("SELECT id_piloto, nombre FROM pilotos WHERE id_piloto = ?");
        $stmtP->execute([$idPiloto]);
        $piloto = $stmtP->fetch();

        if (!$piloto) {
            $flash = ['tipo' => 'error', 'msg' => 'Piloto no encontrado.'];

        } else {
            $stmtCheck = $pdo->prepare("SELECT id_piloto_equipo FROM pilotos_equipo_fantasy WHERE id_equipo = ? AND id_piloto = ?");
            $stmtCheck->execute([$idEquipo, $idPiloto]);

            if (!$stmtCheck->fetch()) {
                $flash = ['tipo' => 'error', 'msg' => 'Ese piloto no está en tu plantilla. Fíchalo primero.'];
            } else {
                $otroSlot = $slot === 1 ? 2 : 1;
                $idOtro   = $_SESSION['alineacion'][$idEquipo][$otroSlot] ?? null;
                if ($idOtro === $idPiloto) {
                    $flash = ['tipo' => 'error', 'msg' => 'Ese piloto ya ocupa el otro slot de alineación.'];
                } else {
                    $_SESSION['alineacion'][$idEquipo][$slot] = $idPiloto;
                    $flash = ['tipo' => 'ok', 'msg' => '¡' . htmlspecialchars($piloto['nombre']) . ' asignado al Slot ' . $slot . '!'];
                }
            }
        }

    } elseif ($accion === 'quitar' && in_array($slot, [1, 2])) {

        if (isset($_SESSION['alineacion'][$idEquipo][$slot])) {
            $idQuitado = (int) $_SESSION['alineacion'][$idEquipo][$slot];
            $stmtNom   = $pdo->prepare("SELECT nombre FROM pilotos WHERE id_piloto = ?");
            $stmtNom->execute([$idQuitado]);
            $row       = $stmtNom->fetch();
            unset($_SESSION['alineacion'][$idEquipo][$slot]);
            $flash = ['tipo' => 'ok', 'msg' => ($row ? htmlspecialchars($row['nombre']) : 'Piloto') . ' retirado del Slot ' . $slot . '.'];
        } else {
            $flash = ['tipo' => 'error', 'msg' => 'El slot ya está vacío.'];
        }

    } elseif ($accion === 'fichar' && $idPiloto > 0) {

        $stmtP = $pdo->prepare("SELECT id_piloto, nombre, precio FROM pilotos WHERE id_piloto = ?");
        $stmtP->execute([$idPiloto]);
        $piloto = $stmtP->fetch();

        if (!$piloto) {
            $flash = ['tipo' => 'error', 'msg' => 'Piloto no encontrado.'];

        } else {
            $stmtCheck = $pdo->prepare("SELECT id_piloto_equipo FROM pilotos_equipo_fantasy WHERE id_equipo = ? AND id_piloto = ?");
            $stmtCheck->execute([$idEquipo, $idPiloto]);

            if ($stmtCheck->fetch()) {
                $flash = ['tipo' => 'error', 'msg' => 'Ese piloto ya está en tu plantilla.'];

            } elseif ($equipo['presupuesto'] < $piloto['precio']) {
                $flash = ['tipo' => 'error', 'msg' => 'Presupuesto insuficiente para fichar a ' . htmlspecialchars($piloto['nombre']) . '.'];

            } else {
                $pdo->beginTransaction();
                try {
                    $pdo->prepare("INSERT INTO pilotos_equipo_fantasy (id_equipo, id_piloto) VALUES (?, ?)")->execute([$idEquipo, $idPiloto]);
                    $pdo->prepare("UPDATE equipos_fantasy SET presupuesto = presupuesto - ? WHERE id_equipo = ?")->execute([$piloto['precio'], $idEquipo]);
                    $pdo->commit();
                    $equipo['presupuesto'] -= $piloto['precio'];
                    $flash = ['tipo' => 'ok', 'msg' => '¡' . htmlspecialchars($piloto['nombre']) . ' fichado por ' . number_format($piloto['precio'] / 1000000, 1) . 'M€!'];
                } catch (Exception $e) {
                    $pdo->rollBack();
                    $flash = ['tipo' => 'error', 'msg' => 'Error al fichar el piloto.'];
                }
            }
        }

    } elseif ($accion === 'liberar' && $idPiloto > 0) {

        $stmtP = $pdo->prepare("SELECT nombre, precio FROM pilotos WHERE id_piloto = ?");
        $stmtP->execute([$idPiloto]);
        $piloto = $stmtP->fetch();

        $stmtDel = $pdo->prepare("DELETE FROM pilotos_equipo_fantasy WHERE id_equipo = ? AND id_piloto = ?");
        $stmtDel->execute([$idEquipo, $idPiloto]);

        if ($stmtDel->rowCount() > 0 && $piloto) {
            $devolucion = (int) round($piloto['precio'] * 0.8);
            $pdo->prepare("UPDATE equipos_fantasy SET presupuesto = presupuesto + ? WHERE id_equipo = ?")->execute([$devolucion, $idEquipo]);
            $equipo['presupuesto'] += $devolucion;
            if (isset($_SESSION['alineacion'][$idEquipo])) {
                foreach ($_SESSION['alineacion'][$idEquipo] as $s => $pid) {
                    if ((int)$pid === $idPiloto) unset($_SESSION['alineacion'][$idEquipo][$s]);
                }
            }
            $flash = ['tipo' => 'ok', 'msg' => htmlspecialchars($piloto['nombre']) . ' liberado. +' . number_format($devolucion / 1000000, 1) . 'M€ devueltos (80%).'];
        } else {
            $flash = ['tipo' => 'error', 'msg' => 'No se pudo liberar al piloto.'];
        }
    }
}

$presupuesto = (int) $pdo->prepare("SELECT presupuesto FROM equipos_fantasy WHERE id_equipo = ?")->execute([$idEquipo]) ? null : null;
$stmtPres = $pdo->prepare("SELECT presupuesto FROM equipos_fantasy WHERE id_equipo = ?");
$stmtPres->execute([$idEquipo]);
$presupuesto = (int) $stmtPres->fetchColumn();

$stmtMis = $pdo->prepare("
    SELECT p.id_piloto, p.nombre, p.numero, p.precio, p.imagen_url,
           e.nombre AS escuderia
    FROM pilotos_equipo_fantasy pef
    JOIN pilotos    p ON p.id_piloto    = pef.id_piloto
    JOIN escuderias e ON e.id_escuderia = p.id_escuderia
    WHERE pef.id_equipo = ?
    ORDER BY pef.fecha_inclusion ASC
");
$stmtMis->execute([$idEquipo]);
$misPilotos = $stmtMis->fetchAll();

$puntosTotalesPilotos = getPuntosTotalesPilotos();

$todosLos = $pdo->query("
    SELECT p.id_piloto, p.nombre, p.numero, p.precio, p.imagen_url,
           e.nombre AS escuderia
    FROM pilotos p
    JOIN escuderias e ON e.id_escuderia = p.id_escuderia
    ORDER BY p.precio DESC
")->fetchAll();

$idsFichados = array_column($misPilotos, 'id_piloto');

$alineacion = $_SESSION['alineacion'][$idEquipo] ?? [];
$slot1Id    = isset($alineacion[1]) ? (int)$alineacion[1] : null;
$slot2Id    = isset($alineacion[2]) ? (int)$alineacion[2] : null;

function pilotoPorId(array $lista, int $id): ?array {
    foreach ($lista as $p) {
        if ((int)$p['id_piloto'] === $id) return $p;
    }
    return null;
}

$pilotSlot1 = $slot1Id ? pilotoPorId($todosLos, $slot1Id) : null;
$pilotSlot2 = $slot2Id ? pilotoPorId($todosLos, $slot2Id) : null;

$coloresEscuderia = [
    'McLaren Mastercard F1 Team'         => '#FF8700',
    'Mercedes-AMG Petronas F1 Team'      => '#27F4D2',
    'Oracle Red Bull Racing'             => '#3671C6',
    'Scuderia Ferrari HP'                => '#E8002D',
    'Atlassian Williams F1 Team'         => '#005AFF',
    'Visa Cash App Racing Bulls F1 Team' => '#6692FF',
    'Aston Martin Aramco F1 Team'        => '#006F62',
    'TGR Haas F1 Team'                   => '#B6BABD',
    'Audi Revolut F1 Team'               => '#D0D0D0',
    'BWT Alpine F1 Team'                 => '#FF87BC',
    'Cadillac Formula 1 Team'            => '#C8102E',
    // aliases por compatibilidad
    'McLaren Mercedes'       => '#FF8700',
    'Mercedes AMG Petronas'  => '#27F4D2',
    'Williams Racing'        => '#005AFF',
    'Visa Cash App RB'       => '#6692FF',
    'Aston Martin Aramco'    => '#006F62',
    'MoneyGram Haas F1 Team' => '#B6BABD',
    'Audi F1 Team'           => '#D0D0D0',
    'Cadillac F1 Team'       => '#C8102E',
];

function colorEscuderia(string $nombre, array $mapa): string {
    return $mapa[$nombre] ?? '#888888';
}

$stmtCarrera = $pdo->query("SELECT nombre, fecha FROM carreras WHERE fecha >= CURDATE() ORDER BY fecha ASC LIMIT 1");
$proximaCarrera = $stmtCarrera->fetch();

$presupuestoInicial = 40000000;
$gastado            = $presupuestoInicial - $presupuesto;
$porcentajeGastado  = max(0, min(100, round(($gastado / $presupuestoInicial) * 100)));

function formatNombre(string $nombre): string {
    $partes   = explode(' ', trim($nombre));
    $apellido = end($partes);
    $inicial  = isset($partes[0]) ? $partes[0][0] . '.' : '';
    return $inicial . ' ' . $apellido;
}

$tituloPagina = 'Mi Equipo';
include __DIR__ . '/../private/header.php';
?>

<?php if ($flash): ?>
<div class="flash <?= $flash['tipo'] ?>">
    <?= htmlspecialchars($flash['msg']) ?>
</div>
<?php endif; ?>

<!-- ==============================
     ENCABEZADO
============================== -->
<div class="equipo-encabezado">
    <p class="panel">// Garaje Principal</p>
    <h2>MI EQUIPO</h2>
    <p class="subtitulo">Temporada 2026 &nbsp;·&nbsp; <?= htmlspecialchars($equipo['nombre_equipo']) ?></p>
</div>

<!-- ==============================
     STATS BAR
============================== -->
<div class="stats-bar">

    <div class="stat-card">
        <p class="stat-label">Presupuesto Disponible</p>
        <div class="stat-valor"><?= number_format($presupuesto / 1000000, 1) ?> <small>M€</small></div>
        <div class="stat-delta <?= $presupuesto >= $presupuestoInicial * 0.5 ? 'up' : 'down' ?>">
            <?= $presupuesto >= $presupuestoInicial * 0.5 ? '▲' : '▼' ?> <?= $porcentajeGastado ?>% gastado
        </div>
        <div class="stat-barra">
            <div class="stat-barra-fill" style="width: <?= 100 - $porcentajeGastado ?>%"></div>
        </div>
    </div>

    <div class="stat-card">
        <p class="stat-label">Pilotos en Plantilla</p>
        <div class="stat-valor"><?= count($misPilotos) ?> <small>/ 10</small></div>
    </div>

    <div class="stat-card">
        <p class="stat-label">Slot 1 — Capitán ×2</p>
        <div class="stat-valor" style="font-size:18px; margin-top:4px;">
            <?= $pilotSlot1 ? htmlspecialchars(formatNombre($pilotSlot1['nombre'])) : '<span style="color:#333;">Vacío</span>' ?>
        </div>
    </div>

    <div class="stat-card">
        <p class="stat-label">Slot 2 — Segundo Piloto</p>
        <div class="stat-valor" style="font-size:18px; margin-top:4px;">
            <?= $pilotSlot2 ? htmlspecialchars(formatNombre($pilotSlot2['nombre'])) : '<span style="color:#333;">Vacío</span>' ?>
        </div>
    </div>

    <?php if ($proximaCarrera): ?>
    <div class="stat-card stat-proximo">
        <p class="stat-label">Próxima Carrera</p>
        <div class="stat-valor" style="font-size:15px;"><?= htmlspecialchars($proximaCarrera['nombre']) ?></div>
        <div class="stat-countdown" id="countdown" data-fecha="<?= htmlspecialchars($proximaCarrera['fecha']) ?>">--D : --H : --M : --S</div>
    </div>
    <?php endif; ?>

</div>

<!-- ==============================
     GARAJE — ALINEACIÓN ACTIVA
============================== -->
<div class="seccion-titulo" style="margin-bottom: 28px;">
    <div class="linea"></div>
    <h3>Garaje Principal <span class="seccion-sub">// Alineación activa</span></h3>
</div>

<div class="garaje-grid">

<?php foreach ([1 => 'Capitán ×2', 2 => 'Segundo Piloto'] as $numSlot => $rolSlot):
    $pilotSlot = $numSlot === 1 ? $pilotSlot1 : $pilotSlot2;
?>

    <?php if ($pilotSlot): ?>
    <!-- SLOT <?= $numSlot ?> OCUPADO -->
    <div class="slot-piloto ocupado">
        <?php if ($pilotSlot['imagen_url']): ?>
        <div class="slot-bg-img" style="background-image: url('<?= htmlspecialchars($pilotSlot['imagen_url']) ?>')"></div>
        <?php endif; ?>
        <div class="slot-overlay"></div>
        <div class="badge-activo">Activo</div>

        <form method="post" style="position:absolute; top:14px; left:14px; z-index:10;">
            <input type="hidden" name="accion"    value="quitar">
            <input type="hidden" name="slot"      value="<?= $numSlot ?>">
            <input type="hidden" name="id_piloto" value="<?= (int)$pilotSlot['id_piloto'] ?>">
            <button type="submit" class="btn-quitar">✕ Quitar del slot</button>
        </form>

        <div class="slot-info">
            <div class="slot-rol">Piloto <?= $numSlot ?> // <?= $rolSlot ?></div>
            <div class="slot-piloto-row">
                <div style="display:flex; align-items:center;">
                    <?php if ($pilotSlot['imagen_url']): ?>
                    <img src="<?= htmlspecialchars($pilotSlot['imagen_url']) ?>"
                         alt="<?= htmlspecialchars($pilotSlot['nombre']) ?>"
                         class="slot-avatar">
                    <?php endif; ?>
                    <div>
                        <div class="slot-nombre"><?= htmlspecialchars(formatNombre($pilotSlot['nombre'])) ?></div>
                        <div class="slot-equipo-row">
                            <div class="slot-equipo-color"
                                 style="background-color: <?= colorEscuderia($pilotSlot['escuderia'], $coloresEscuderia) ?>;"></div>
                            <span class="slot-equipo-nombre"><?= htmlspecialchars($pilotSlot['escuderia']) ?></span>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="slot-forma-label">Nº</div>
                    <div class="slot-forma-valor"><?= (int)$pilotSlot['numero'] ?></div>
                </div>
            </div>
        </div>
    </div>

    <?php else: ?>
    <!-- SLOT <?= $numSlot ?> VACÍO -->
    <div class="slot-piloto vacio" onclick="abrirModal(<?= $numSlot ?>)" title="Clic para asignar piloto">
        <div class="slot-bg-pattern"></div>
        <div class="slot-placeholder">
            <div class="slot-rol">Piloto <?= $numSlot ?> // <?= $rolSlot ?></div>
            <div class="slot-add-row">
                <div class="slot-add-box">+</div>
                <div class="slot-add-texto">
                    <h4>Seleccionar Piloto</h4>
                    <p>Haz clic para asignar desde tu plantilla</p>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

<?php endforeach; ?>

</div>

<!-- ==============================
     MIS PILOTOS (plantilla)
============================== -->
<div class="seccion-header">
    <div class="seccion-titulo" style="margin-bottom: 0;">
        <div class="linea" style="background-color: #333;"></div>
        <h3 style="font-size:18px;">
            Mis Pilotos <span class="seccion-sub">(<?= count($misPilotos) ?> / 10 en plantilla)</span>
        </h3>
    </div>
    <button class="btn-comprar" onclick="abrirModalFichar()">+ Fichar Piloto</button>
</div>

<div class="pilotos-grid">

    <?php foreach ($misPilotos as $p):
        $color    = colorEscuderia($p['escuderia'], $coloresEscuderia);
        $enSlot1  = ($slot1Id === (int)$p['id_piloto']);
        $enSlot2  = ($slot2Id === (int)$p['id_piloto']);
        $enSlot   = $enSlot1 || $enSlot2;
    ?>
    <div class="piloto-card">
        <div class="piloto-foto-wrap">
            <?php
                $eqPartes = explode(' ', trim($p['nombre']));
                $eqIni    = strtoupper(implode('', array_map(fn($w) => $w[0], $eqPartes)));
                $eqIni    = substr($eqIni, 0, 3);
                $eqColor  = ltrim($color, '#');
                $eqSvgUrl = 'driver-img.php?num=' . (int)$p['numero'] . '&ini=' . urlencode($eqIni) . '&color=' . urlencode($eqColor);
            ?>
            <?php if ($p['imagen_url']): ?>
            <img src="<?= htmlspecialchars($p['imagen_url']) ?>"
                 alt="<?= htmlspecialchars($p['nombre']) ?>"
                 onerror="this.onerror=null;this.src='<?= htmlspecialchars($eqSvgUrl) ?>';">
            <?php else: ?>
            <img src="<?= htmlspecialchars($eqSvgUrl) ?>"
                 alt="<?= htmlspecialchars($p['nombre']) ?>">
            <?php endif; ?>
            <div class="piloto-foto-overlay"></div>
            <div class="piloto-color-dot" style="background-color: <?= $color ?>;"></div>
            <?php if ($enSlot): ?>
            <div style="position:absolute;top:8px;right:8px;background:var(--color-rojo);color:#fff;font-size:9px;font-weight:900;padding:3px 7px;letter-spacing:1px;text-transform:uppercase;">
                Slot <?= $enSlot1 ? '1' : '2' ?>
            </div>
            <?php endif; ?>
        </div>

        <h4><?= htmlspecialchars(formatNombre($p['nombre'])) ?></h4>
        <div class="piloto-meta">
            <span class="piloto-escuderia"><?= htmlspecialchars($p['escuderia']) ?></span>
            <span class="piloto-precio"><?= number_format($p['precio'] / 1000000, 1) ?>M€</span>
        </div>
        <?php
            $ptsPil = $puntosTotalesPilotos[(int)$p['id_piloto']] ?? 0;
        ?>
        <div class="piloto-pts-total <?= $ptsPil > 0 ? 'pts-pos' : ($ptsPil < 0 ? 'pts-neg' : '') ?>">
            <span class="piloto-pts-label">PTS TOTALES</span>
            <span class="piloto-pts-valor"><?= $ptsPil > 0 ? '+' : '' ?><?= $ptsPil ?></span>
        </div>

        <!-- Botones asignar a slot -->
        <?php if (!$enSlot): ?>
        <div style="display:flex; gap:6px; margin-top:10px;">
            <?php if (!$slot1Id): ?>
            <form method="post" style="flex:1;">
                <input type="hidden" name="accion"    value="añadir">
                <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
                <input type="hidden" name="slot"      value="1">
                <button type="submit" class="btn-quitar-card">▲ Slot 1</button>
            </form>
            <?php endif; ?>
            <?php if (!$slot2Id): ?>
            <form method="post" style="flex:1;">
                <input type="hidden" name="accion"    value="añadir">
                <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
                <input type="hidden" name="slot"      value="2">
                <button type="submit" class="btn-quitar-card">▲ Slot 2</button>
            </form>
            <?php endif; ?>
            <?php if ($slot1Id && $slot2Id): ?>
            <span style="font-size:10px;color:#555;font-weight:700;text-transform:uppercase;letter-spacing:1px;padding:8px 0;">Slots llenos</span>
            <?php endif; ?>
        </div>
        <?php else: ?>
        <!-- Quitar del slot -->
        <form method="post" style="margin-top:10px;">
            <input type="hidden" name="accion"    value="quitar">
            <input type="hidden" name="slot"      value="<?= $enSlot1 ? '1' : '2' ?>">
            <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
            <button type="submit" class="btn-quitar-card" style="border-color:var(--color-rojo); color:var(--color-rojo);">
                ✕ Quitar de Slot <?= $enSlot1 ? '1' : '2' ?>
            </button>
        </form>
        <?php endif; ?>

        <!-- Liberar piloto -->
        <button type="button" class="btn-quitar-card" style="margin-top:6px; width:100%;"
                onclick="abrirModalLiberar(
                    <?= (int)$p['id_piloto'] ?>,
                    '<?= htmlspecialchars(addslashes($p['nombre'])) ?>',
                    '<?= htmlspecialchars(addslashes($p['escuderia'])) ?>',
                    <?= number_format($p['precio'] * 0.8 / 1000000, 1, '.', '') ?>
                )">
            ✕ Liberar (<?= number_format($p['precio'] * 0.8 / 1000000, 1) ?>M€)
        </button>
    </div>
    <?php endforeach; ?>

    <!-- Slots vacíos decorativos -->
    <?php for ($i = 0; $i < max(0, min(4, 5 - count($misPilotos))); $i++): ?>
    <div class="piloto-card-vacio" onclick="abrirModalFichar()">
        <div class="add-icon">＋</div>
        <span>Fichar Piloto</span>
    </div>
    <?php endfor; ?>

</div>

<!-- ==============================
     TICKER DE MERCADO
============================== -->
<div class="ticker-mercado">
    <div class="ticker-label">Movimientos de Mercado //</div>
    <div class="ticker-items">
        <div class="ticker-item"><span class="piloto-ticker">Verstappen</span><span class="delta-up">▲ +1.2M€</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Hamilton</span><span class="delta-down">▼ -0.4M€</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Piastri</span><span class="delta-up">▲ +0.8M€</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Leclerc</span><span class="delta-flat">— ESTABLE</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Colapinto</span><span class="delta-up">▲ +2.5M€</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Norris</span><span class="delta-up">▲ +1.8M€</span></div>
        <div class="ticker-item"><span class="piloto-ticker">Russell</span><span class="delta-down">▼ -0.3M€</span></div>
    </div>
</div>

<!-- ============================================================
     MODAL 1 — Asignar piloto de la plantilla a un slot
     =========================================================== -->
<div class="modal-overlay" id="modalSlot">
    <div class="modal">
        <div class="modal-header">
            <div>
                <div class="modal-slot-label" id="modalSlotLabel">Slot 1 // Capitán ×2</div>
                <h3>Seleccionar Piloto</h3>
            </div>
            <button class="modal-cerrar" onclick="cerrarModal('modalSlot')">✕</button>
        </div>
        <div class="modal-body">
            <?php if (empty($misPilotos)): ?>
                <p style="color:#555; font-size:13px; font-weight:600;">
                    No tienes pilotos en tu plantilla. Usa el botón <strong>"Fichar Piloto"</strong> primero.
                </p>
            <?php else: ?>
                <h4>Elige un piloto de tu plantilla</h4>
                <div class="modal-lista">
                    <?php foreach ($misPilotos as $p):
                        $color    = colorEscuderia($p['escuderia'], $coloresEscuderia);
                        $enSlotYa = in_array((int)$p['id_piloto'], array_values($alineacion), true);
                    ?>
                    <div class="modal-piloto-fila" style="<?= $enSlotYa ? 'opacity:0.35; pointer-events:none;' : '' ?>">
                        <div class="fila-color" style="background-color:<?= $color ?>;"></div>
                        <div class="fila-nombre">
                            <strong><?= htmlspecialchars($p['nombre']) ?></strong>
                            <span><?= htmlspecialchars($p['escuderia']) ?></span>
                        </div>
                        <div class="fila-numero"><?= (int)$p['numero'] ?></div>
                        <?php if ($enSlotYa): ?>
                            <span style="font-size:10px;font-weight:900;text-transform:uppercase;color:#555;letter-spacing:1px;padding:8px 14px;">En slot</span>
                        <?php else: ?>
                        <form method="post">
                            <input type="hidden" name="accion"    value="añadir">
                            <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
                            <input type="hidden" name="slot"      class="input-slot-modal" value="1">
                            <button type="submit" class="fila-btn-add">▲ Asignar</button>
                        </form>
                        <?php endif; ?>
                    </div>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<!-- ============================================================
     MODAL 2 — Fichar piloto del mercado
     =========================================================== -->
<div class="modal-overlay" id="modalFichar">
    <div class="modal">
        <div class="modal-header">
            <div>
                <div class="modal-slot-label">Mercado de Fichajes</div>
                <h3>Fichar Piloto</h3>
            </div>
            <button class="modal-cerrar" onclick="cerrarModal('modalFichar')">✕</button>
        </div>
        <div class="modal-body">
            <h4>Presupuesto: <?= number_format($presupuesto / 1000000, 1) ?>M€ disponibles</h4>
            <div class="modal-lista">
                <?php foreach ($todosLos as $p):
                    $color     = colorEscuderia($p['escuderia'], $coloresEscuderia);
                    $yaFichado = in_array((int)$p['id_piloto'], array_map('intval', $idsFichados), true);
                    $sinDinero = $presupuesto < (int)$p['precio'];
                ?>
                <div class="modal-piloto-fila" style="<?= $yaFichado ? 'opacity:0.35; pointer-events:none;' : '' ?>">
                    <div class="fila-color" style="background-color:<?= $color ?>;"></div>
                    <div class="fila-nombre">
                        <strong><?= htmlspecialchars($p['nombre']) ?></strong>
                        <span><?= htmlspecialchars($p['escuderia']) ?></span>
                    </div>
                    <div class="fila-numero" style="font-size:12px; color:#ccc; width:60px; font-style:normal;">
                        <?= number_format($p['precio'] / 1000000, 1) ?>M€
                    </div>
                    <?php if ($yaFichado): ?>
                        <span style="font-size:10px;font-weight:900;text-transform:uppercase;color:#555;letter-spacing:1px;padding:8px 14px;">Ya fichado</span>
                    <?php elseif ($sinDinero): ?>
                        <span style="font-size:10px;font-weight:900;text-transform:uppercase;color:var(--color-rojo);letter-spacing:1px;padding:8px 14px;">Sin fondos</span>
                    <?php else: ?>
                        <form method="post">
                            <input type="hidden" name="accion"    value="fichar">
                            <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
                            <button type="submit" class="fila-btn-add">Fichar</button>
                        </form>
                    <?php endif; ?>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
</div>

<!-- ============================================================
     MODAL 3 — Confirmar liberación de piloto
     =========================================================== -->
<div class="modal-overlay" id="modalLiberar">
    <div class="modal" style="max-width: 420px;">
        <div class="modal-header">
            <div>
                <div class="modal-slot-label">Liberar Piloto</div>
                <h3>¿Confirmar liberación?</h3>
            </div>
            <button class="modal-cerrar" onclick="cerrarModal('modalLiberar')">✕</button>
        </div>
        <div class="modal-body" style="padding: 28px;">

            <!-- Info del piloto -->
            <div style="display:flex; align-items:center; gap:14px; padding:16px; background:#0f0f0f; border:1px solid #1a1a1a; margin-bottom:24px;">
                <div style="width:5px; height:48px; background:var(--color-rojo); border-radius:2px; flex-shrink:0;" id="liberarColor"></div>
                <div>
                    <div style="font-size:18px; font-weight:900; font-style:italic; text-transform:uppercase; line-height:1;" id="liberarNombre">—</div>
                    <div style="font-size:11px; color:#888; font-weight:600; text-transform:uppercase; letter-spacing:1px; margin-top:4px;" id="liberarEscuderia">—</div>
                </div>
            </div>

            <!-- Advertencia -->
            <p style="font-size:13px; color:#aaa; line-height:1.6; margin-bottom:10px;">
                Este piloto será <strong style="color:#fff;">eliminado de tu plantilla</strong>.
                Recibirás el <strong style="color:var(--color-verde);">80% de su valor</strong> como compensación:
            </p>
            <div style="font-size:28px; font-weight:900; font-style:italic; color:var(--color-verde); margin-bottom:24px;">
                +<span id="liberarDevolucion">0</span>M€
            </div>

            <!-- Botones -->
            <div style="display:flex; gap:10px;">
                <button type="button"
                        style="flex:1; padding:12px; background:none; border:1px solid #333; color:#888; font-family:inherit; font-size:12px; font-weight:900; text-transform:uppercase; letter-spacing:1px; cursor:pointer; transition:all 0.2s;"
                        onmouseover="this.style.borderColor='#555';this.style.color='#fff';"
                        onmouseout="this.style.borderColor='#333';this.style.color='#888';"
                        onclick="cerrarModal('modalLiberar')">
                    Cancelar
                </button>
                <form method="post" style="flex:1;" id="formLiberar">
                    <input type="hidden" name="accion"    value="liberar">
                    <input type="hidden" name="id_piloto" id="liberarIdPiloto" value="">
                    <button type="submit"
                            style="width:100%; padding:12px; background:var(--color-rojo); border:none; color:#fff; font-family:inherit; font-size:12px; font-weight:900; text-transform:uppercase; letter-spacing:1px; cursor:pointer; transition:opacity 0.2s;"
                            onmouseover="this.style.opacity='0.8';"
                            onmouseout="this.style.opacity='1';">
                        ✕ Confirmar Liberación
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>

<!-- ==============================
     JAVASCRIPT
============================== -->
<script>

function abrirModalLiberar(idPiloto, nombre, escuderia, devolucion) {
    document.getElementById('liberarIdPiloto').value  = idPiloto;
    document.getElementById('liberarNombre').textContent    = nombre;
    document.getElementById('liberarEscuderia').textContent = escuderia;
    document.getElementById('liberarDevolucion').textContent = devolucion;
    document.getElementById('modalLiberar').classList.add('abierto');
}

function abrirModal(slot) {
    var labels = { 1: 'Slot 1 // Capitán ×2', 2: 'Slot 2 // Segundo Piloto' };
    document.getElementById('modalSlotLabel').textContent = labels[slot] || ('Slot ' + slot);
    document.querySelectorAll('.input-slot-modal').forEach(function(inp) {
        inp.value = slot;
    });
    document.getElementById('modalSlot').classList.add('abierto');
}

function abrirModalFichar() {
    document.getElementById('modalFichar').classList.add('abierto');
}

function cerrarModal(id) {
    document.getElementById(id).classList.remove('abierto');
}

document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
    overlay.addEventListener('click', function(e) {
        if (e.target === overlay) overlay.classList.remove('abierto');
    });
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.abierto').forEach(function(m) {
            m.classList.remove('abierto');
        });
    }
});

(function () {
    var el = document.getElementById('countdown');
    if (!el) return;
    var fecha = new Date(el.dataset.fecha + 'T14:00:00');
    function actualizar() {
        var diff = fecha - new Date();
        if (diff <= 0) { el.textContent = '¡En pista!'; return; }
        var d = Math.floor(diff / 86400000);
        var h = Math.floor((diff % 86400000) / 3600000);
        var m = Math.floor((diff % 3600000)  / 60000);
        var s = Math.floor((diff % 60000)    / 1000);
        el.textContent =
            String(d).padStart(2, '0') + 'D : ' +
            String(h).padStart(2, '0') + 'H : ' +
            String(m).padStart(2, '0') + 'M : ' +
            String(s).padStart(2, '0') + 'S';
    }
    actualizar();
    setInterval(actualizar, 1000);
})();
</script>

<?php include __DIR__ . '/../private/footer.php'; ?>
