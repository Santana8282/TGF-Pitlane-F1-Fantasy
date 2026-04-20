<?php
require_once __DIR__ . '/../private/database.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function registrarUsuario(string $nombre, string $correo, string $contrasena): array
{
    $nombre = trim($nombre);
    $correo = trim(strtolower($correo));

    if (strlen($nombre) < 2 || strlen($nombre) > 100)
        return ['error' => 'El nombre debe tener entre 2 y 100 caracteres.'];
    if (!filter_var($correo, FILTER_VALIDATE_EMAIL))
        return ['error' => 'El formato del correo electrónico no es válido.'];
    if (strlen($contrasena) < 8)
        return ['error' => 'La contraseña debe tener al menos 8 caracteres.'];

    $pdo  = getDB();
    $stmt = $pdo->prepare("SELECT id_usuario FROM usuarios WHERE correo = ?");
    $stmt->execute([$correo]);
    if ($stmt->fetch())
        return ['error' => 'Este correo ya está registrado. ¿Quieres iniciar sesión?'];

    $hash = password_hash($contrasena, PASSWORD_BCRYPT, ['cost' => 12]);

    $stmt = $pdo->prepare("INSERT INTO usuarios (nombre, correo, contrasena_hash) VALUES (?, ?, ?)");
    $stmt->execute([$nombre, $correo, $hash]);
    $idUsuario = (int) $pdo->lastInsertId();

    $stmt = $pdo->prepare("INSERT INTO equipos_fantasy (id_usuario, nombre_equipo) VALUES (?, ?)");
    $stmt->execute([$idUsuario, "Equipo de " . $nombre]);

    return ['exito' => true, 'id_usuario' => $idUsuario];
}

function iniciarSesion(string $correo, string $contrasena): array
{
    $correo = trim(strtolower($correo));
    if (empty($correo) || empty($contrasena))
        return ['error' => 'Por favor, rellena todos los campos.'];

    $pdo  = getDB();
    $stmt = $pdo->prepare("SELECT id_usuario, nombre, contrasena_hash FROM usuarios WHERE correo = ?");
    $stmt->execute([$correo]);
    $usuario = $stmt->fetch();

    if (!$usuario || !password_verify($contrasena, $usuario['contrasena_hash']))
        return ['error' => 'Correo o contraseña incorrectos.'];

    session_regenerate_id(true);
    $_SESSION['id_usuario'] = $usuario['id_usuario'];
    $_SESSION['nombre']     = $usuario['nombre'];
    return ['exito' => true];
}

function cerrarSesion(): void
{
    $_SESSION = [];
    if (ini_get("session.use_cookies")) {
        $p = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $p["path"], $p["domain"], $p["secure"], $p["httponly"]);
    }
    session_destroy();
    header('Location: login.php');
    exit;
}

function requiereAutenticacion(): void
{
    if (empty($_SESSION['id_usuario'])) {
        header('Location: login.php');
        exit;
    }
}

function estaLogueado(): bool
{
    return !empty($_SESSION['id_usuario']);
}
