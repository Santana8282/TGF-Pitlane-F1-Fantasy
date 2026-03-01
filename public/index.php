<?php

require_once __DIR__ . '/../private/funciones_auth.php';
requiereAutenticacion();

$tituloPagina = 'Inicio';
include __DIR__ . '/../private/header.php';
?>

        <div class="encabezado">
            <p class="panel">Panel de Control</p>
            <h2>INICIO DE LA LIGA FANTASY F1</h2>

            <div class="botones">
                <button class="boton-oscuro">Ajustes de Liga</button>
                <button class="boton-rojo">Invitar Amigos</button>
            </div>
        </div>

        <div class="tarjetas">

            <div class="tarjeta">
                <p>Puntos Totales</p>
                <h3>2.450,5</h3>
                <span class="positivo">+125,2 GP</span>
            </div>

            <div class="tarjeta">
                <p>Posición Global</p>
                <h3>#1.204</h3>
                <span class="positivo">+45 Puestos</span>
            </div>

            <div class="tarjeta">
                <p>Presupuesto Restante</p>
                <h3>105,4 <small>M€</small></h3>
                <span class="negativo">Valor: 84,6M€</span>
            </div>

        </div>

        <div class="contenido">

            <div class="movimientos">
                <h3>Últimos Movimientos</h3>

                <table>
                    <thead>
                        <tr>
                            <th>Piloto / Escudería</th>
                            <th>Acción</th>
                            <th>Valor / Usuario</th>
                            <th>Tiempo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong>Max Verstappen</strong><br>
                                <span>Oracle Red Bull Racing</span>
                            </td>
                            <td><span class="etiqueta verde">Sube Precio</span></td>
                            <td class="verde">+0.5M €</td>
                            <td>Hace 2m</td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Lewis Hamilton</strong><br>
                                <span>Scuderia Ferrari</span>
                            </td>
                            <td><span class="etiqueta rojo">Fichado</span></td>
                            <td>NitroSpeed</td>
                            <td>Hace 15m</td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Ferrari</strong><br>
                                <span>Scuderia Ferrari</span>
                            </td>
                            <td><span class="etiqueta gris">Baja Precio</span></td>
                            <td class="texto-rojo">-0.2M €</td>
                            <td>Hace 1h</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="gran-premio">
                <p>Próximo Gran Premio</p>
                <h3>Monza — Italia</h3>

                <div class="contador">
                    <div>
                        <span>04</span>
                        <small>Días</small>
                    </div>
                    <div>
                        <span>12</span>
                        <small>Hrs</small>
                    </div>
                    <div>
                        <span>58</span>
                        <small>Min</small>
                    </div>
                </div>

                <div class="clima">
                    ☀ Soleado | 28°C
                </div>
            </div>

        </div>

<?php include __DIR__ . '/../private/footer.php'; ?>
