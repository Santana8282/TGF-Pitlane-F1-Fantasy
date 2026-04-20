<?php
require_once __DIR__ . '/../private/funciones_auth.php';
require_once __DIR__ . '/../private/iconos.php';
require_once __DIR__ . '/../private/puntuacion.php';
requiereAutenticacion();

$pdo       = getDB();
$idUsuario = (int) $_SESSION['id_usuario'];

// Puntos globales de cada piloto (para mostrar en el mercado como referencia)
$puntosTotalesPilotos = getPuntosTotalesPilotos();

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
$flash    = null;

// ── Procesar fichaje ─────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['accion'] ?? '') === 'fichar') {
    $idPiloto = (int) ($_POST['id_piloto'] ?? 0);

    if ($idPiloto > 0) {
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
            } elseif ((int)$equipo['presupuesto'] < (int)$piloto['precio']) {
                $flash = ['tipo' => 'error', 'msg' => 'Presupuesto insuficiente para fichar a ' . htmlspecialchars($piloto['nombre']) . '.'];
            } else {
                $pdo->beginTransaction();
                try {
                    $pdo->prepare("INSERT INTO pilotos_equipo_fantasy (id_equipo, id_piloto) VALUES (?, ?)")->execute([$idEquipo, $idPiloto]);
                    $pdo->prepare("UPDATE equipos_fantasy SET presupuesto = presupuesto - ? WHERE id_equipo = ?")->execute([$piloto['precio'], $idEquipo]);
                    $pdo->commit();
                    $equipo['presupuesto'] -= $piloto['precio'];
                    $flash = ['tipo' => 'ok', 'msg' => '✓ ' . htmlspecialchars($piloto['nombre']) . ' fichado por ' . number_format($piloto['precio'] / 1000000, 1) . 'M€. Ya aparece en Mi Equipo.'];
                } catch (Exception $e) {
                    $pdo->rollBack();
                    $flash = ['tipo' => 'error', 'msg' => 'Error al procesar el fichaje.'];
                }
            }
        }
        // Refrescar presupuesto tras fichaje
        $stmtPres = $pdo->prepare("SELECT presupuesto FROM equipos_fantasy WHERE id_equipo = ?");
        $stmtPres->execute([$idEquipo]);
        $equipo['presupuesto'] = (int) $stmtPres->fetchColumn();
    }
}

// ── Pilotos ya fichados por este equipo ──────────────────────
$stmtFichados = $pdo->prepare("SELECT id_piloto FROM pilotos_equipo_fantasy WHERE id_equipo = ?");
$stmtFichados->execute([$idEquipo]);
$idsFichados  = array_column($stmtFichados->fetchAll(), 'id_piloto');

// ── Todos los pilotos del mercado agrupados por escudería ────
$stmtPilotos = $pdo->query("
    SELECT p.id_piloto, p.nombre, p.numero, p.precio, p.imagen_url,
           e.id_escuderia, e.nombre AS escuderia
    FROM pilotos p
    JOIN escuderias e ON e.id_escuderia = p.id_escuderia
    ORDER BY e.nombre ASC, p.precio DESC
");
$todosPilotos = $stmtPilotos->fetchAll();

// Agrupar por escudería
$porEscuderia = [];
foreach ($todosPilotos as $p) {
    $porEscuderia[$p['escuderia']][] = $p;
}

// Filtro de búsqueda
$busqueda       = trim($_GET['buscar'] ?? '');
$filtroEscuderia = trim($_GET['escuderia'] ?? '');
$ordenar        = $_GET['orden'] ?? 'precio_desc';

if ($busqueda || $filtroEscuderia) {
    $todosPilotos = array_filter($todosPilotos, function($p) use ($busqueda, $filtroEscuderia) {
        $okNombre    = !$busqueda || stripos($p['nombre'], $busqueda) !== false || stripos($p['escuderia'], $busqueda) !== false;
        $okEscuderia = !$filtroEscuderia || $p['escuderia'] === $filtroEscuderia;
        return $okNombre && $okEscuderia;
    });
}

usort($todosPilotos, function($a, $b) use ($ordenar, $puntosTotalesPilotos) {
    return match($ordenar) {
        'precio_asc'   => $a['precio'] - $b['precio'],
        'nombre_asc'   => strcmp($a['nombre'], $b['nombre']),
        'numero_asc'   => $a['numero'] - $b['numero'],
        'puntos_desc'  => ($puntosTotalesPilotos[(int)$b['id_piloto']] ?? 0) - ($puntosTotalesPilotos[(int)$a['id_piloto']] ?? 0),
        default        => $b['precio'] - $a['precio'],
    };
});

$coloresEscuderia = [
    'McLaren Mastercard F1 Team'        => '#FF8700', // naranja McLaren
    'Mercedes-AMG Petronas F1 Team'     => '#00F5C3', // turquesa brillante Mercedes
    'Oracle Red Bull Racing'            => '#0D1B8E', // azul marino Red Bull
    'Scuderia Ferrari HP'               => '#DC0000', // rojo Ferrari
    'Atlassian Williams F1 Team'        => '#00CFFF', // azul cielo claro Williams
    'Visa Cash App Racing Bulls F1 Team'=> '#8B5CF6', // violeta Racing Bulls
    'Aston Martin Aramco F1 Team'       => '#006F62', // verde botella Aston Martin
    'TGR Haas F1 Team'                  => '#9B9B9B', // gris grafito Haas
    'Audi Revolut F1 Team'              => '#1A1A1A', // negro Audi
    'BWT Alpine F1 Team'                => '#FF87BC', // rosa Alpine
    'Cadillac Formula 1 Team'           => '#C9A84C', // dorado Cadillac
];

$presupuesto = (int) $equipo['presupuesto'];
$totalPilotos = count($todosPilotos);
$fichados     = count($idsFichados);

$tituloPagina = 'Mercado';
include __DIR__ . '/../private/header.php';
?>

<?php if ($flash): ?>
<div class="flash <?= $flash['tipo'] ?>"><?= htmlspecialchars($flash['msg']) ?></div>
<?php endif; ?>

<div class="encabezado">
    <p class="panel">Fichajes y Transferencias</p>
    <h2>Mercado de Pilotos</h2>
</div>

<!-- Stats rápidas -->
<div class="mercado-stats">
    <div class="mercado-stat">
        <p>Presupuesto</p>
        <strong><?= number_format($presupuesto / 1000000, 1, ',', '.') ?> <small>M€</small></strong>
    </div>
    <div class="mercado-stat">
        <p>Pilotos Fichados</p>
        <strong><?= $fichados ?> <small>/ <?= count($todosPilotos) + $fichados ?></small></strong>
    </div>
    <div class="mercado-stat">
        <p>Disponibles</p>
        <strong><?= $totalPilotos ?></strong>
    </div>
    <a href="../public/equipo.php" class="mercado-stat mercado-stat-link">
        <p>Ver mi equipo →</p>
        <strong><?= $fichados ?> pilotos</strong>
    </a>
</div>

<!-- Filtros -->
<div class="mercado-filtros">
    <form method="GET" action="mercado.php" class="filtros-form">
        <input
            type="text"
            name="buscar"
            class="filtro-input"
            placeholder="Buscar piloto o escudería..."
            value="<?= htmlspecialchars($busqueda) ?>"
        >
        <select name="escuderia" class="filtro-select">
            <option value="">Todas las escuderías</option>
            <?php foreach (array_keys($porEscuderia) as $esc): ?>
            <option value="<?= htmlspecialchars($esc) ?>" <?= $filtroEscuderia === $esc ? 'selected' : '' ?>>
                <?= htmlspecialchars($esc) ?>
            </option>
            <?php endforeach; ?>
        </select>
        <select name="orden" class="filtro-select">
            <option value="precio_desc"  <?= $ordenar === 'precio_desc'  ? 'selected' : '' ?>>Precio ↓</option>
            <option value="precio_asc"   <?= $ordenar === 'precio_asc'   ? 'selected' : '' ?>>Precio ↑</option>
            <option value="puntos_desc"  <?= $ordenar === 'puntos_desc'  ? 'selected' : '' ?>>Puntos ↓</option>
            <option value="nombre_asc"   <?= $ordenar === 'nombre_asc'   ? 'selected' : '' ?>>Nombre A-Z</option>
            <option value="numero_asc"   <?= $ordenar === 'numero_asc'   ? 'selected' : '' ?>>Número</option>
        </select>
        <button type="submit" class="filtro-btn">Filtrar</button>
        <?php if ($busqueda || $filtroEscuderia): ?>
        <a href="mercado.php" class="filtro-btn filtro-btn-reset">Limpiar</a>
        <?php endif; ?>
    </form>
</div>

<!-- Grid de pilotos -->
<?php
// Fotos de pilotos de Wikipedia (libres de derechos, dominio público)

$fotosPilotos = [
    'Max Verstappen'         => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png',
    'Liam Lawson'            => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png',
    'Charles Leclerc'        => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png',
    'Lewis Hamilton'         => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png',
    'George Russell'         => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png',
    'Andrea Kimi Antonelli'  => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/A/ANDANT01_Andrea_Kimi_Antonelli/andant01.png',
    'Lando Norris'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png',
    'Oscar Piastri'          => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png',
    'Fernando Alonso'        => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png',
    'Lance Stroll'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png',
    'Sergio Pérez'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/S/SERPER01_Sergio_Perez/serper01.png',
    'Jack Doohan'            => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/J/JACDOO01_Jack_Doohan/jacdoo01.png',
    'Arvid Lindblad'         => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/A/ARVLIN01_Arvid_Lindblad/arvlin01.png',
    'Carlos Sainz'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png',
    'Carlos Sainz Jr.'       => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png',
    'Yuki Tsunoda'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/Y/YUKTSU01_Yuki_Tsunoda/yuktsu01.png',
    'Isack Hadjar'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png',
    'Oliver Bearman'         => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png',
    'Franco Colapinto'       => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png',
    'Nico Hülkenberg'        => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png',
    'Valtteri Bottas'        => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/V/VALBOT01_Valtteri_Bottas/valbot01.png',
    'Alexander Albon'        => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png',
    'Pierre Gasly'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png',
    'Esteban Ocon'           => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png',
    'Gabriel Bortoleto'      => 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1200/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png',
];
?>
<div class="mercado-grid">
<?php foreach ($todosPilotos as $p):
    $color     = $coloresEscuderia[$p['escuderia']] ?? '#888';
    $fichado   = in_array((int)$p['id_piloto'], array_map('intval', $idsFichados));
    $sinDinero = !$fichado && $presupuesto < (int)$p['precio'];
    $foto      = $p['imagen_url'] ?: ($fotosPilotos[$p['nombre']] ?? null);
    if ($foto) $foto = preg_replace('/w_\d+/', 'w_1200', $foto);
    $ptsPiloto = $puntosTotalesPilotos[(int)$p['id_piloto']] ?? 0;
    $ptsClass  = $ptsPiloto > 0 ? 'pts-pos' : ($ptsPiloto < 0 ? 'pts-neg' : 'pts-cero');
?>
    <div class="mercado-card <?= $fichado ? 'mercado-card-fichado' : '' ?>" style="border-left: 5px solid <?= htmlspecialchars($color) ?>;">

        <!-- FOTO -->
        <div class="mercado-foto-wrap">
            <?php
                $partes    = explode(' ', trim($p['nombre']));
                $iniciales = strtoupper(implode('', array_map(fn($w) => $w[0], $partes)));
                $iniciales = substr($iniciales, 0, 3);
                $colorEsc  = ltrim($color, '#');
                $svgUrl    = 'driver-img.php?num=' . (int)$p['numero'] . '&ini=' . urlencode($iniciales) . '&color=' . urlencode($colorEsc);
            ?>
            <?php if ($foto): ?>
                <img src="<?= htmlspecialchars($foto) ?>"
                     alt="<?= htmlspecialchars($p['nombre']) ?>"
                     loading="lazy"
                     onerror="this.onerror=null;this.src='<?= htmlspecialchars($svgUrl) ?>';">
            <?php else: ?>
                <img src="<?= htmlspecialchars($svgUrl) ?>"
                     alt="<?= htmlspecialchars($p['nombre']) ?>"
                     loading="lazy">
            <?php endif; ?>
            <div class="mercado-foto-overlay"></div>
            <?php if ($fichado): ?>
                <span class="mercado-badge-sobre-foto fichado"><?= icono('check', 'icono-inline', 12) ?> En tu equipo</span>
            <?php endif; ?>
        </div>

        <!-- FRANJA COLOR ESCUDERÍA -->
        <div class="mercado-card-color" style="background-color:<?= $color ?>;"></div>

        <!-- CUERPO -->
        <div class="mercado-card-body">

            <!-- Número + Escudería + Nombre -->
            <div class="mercado-card-top">
                <div class="mercado-info">
                    <p class="mercado-escuderia"><?= htmlspecialchars($p['escuderia']) ?></p>
                    <h4 class="mercado-nombre"><?= htmlspecialchars($p['nombre']) ?></h4>
                </div>
                <span class="mercado-num-badge">#<?= (int)$p['numero'] ?></span>
            </div>

            <!-- PRECIO + PUNTOS — bloque de stats separado y visible -->
            <div class="mercado-stats-row">
                <div class="mercado-stat-mini">
                    <span class="mercado-stat-label">Precio</span>
                    <span class="mercado-precio-val">
                        <?= number_format($p['precio'] / 1000000, 1, ',', '.') ?><small>M€</small>
                    </span>
                </div>
                <div class="mercado-divider-v"></div>
                <div class="mercado-stat-mini">
                    <span class="mercado-stat-label">Puntos temporada</span>
                    <span class="mercado-pts-val <?= $ptsClass ?>">
                        <?= $ptsPiloto !== 0 ? ($ptsPiloto > 0 ? '+' : '') . $ptsPiloto : '—' ?>
                    </span>
                </div>
            </div>

            <!-- BOTÓN -->
            <div class="mercado-card-footer">
                <?php if ($fichado): ?>
                    <span class="mercado-badge-fichado"><?= icono('check', 'icono-inline', 14) ?> Fichado</span>
                    <a href="../public/equipo.php" class="mercado-btn-ir">Ver equipo →</a>
                <?php elseif ($sinDinero): ?>
                    <span class="mercado-badge-fondos">Sin fondos</span>
                <?php else: ?>
                    <form method="POST" action="mercado.php<?= $busqueda || $filtroEscuderia || $ordenar !== 'precio_desc' ? '?' . http_build_query(['buscar' => $busqueda, 'escuderia' => $filtroEscuderia, 'orden' => $ordenar]) : '' ?>" style="flex:1;">
                        <input type="hidden" name="accion"    value="fichar">
                        <input type="hidden" name="id_piloto" value="<?= (int)$p['id_piloto'] ?>">
                        <button type="submit" class="mercado-btn-fichar">+ Fichar</button>
                    </form>
                <?php endif; ?>
            </div>
        </div>
    </div>
<?php endforeach; ?>
</div>
</div>

<?php if (empty($todosPilotos)): ?>
<div class="mercado-vacio">
    <p>No se encontraron pilotos con ese filtro.</p>
    <a href="mercado.php">Ver todos</a>
</div>
<?php endif; ?>

<?php include __DIR__ . '/../private/footer.php'; ?>