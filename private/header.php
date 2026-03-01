<?php
if (!isset($tituloPagina)) {
    $tituloPagina = 'F1 Fantasy';
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($tituloPagina) ?> — F1 Fantasy</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

<div class="contenedor">

    <aside class="barra-lateral">
        <div class="logo">
            <h1>F1 Fantasy</h1>
            <p>Liga Fantasy</p>
        </div>

        <nav class="menu">
            <a href="../public/index.php"         class="<?= basename($_SERVER['PHP_SELF']) === 'index.php'         ? 'activo' : '' ?>">Inicio</a>
            <a href="../public/equipo.php"        class="<?= basename($_SERVER['PHP_SELF']) === 'equipo.php'        ? 'activo' : '' ?>">Mi Equipo</a>
            <a href="../public/mercado.php"       class="<?= basename($_SERVER['PHP_SELF']) === 'mercado.php'       ? 'activo' : '' ?>">Mercado</a>
            <a href="../public/ligas.php"         class="<?= basename($_SERVER['PHP_SELF']) === 'ligas.php'         ? 'activo' : '' ?>">Ligas</a>
            <a href="../public/clasificacion.php" class="<?= basename($_SERVER['PHP_SELF']) === 'clasificacion.php' ? 'activo' : '' ?>">Clasificación</a>
            <a href="../public/resultados.php"    class="<?= basename($_SERVER['PHP_SELF']) === 'resultados.php'    ? 'activo' : '' ?>">Resultados</a>
        </nav>

        <div class="usuario">
            <p class="nombre-usuario"><?= htmlspecialchars($_SESSION['nombre'] ?? 'Usuario') ?></p>
            <span>Piloto Pro</span>
            <br>
            <a href="../public/logout.php" class="btn-logout">⏻ Cerrar sesión</a>
        </div>
    </aside>

    <main class="principal">
