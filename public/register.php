<?php

require_once __DIR__ . '/../private/funciones_auth.php';

if (estaLogueado()) {
    header('Location: index.php');
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $contrasena        = $_POST['contrasena']         ?? '';
    $contrasenaRepetir = $_POST['contrasena_repetir'] ?? '';

    if ($contrasena !== $contrasenaRepetir) {
        $error = 'Las contraseñas no coinciden. Por favor, compruébalas.';
    } else {
        $resultado = registrarUsuario(
            $_POST['nombre'] ?? '',
            $_POST['correo'] ?? '',
            $contrasena
        );

        if (isset($resultado['exito'])) {
            $login = iniciarSesion($_POST['correo'], $contrasena);

            if (isset($login['exito'])) {
                header('Location: index.php');
                exit;
            }

            header('Location: login.php');
            exit;
        }

        $error = $resultado['error'];
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta — F1 Fantasy</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/auth.css">
</head>
<body>

<div class="fondo" aria-hidden="true">
    <div class="fondo-glow"></div>
</div>

<div class="tarjeta-auth">
    <span class="numero-decorativo" aria-hidden="true">00</span>

    <div class="logo-auth">
        <h1>F1 FANTASY</h1>
        <p>Liga Fantasy</p>
    </div>

    <h2 class="titulo-auth">Crear Cuenta</h2>
    <p class="subtitulo-auth">Únete a la carrera por el título</p>

    <?php if ($error !== ''): ?>
        <div class="mensaje-error" role="alert">
            ⚠ <?= htmlspecialchars($error) ?>
        </div>
    <?php endif; ?>

    <form method="POST" action="register.php" novalidate>

        <div class="campo">
            <label for="nombre">Nombre de piloto</label>
            <input
                type="text"
                id="nombre"
                name="nombre"
                placeholder="Tu nombre en la pista"
                value="<?= htmlspecialchars($_POST['nombre'] ?? '') ?>"
                required
                autocomplete="name"
                minlength="2"
                maxlength="100"
            >
        </div>

        <div class="campo">
            <label for="correo">Correo electrónico</label>
            <input
                type="email"
                id="correo"
                name="correo"
                placeholder="piloto@f1fantasy.com"
                value="<?= htmlspecialchars($_POST['correo'] ?? '') ?>"
                required
                autocomplete="email"
            >
        </div>

        <div class="campo">
            <label for="contrasena">Contraseña</label>
            <input
                type="password"
                id="contrasena"
                name="contrasena"
                placeholder="Mínimo 8 caracteres"
                required
                autocomplete="new-password"
                minlength="8"
                oninput="actualizarFuerza(this.value)"
            >
            <div class="barra-fuerza">
                <div class="barra-fuerza-fill" id="barraFuerza"></div>
            </div>
            <p class="hint" id="textoFuerza"></p>
        </div>

        <div class="campo">
            <label for="contrasena_repetir">Repetir contraseña</label>
            <input
                type="password"
                id="contrasena_repetir"
                name="contrasena_repetir"
                placeholder="Repite tu contraseña"
                required
                autocomplete="new-password"
            >
        </div>

        <button type="submit" class="btn-primario">
            Unirse a la Liga →
        </button>

        <p class="nota-legal">
            Al registrarte aceptas las condiciones de uso de la liga.
        </p>
    </form>

    <div class="separador">
        <span>¿Ya tienes cuenta?</span>
    </div>

    <p class="enlace-alternativo">
        <a href="login.php">← Iniciar sesión</a>
    </p>
</div>

<script>
function actualizarFuerza(valor) {
    const barra = document.getElementById('barraFuerza');
    const texto = document.getElementById('textoFuerza');

    if (!valor) {
        barra.style.width = '0%';
        texto.textContent = '';
        return;
    }

    let puntos = 0;
    if (valor.length >= 8)           puntos++;
    if (valor.length >= 12)          puntos++;
    if (/[A-Z]/.test(valor))        puntos++;
    if (/[0-9]/.test(valor))        puntos++;
    if (/[^A-Za-z0-9]/.test(valor)) puntos++;

    const niveles = [
        { porcentaje: '20%',  color: '#f20d20', etiqueta: 'Muy débil'              },
        { porcentaje: '40%',  color: '#f97316', etiqueta: 'Débil'                   },
        { porcentaje: '60%',  color: '#eab308', etiqueta: 'Moderada'                },
        { porcentaje: '80%',  color: '#84cc16', etiqueta: 'Fuerte'                  },
        { porcentaje: '100%', color: '#22c55e', etiqueta: '¡Contraseña de campeón!' },
    ];

    const nivel = niveles[Math.min(puntos - 1, 4)];

    barra.style.width           = nivel.porcentaje;
    barra.style.backgroundColor = nivel.color;
    texto.textContent           = nivel.etiqueta;
    texto.style.color           = nivel.color;
}
</script>

</body>
</html>
