-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 20-04-2026 a las 08:25:23
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pitlane_f1`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreras`
--

CREATE TABLE `carreras` (
  `id_carrera` int NOT NULL,
  `id_temporada` int NOT NULL,
  `numero_carrera` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `circuito` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `carreras`
--

INSERT INTO `carreras` (`id_carrera`, `id_temporada`, `numero_carrera`, `nombre`, `circuito`, `fecha`) VALUES
(1, 1, 1, 'Gran Premio de Australia', 'Albert Park', '2026-03-08'),
(2, 1, 2, 'Gran Premio de China', 'Shanghái', '2026-03-15'),
(3, 1, 3, 'Gran Premio de Japón', 'Suzuka', '2026-03-29'),
(4, 1, 4, 'Gran Premio de Miami', 'Miami International', '2026-05-03'),
(5, 1, 5, 'Gran Premio de Canadá', 'Gilles Villeneuve', '2026-05-24'),
(6, 1, 6, 'Gran Premio de Mónaco', 'Mónaco', '2026-06-07'),
(7, 1, 7, 'Gran Premio de Barcelona-Catalunya', 'Montmeló', '2026-06-14'),
(8, 1, 8, 'Gran Premio de Austria', 'Red Bull Ring', '2026-06-28'),
(9, 1, 9, 'Gran Premio de Gran Bretaña', 'Silverstone', '2026-07-05'),
(10, 1, 10, 'Gran Premio de Bélgica', 'Spa-Francorchamps', '2026-07-19'),
(11, 1, 11, 'Gran Premio de Hungría', 'Hungaroring', '2026-07-26'),
(12, 1, 12, 'Gran Premio de Países Bajos', 'Zandvoort', '2026-08-23'),
(13, 1, 13, 'Gran Premio de Italia', 'Monza', '2026-09-06'),
(14, 1, 14, 'Gran Premio de España', 'Madring', '2026-09-13'),
(15, 1, 15, 'Gran Premio de Azerbaiyán', 'Bakú', '2026-09-26'),
(16, 1, 16, 'Gran Premio de Singapur', 'Marina Bay', '2026-10-11'),
(17, 1, 17, 'Gran Premio de Austin', 'Circuit of the Americas', '2026-10-25'),
(18, 1, 18, 'Gran Premio de México', 'Hermanos Rodríguez', '2026-11-01'),
(19, 1, 19, 'Gran Premio de Brasil', 'Interlagos', '2026-11-08'),
(20, 1, 20, 'Gran Premio de Las Vegas', 'Las Vegas Strip', '2026-11-21'),
(21, 1, 21, 'Gran Premio de Qatar', 'Lusail', '2026-11-29'),
(22, 1, 22, 'Gran Premio de Abu Dabi', 'Yas Marina', '2026-12-06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clasificacion`
--

CREATE TABLE `clasificacion` (
  `id_clasificacion` int NOT NULL,
  `id_equipo` int NOT NULL,
  `puntos_totales` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos_fantasy`
--

CREATE TABLE `equipos_fantasy` (
  `id_equipo` int NOT NULL,
  `id_usuario` int NOT NULL,
  `nombre_equipo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `presupuesto` int DEFAULT '40000000',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `puntos_jornada` int DEFAULT '0' COMMENT 'Puntos en la última carrera',
  `cambios_disponibles` int DEFAULT '3' COMMENT 'Cambios gratuitos restantes',
  `cambios_usados` int DEFAULT '0' COMMENT 'Cambios usados esta ventana'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipos_fantasy`
--

INSERT INTO `equipos_fantasy` (`id_equipo`, `id_usuario`, `nombre_equipo`, `presupuesto`, `fecha_creacion`, `puntos_jornada`, `cambios_disponibles`, `cambios_usados`) VALUES
(1, 1, 'Equipo de Daniel', 5000000, '2026-03-23 09:57:26', 5, 3, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escuderias`
--

CREATE TABLE `escuderias` (
  `id_escuderia` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `precio_base` int NOT NULL,
  `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `escuderias`
--

INSERT INTO `escuderias` (`id_escuderia`, `nombre`, `precio_base`, `logo_url`) VALUES
(1, 'Oracle Red Bull Racing', 20000000, NULL),
(2, 'Scuderia Ferrari HP', 19000000, NULL),
(3, 'Mercedes-AMG Petronas F1 Team', 18000000, NULL),
(4, 'McLaren Mastercard F1 Team', 18500000, NULL),
(5, 'Aston Martin Aramco F1 Team', 14000000, NULL),
(6, 'BWT Alpine F1 Team', 12000000, NULL),
(7, 'Atlassian Williams F1 Team', 11000000, NULL),
(8, 'Visa Cash App Racing Bulls F1 Team', 11500000, NULL),
(9, 'TGR Haas F1 Team', 10000000, NULL),
(10, 'Audi Revolut F1 Team', 13000000, NULL),
(11, 'Cadillac Formula 1 Team', 12000000, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escuderia_equipo_fantasy`
--

CREATE TABLE `escuderia_equipo_fantasy` (
  `id_relacion` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_escuderia` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP,
  `slot` int DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_plantilla`
--

CREATE TABLE `historial_plantilla` (
  `id` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_carrera` int NOT NULL COMMENT 'Próxima carrera cuando se hizo el cambio',
  `accion` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'fichar|liberar|cambiar_capitan|fichar_escuderia|liberar_escuderia',
  `id_piloto` int DEFAULT NULL,
  `id_escuderia` int DEFAULT NULL,
  `coste_cambio` int DEFAULT '0' COMMENT 'Puntos de penalización si cambio extra',
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pilotos`
--

CREATE TABLE `pilotos` (
  `id_piloto` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `numero` int NOT NULL,
  `nacionalidad` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_escuderia` int NOT NULL,
  `precio` int NOT NULL,
  `imagen_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pilotos`
--

INSERT INTO `pilotos` (`id_piloto`, `nombre`, `numero`, `nacionalidad`, `id_escuderia`, `precio`, `imagen_url`) VALUES
(1, 'Max Verstappen', 3, 'Neerlandés', 1, 28000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png'),
(2, 'Isack Hadjar', 6, 'Francés', 1, 9000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png'),
(3, 'Charles Leclerc', 16, 'Monegasco', 2, 24000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png'),
(4, 'Lewis Hamilton', 44, 'Británico', 2, 22000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png'),
(5, 'George Russell', 63, 'Británico', 3, 20000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png'),
(6, 'Andrea Kimi Antonelli', 12, 'Italiano', 3, 11000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/v1740000001/common/f1/2026/mercedes/andant01/2026mercedesandant01right.webp'),
(7, 'Lando Norris', 1, 'Británico', 4, 25000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png'),
(8, 'Oscar Piastri', 81, 'Australiano', 4, 19000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png'),
(9, 'Fernando Alonso', 14, 'Español', 5, 16000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png'),
(10, 'Lance Stroll', 18, 'Canadiense', 5, 10000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png'),
(11, 'Pierre Gasly', 10, 'Francés', 6, 13000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png'),
(12, 'Franco Colapinto', 43, 'Argentino', 6, 9000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png'),
(13, 'Alexander Albon', 23, 'Tailandés', 7, 12000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png'),
(14, 'Carlos Sainz Jr.', 55, 'Español', 7, 17000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png'),
(15, 'Arvid Lindblad', 41, 'Británico', 8, 9000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/v1740000001/common/f1/2026/racingbulls/arvlin01/2026racingbullsarvlin01right.webp'),
(16, 'Liam Lawson', 30, 'Neozelandés', 8, 12000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png'),
(17, 'Oliver Bearman', 87, 'Británico', 9, 10000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png'),
(18, 'Esteban Ocon', 31, 'Francés', 9, 11000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png'),
(19, 'Nico Hülkenberg', 27, 'Alemán', 10, 13000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png'),
(20, 'Gabriel Bortoleto', 5, 'Brasileño', 10, 9000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png'),
(21, 'Sergio Pérez', 11, 'Mexicano', 11, 14000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/S/SERPER01_Sergio_Perez/serper01.png'),
(22, 'Valtteri Bottas', 77, 'Finlandés', 11, 10000000, 'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/V/VALBOT01_Valtteri_Bottas/valbot01.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pilotos_equipo_fantasy`
--

CREATE TABLE `pilotos_equipo_fantasy` (
  `id_piloto_equipo` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_piloto` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP,
  `es_capitan` tinyint(1) DEFAULT '0' COMMENT '1 = capitán (puntos x2)',
  `slot` int DEFAULT NULL COMMENT 'Posición en plantilla 1-5'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pilotos_equipo_fantasy`
--

INSERT INTO `pilotos_equipo_fantasy` (`id_piloto_equipo`, `id_equipo`, `id_piloto`, `fecha_inclusion`, `es_capitan`, `slot`) VALUES
(1, 1, 9, '2026-03-23 10:13:44', 1, 1),
(2, 1, 3, '2026-03-23 10:13:50', 0, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_desglose`
--

CREATE TABLE `puntos_desglose` (
  `id` int NOT NULL,
  `id_resultado` int NOT NULL,
  `criterio` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'posicion|pole|q3|q2|vuelta_rapida|sector|adelantamiento|bonus_supero|retroceso|abandono|dsq|bandera_amarilla|bandera_roja|penalizacion|termino',
  `puntos` int NOT NULL COMMENT 'Puede ser negativo',
  `descripcion` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `puntos_desglose`
--

INSERT INTO `puntos_desglose` (`id`, `id_resultado`, `criterio`, `puntos`, `descripcion`) VALUES
(1, 1, 'posicion', 25, 'P1 en carrera'),
(2, 1, 'pole', 10, 'Pole position'),
(3, 1, 'termino', 2, 'Completó la carrera'),
(4, 1, 'vuelta_rapida', 10, 'Vuelta rápida (+10 pts)'),
(5, 2, 'posicion', 18, 'P2 en carrera'),
(6, 2, 'q3', 5, 'Q3 — P3 parrilla'),
(7, 2, 'termino', 2, 'Completó la carrera'),
(8, 2, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(9, 3, 'posicion', 15, 'P3 en carrera'),
(10, 3, 'q3', 5, 'Q3 — P4 parrilla'),
(11, 3, 'termino', 2, 'Completó la carrera'),
(12, 3, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(13, 4, 'posicion', 12, 'P4 en carrera'),
(14, 4, 'q3', 5, 'Q3 — P2 parrilla'),
(15, 4, 'termino', 2, 'Completó la carrera'),
(16, 4, 'retroceso', -4, '2 pos. perdida(s) (-4 pts)'),
(17, 5, 'posicion', 10, 'P5 en carrera'),
(18, 5, 'q3', 5, 'Q3 — P5 parrilla'),
(19, 5, 'termino', 2, 'Completó la carrera'),
(20, 6, 'posicion', 8, 'P6 en carrera'),
(21, 6, 'q3', 5, 'Q3 — P6 parrilla'),
(22, 6, 'termino', 2, 'Completó la carrera'),
(23, 7, 'posicion', 6, 'P7 en carrera'),
(24, 7, 'q3', 5, 'Q3 — P7 parrilla'),
(25, 7, 'termino', 2, 'Completó la carrera'),
(26, 8, 'posicion', 4, 'P8 en carrera'),
(27, 8, 'q2', 2, 'Q2 — P11 parrilla'),
(28, 8, 'termino', 2, 'Completó la carrera'),
(29, 8, 'adelantamiento', 9, '3 pos. ganada(s) (+9 pts)'),
(30, 8, 'bonus_supero', 5, 'Bonus: superó expectativas 3-4 pos (+5 pts)'),
(31, 9, 'posicion', 2, 'P9 en carrera'),
(32, 9, 'q2', 2, 'Q2 — P14 parrilla'),
(33, 9, 'termino', 2, 'Completó la carrera'),
(34, 9, 'adelantamiento', 15, '5 pos. ganada(s) (+15 pts)'),
(35, 9, 'bonus_supero', 10, 'Bonus: superó expectativas ≥5 pos (+10 pts)'),
(36, 10, 'posicion', 1, 'P10 en carrera'),
(37, 10, 'q2', 2, 'Q2 — P12 parrilla'),
(38, 10, 'termino', 2, 'Completó la carrera'),
(39, 10, 'adelantamiento', 6, '2 pos. ganada(s) (+6 pts)'),
(40, 11, 'posicion', 2, 'P11 en carrera'),
(41, 11, 'q2', 2, 'Q2 — P13 parrilla'),
(42, 11, 'termino', 2, 'Completó la carrera'),
(43, 11, 'adelantamiento', 6, '2 pos. ganada(s) (+6 pts)'),
(44, 12, 'posicion', 2, 'P12 en carrera'),
(45, 12, 'q3', 5, 'Q3 — P8 parrilla'),
(46, 12, 'termino', 2, 'Completó la carrera'),
(47, 12, 'retroceso', -8, '4 pos. perdida(s) (-8 pts)'),
(48, 13, 'posicion', 2, 'P13 en carrera'),
(49, 13, 'q3', 5, 'Q3 — P9 parrilla'),
(50, 13, 'termino', 2, 'Completó la carrera'),
(51, 13, 'retroceso', -8, '4 pos. perdida(s) (-8 pts)'),
(52, 14, 'posicion', 2, 'P14 en carrera'),
(53, 14, 'q3', 5, 'Q3 — P10 parrilla'),
(54, 14, 'termino', 2, 'Completó la carrera'),
(55, 14, 'retroceso', -8, '4 pos. perdida(s) (-8 pts)'),
(56, 15, 'posicion', 0, 'P16 en carrera'),
(57, 15, 'q2', 2, 'Q2 — P15 parrilla'),
(58, 15, 'termino', 2, 'Completó la carrera'),
(59, 15, 'retroceso', -2, '1 pos. perdida(s) (-2 pts)'),
(60, 16, 'posicion', 0, 'P17 en carrera'),
(61, 16, 'termino', 2, 'Completó la carrera'),
(62, 16, 'adelantamiento', 6, '2 pos. ganada(s) (+6 pts)'),
(63, 17, 'abandono', -10, 'Abandono / DNF'),
(64, 18, 'abandono', -10, 'Abandono / DNF'),
(65, 19, 'abandono', -10, 'Abandono / DNF'),
(66, 20, 'abandono', -10, 'Abandono / DNF'),
(67, 21, 'abandono', -10, 'Abandono / DNF'),
(68, 22, 'posicion', 25, 'P1 en carrera'),
(69, 22, 'pole', 10, 'Pole position'),
(70, 22, 'termino', 2, 'Completó la carrera'),
(71, 22, 'vuelta_rapida', 10, 'Vuelta rápida (+10 pts)'),
(72, 23, 'posicion', 18, 'P2 en carrera'),
(73, 23, 'q3', 5, 'Q3 — P2 parrilla'),
(74, 23, 'termino', 2, 'Completó la carrera'),
(75, 24, 'posicion', 15, 'P3 en carrera'),
(76, 24, 'q3', 5, 'Q3 — P3 parrilla'),
(77, 24, 'termino', 2, 'Completó la carrera'),
(78, 25, 'posicion', 12, 'P4 en carrera'),
(79, 25, 'q3', 5, 'Q3 — P4 parrilla'),
(80, 25, 'termino', 2, 'Completó la carrera'),
(81, 26, 'posicion', 10, 'P5 en carrera'),
(82, 26, 'q3', 5, 'Q3 — P10 parrilla'),
(83, 26, 'termino', 2, 'Completó la carrera'),
(84, 26, 'adelantamiento', 15, '5 pos. ganada(s) (+15 pts)'),
(85, 26, 'bonus_supero', 10, 'Bonus: superó expectativas ≥5 pos (+10 pts)'),
(86, 27, 'posicion', 8, 'P6 en carrera'),
(87, 27, 'q3', 5, 'Q3 — P7 parrilla'),
(88, 27, 'termino', 2, 'Completó la carrera'),
(89, 27, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(90, 28, 'posicion', 6, 'P7 en carrera'),
(91, 28, 'q2', 2, 'Q2 — P14 parrilla'),
(92, 28, 'termino', 2, 'Completó la carrera'),
(93, 28, 'adelantamiento', 15, '7 pos. ganada(s) (+15 pts)'),
(94, 28, 'bonus_supero', 10, 'Bonus: superó expectativas ≥5 pos (+10 pts)'),
(95, 29, 'posicion', 4, 'P8 en carrera'),
(96, 29, 'q3', 5, 'Q3 — P9 parrilla'),
(97, 29, 'termino', 2, 'Completó la carrera'),
(98, 29, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(99, 30, 'q2', 2, 'Q2 — P12 parrilla'),
(100, 30, 'abandono', -10, 'Abandono / DNF'),
(101, 31, 'q2', 2, 'Q2 — P11 parrilla'),
(102, 31, 'abandono', -10, 'Abandono / DNF'),
(103, 32, 'q2', 2, 'Q2 — P15 parrilla'),
(104, 32, 'abandono', -10, 'Abandono / DNF'),
(105, 33, 'abandono', -10, 'Abandono / DNF'),
(106, 34, 'q2', 2, 'Q2 — P13 parrilla'),
(107, 34, 'abandono', -10, 'Abandono / DNF'),
(108, 35, 'abandono', -10, 'Abandono / DNF'),
(109, 36, 'q3', 5, 'Q3 — P8 parrilla'),
(110, 36, 'abandono', -10, 'Abandono / DNF'),
(111, 37, 'abandono', -10, 'Abandono / DNF'),
(112, 38, 'abandono', -10, 'Abandono / DNF'),
(113, 39, 'q3', 5, 'Q3 — P5 parrilla'),
(114, 39, 'abandono', -10, 'Abandono / DNF'),
(115, 40, 'q3', 5, 'Q3 — P6 parrilla'),
(116, 40, 'abandono', -10, 'Abandono / DNF'),
(117, 41, 'abandono', -10, 'Abandono / DNF'),
(118, 42, 'abandono', -10, 'Abandono / DNF'),
(119, 43, 'posicion', 25, 'P1 en carrera'),
(120, 43, 'pole', 10, 'Pole position'),
(121, 43, 'termino', 2, 'Completó la carrera'),
(122, 44, 'posicion', 18, 'P2 en carrera'),
(123, 44, 'q3', 5, 'Q3 — P2 parrilla'),
(124, 44, 'termino', 2, 'Completó la carrera'),
(125, 45, 'posicion', 15, 'P3 en carrera'),
(126, 45, 'q3', 5, 'Q3 — P4 parrilla'),
(127, 45, 'termino', 2, 'Completó la carrera'),
(128, 45, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(129, 46, 'posicion', 12, 'P4 en carrera'),
(130, 46, 'q3', 5, 'Q3 — P7 parrilla'),
(131, 46, 'termino', 2, 'Completó la carrera'),
(132, 46, 'adelantamiento', 9, '3 pos. ganada(s) (+9 pts)'),
(133, 46, 'bonus_supero', 5, 'Bonus: superó expectativas 3-4 pos (+5 pts)'),
(134, 47, 'posicion', 10, 'P5 en carrera'),
(135, 47, 'q3', 5, 'Q3 — P6 parrilla'),
(136, 47, 'termino', 2, 'Completó la carrera'),
(137, 47, 'adelantamiento', 3, '1 pos. ganada(s) (+3 pts)'),
(138, 48, 'posicion', 8, 'P6 en carrera'),
(139, 48, 'termino', 2, 'Completó la carrera'),
(140, 48, 'vuelta_rapida', 10, 'Vuelta rápida (+10 pts)'),
(141, 48, 'adelantamiento', 15, '14 pos. ganada(s) (+15 pts)'),
(142, 48, 'bonus_supero', 10, 'Bonus: superó expectativas ≥5 pos (+10 pts)'),
(143, 49, 'q2', 2, 'Q2 — P12 parrilla'),
(144, 49, 'abandono', -10, 'Abandono / DNF'),
(145, 50, 'q3', 5, 'Q3 — P9 parrilla'),
(146, 50, 'abandono', -10, 'Abandono / DNF'),
(147, 51, 'q3', 5, 'Q3 — P10 parrilla'),
(148, 51, 'abandono', -10, 'Abandono / DNF'),
(149, 52, 'q2', 2, 'Q2 — P14 parrilla'),
(150, 52, 'abandono', -10, 'Abandono / DNF'),
(151, 53, 'q2', 2, 'Q2 — P13 parrilla'),
(152, 53, 'abandono', -10, 'Abandono / DNF'),
(153, 54, 'q2', 2, 'Q2 — P15 parrilla'),
(154, 54, 'abandono', -10, 'Abandono / DNF'),
(155, 55, 'q3', 5, 'Q3 — P8 parrilla'),
(156, 55, 'abandono', -10, 'Abandono / DNF'),
(157, 56, 'abandono', -10, 'Abandono / DNF'),
(158, 57, 'abandono', -10, 'Abandono / DNF'),
(159, 58, 'abandono', -10, 'Abandono / DNF'),
(160, 59, 'abandono', -10, 'Abandono / DNF'),
(161, 60, 'abandono', -10, 'Abandono / DNF'),
(162, 61, 'q3', 5, 'Q3 — P3 parrilla'),
(163, 61, 'abandono', -10, 'Abandono / DNF'),
(164, 62, 'q3', 5, 'Q3 — P5 parrilla'),
(165, 62, 'abandono', -10, 'Abandono / DNF'),
(166, 63, 'q2', 2, 'Q2 — P11 parrilla'),
(167, 63, 'abandono', -10, 'Abandono / DNF');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_escuderia_fantasy`
--

CREATE TABLE `puntos_escuderia_fantasy` (
  `id` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_escuderia` int NOT NULL,
  `id_carrera` int NOT NULL,
  `puntos` int NOT NULL DEFAULT '0',
  `detalle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_fantasy`
--

CREATE TABLE `puntos_fantasy` (
  `id_punto` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_piloto` int NOT NULL,
  `id_carrera` int NOT NULL,
  `puntos` int NOT NULL,
  `detalle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `es_capitan` tinyint(1) DEFAULT '0' COMMENT '1 si era capitán (puntos ya duplicados)',
  `puntos_base` int DEFAULT '0' COMMENT 'Puntos antes de x2',
  `es_escuderia` tinyint(1) DEFAULT '0' COMMENT 'Reservado (no usado)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `puntos_fantasy`
--

INSERT INTO `puntos_fantasy` (`id_punto`, `id_equipo`, `id_piloto`, `id_carrera`, `puntos`, `detalle`, `es_capitan`, `puntos_base`, `es_escuderia`) VALUES
(1, 1, 3, 3, 25, 'P3 en carrera | Q3 — P4 parrilla | Completó la carrera | 1 pos. ganada(s) (+3 pts)', 0, 25, 0),
(2, 1, 9, 3, -20, 'Abandono / DNF', 1, -10, 0),
(3, 1, 3, 2, 19, 'P4 en carrera | Q3 — P4 parrilla | Completó la carrera', 0, 19, 0),
(4, 1, 9, 2, -20, 'Abandono / DNF', 1, -10, 0),
(5, 1, 3, 1, 25, 'P3 en carrera | Q3 — P4 parrilla | Completó la carrera | 1 pos. ganada(s) (+3 pts)', 0, 25, 0),
(6, 1, 9, 1, -20, 'Abandono / DNF', 1, -10, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_fantasy_carrera`
--

CREATE TABLE `puntos_fantasy_carrera` (
  `id` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_carrera` int NOT NULL,
  `puntos_brutos` int DEFAULT '0' COMMENT 'Suma pilotos + escudería sin capitán',
  `bonus_capitan` int DEFAULT '0' COMMENT 'Puntos extra por capitán (pts_cap * 1)',
  `penalizacion` int DEFAULT '0' COMMENT 'Puntos perdidos por cambios extra',
  `puntos_total` int DEFAULT '0' COMMENT 'Total final de la jornada',
  `posicion_jornada` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `puntos_fantasy_carrera`
--

INSERT INTO `puntos_fantasy_carrera` (`id`, `id_equipo`, `id_carrera`, `puntos_brutos`, `bonus_capitan`, `penalizacion`, `puntos_total`, `posicion_jornada`) VALUES
(1, 1, 3, 15, -10, 0, 5, 1),
(2, 1, 2, 9, -10, 0, -1, 1),
(3, 1, 1, 15, -10, 0, 5, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultados_carrera`
--

CREATE TABLE `resultados_carrera` (
  `id_resultado` int NOT NULL,
  `id_carrera` int NOT NULL,
  `id_piloto` int NOT NULL,
  `posicion` int DEFAULT NULL,
  `puntos_oficiales` int DEFAULT '0',
  `vuelta_rapida` tinyint(1) DEFAULT '0',
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posicion_salida` int DEFAULT NULL COMMENT 'Posición en parrilla / qualy',
  `adelantamientos` int DEFAULT '0' COMMENT 'Posiciones ganadas en carrera',
  `banderas_amarillas` int DEFAULT '0' COMMENT 'Causadas por el piloto',
  `banderas_rojas` int DEFAULT '0' COMMENT 'Causadas por el piloto',
  `penalizaciones` int DEFAULT '0' COMMENT 'Número de penalizaciones recibidas',
  `mejor_sector` tinyint(1) DEFAULT '0' COMMENT 'Consiguió el mejor sector de la carrera',
  `pole_position` tinyint(1) DEFAULT '0' COMMENT 'Salió desde la pole',
  `fuente_datos` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'manual' COMMENT 'manual|api_jolpica|api_ergast'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `resultados_carrera`
--

INSERT INTO `resultados_carrera` (`id_resultado`, `id_carrera`, `id_piloto`, `posicion`, `puntos_oficiales`, `vuelta_rapida`, `estado`, `posicion_salida`, `adelantamientos`, `banderas_amarillas`, `banderas_rojas`, `penalizaciones`, `mejor_sector`, `pole_position`, `fuente_datos`) VALUES
(1, 3, 6, 1, 25, 1, 'finished', 1, 0, 0, 0, 0, 0, 1, 'api_jolpica'),
(2, 3, 8, 2, 18, 0, 'finished', 3, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(3, 3, 3, 3, 15, 0, 'finished', 4, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(4, 3, 5, 4, 12, 0, 'finished', 2, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(5, 3, 7, 5, 10, 0, 'finished', 5, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(6, 3, 4, 6, 8, 0, 'finished', 6, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(7, 3, 11, 7, 6, 0, 'finished', 7, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(8, 3, 1, 8, 4, 0, 'finished', 11, 3, 0, 0, 0, 0, 0, 'api_jolpica'),
(9, 3, 16, 9, 2, 0, 'finished', 14, 5, 0, 0, 0, 0, 0, 'api_jolpica'),
(10, 3, 18, 10, 1, 0, 'finished', 12, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(11, 3, 19, 11, 0, 0, 'finished', 13, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(12, 3, 2, 12, 0, 0, 'finished', 8, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(13, 3, 20, 13, 0, 0, 'finished', 9, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(14, 3, 15, 14, 0, 0, 'finished', 10, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(15, 3, 12, 16, 0, 0, 'finished', 15, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(16, 3, 21, 17, 0, 0, 'finished', 19, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(17, 3, 9, 18, 0, 0, 'dnf', 21, 3, 0, 0, 0, 0, 0, 'api_jolpica'),
(18, 3, 22, 19, 0, 0, 'dnf', 20, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(19, 3, 13, 20, 0, 0, 'dnf', 17, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(20, 3, 10, 21, 0, 0, 'dnf', 22, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(21, 3, 17, 22, 0, 0, 'dnf', 18, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(22, 2, 6, 1, 25, 1, 'finished', 1, 0, 0, 0, 0, 0, 1, 'api_jolpica'),
(23, 2, 5, 2, 18, 0, 'finished', 2, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(24, 2, 4, 3, 15, 0, 'finished', 3, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(25, 2, 3, 4, 12, 0, 'finished', 4, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(26, 2, 17, 5, 10, 0, 'finished', 10, 5, 0, 0, 0, 0, 0, 'api_jolpica'),
(27, 2, 11, 6, 8, 0, 'finished', 7, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(28, 2, 16, 7, 6, 0, 'finished', 14, 7, 0, 0, 0, 0, 0, 'api_jolpica'),
(29, 2, 2, 8, 4, 0, 'finished', 9, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(30, 2, 12, 10, 1, 0, 'dnf', 12, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(31, 2, 19, 11, 0, 0, 'dnf', 11, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(32, 2, 15, 12, 0, 0, 'dnf', 15, 3, 0, 0, 0, 0, 0, 'api_jolpica'),
(33, 2, 22, 13, 0, 0, 'dnf', 20, 6, 0, 0, 0, 0, 0, 'api_jolpica'),
(34, 2, 18, 14, 0, 0, 'dnf', 13, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(35, 2, 21, 15, 0, 0, 'dnf', 22, 6, 0, 0, 0, 0, 0, 'api_jolpica'),
(36, 2, 1, 16, 0, 0, 'dnf', 8, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(37, 2, 9, 17, 0, 0, 'dnf', 19, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(38, 2, 10, 18, 0, 0, 'dnf', 21, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(39, 2, 8, 19, 0, 0, 'dnf', 5, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(40, 2, 7, 20, 0, 0, 'dnf', 6, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(41, 2, 20, 21, 0, 0, 'dnf', 16, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(42, 2, 13, 22, 0, 0, 'dnf', 18, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(43, 1, 5, 1, 25, 0, 'finished', 1, 0, 0, 0, 0, 0, 1, 'api_jolpica'),
(44, 1, 6, 2, 18, 0, 'finished', 2, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(45, 1, 3, 3, 15, 0, 'finished', 4, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(46, 1, 4, 4, 12, 0, 'finished', 7, 3, 0, 0, 0, 0, 0, 'api_jolpica'),
(47, 1, 7, 5, 10, 0, 'finished', 6, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(48, 1, 1, 6, 8, 1, 'finished', 20, 14, 0, 0, 0, 0, 0, 'api_jolpica'),
(49, 1, 17, 7, 6, 0, 'dnf', 12, 5, 0, 0, 0, 0, 0, 'api_jolpica'),
(50, 1, 15, 8, 4, 0, 'dnf', 9, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(51, 1, 20, 9, 2, 0, 'dnf', 10, 1, 0, 0, 0, 0, 0, 'api_jolpica'),
(52, 1, 11, 10, 1, 0, 'dnf', 14, 4, 0, 0, 0, 0, 0, 'api_jolpica'),
(53, 1, 18, 11, 0, 0, 'dnf', 13, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(54, 1, 13, 12, 0, 0, 'dnf', 15, 3, 0, 0, 0, 0, 0, 'api_jolpica'),
(55, 1, 16, 13, 0, 0, 'dnf', 8, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(56, 1, 12, 14, 0, 0, 'dnf', 16, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(57, 1, 21, 16, 0, 0, 'dnf', 18, 2, 0, 0, 0, 0, 0, 'api_jolpica'),
(58, 1, 10, 17, 0, 0, 'dnf', 22, 5, 0, 0, 0, 0, 0, 'api_jolpica'),
(59, 1, 9, 18, 0, 0, 'dnf', 17, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(60, 1, 22, 19, 0, 0, 'dnf', 19, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(61, 1, 2, 20, 0, 0, 'dnf', 3, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(62, 1, 8, 21, 0, 0, 'dnf', 5, 0, 0, 0, 0, 0, 0, 'api_jolpica'),
(63, 1, 19, 22, 0, 0, 'dnf', 11, 0, 0, 0, 0, 0, 0, 'api_jolpica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sync_log`
--

CREATE TABLE `sync_log` (
  `id` int NOT NULL,
  `id_carrera` int NOT NULL,
  `fecha_sync` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'ok' COMMENT 'ok|error|parcial',
  `mensaje` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sync_log`
--

INSERT INTO `sync_log` (`id`, `id_carrera`, `fecha_sync`, `estado`, `mensaje`) VALUES
(1, 3, '2026-04-20 10:21:30', 'ok', 'Procesados: 21, Errores: 0'),
(2, 2, '2026-04-20 10:21:31', 'ok', 'Procesados: 21, Errores: 0'),
(3, 1, '2026-04-20 10:21:32', 'ok', 'Procesados: 21, Errores: 0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temporadas`
--

CREATE TABLE `temporadas` (
  `id_temporada` int NOT NULL,
  `anio` int NOT NULL,
  `activa` tinyint DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `temporadas`
--

INSERT INTO `temporadas` (`id_temporada`, `anio`, `activa`) VALUES
(1, 2026, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `contrasena_hash`, `fecha_registro`) VALUES
(1, 'Daniel', 'ejemplo@ejemplo.com', '$2y$12$nynXzVUzSSmush58tA1gzOk8/FCFEYbNx9ZgCWI08H9yCPRrKSqOi', '2026-03-23 09:57:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventana_mercado`
--

CREATE TABLE `ventana_mercado` (
  `id` int NOT NULL,
  `id_carrera_desde` int NOT NULL COMMENT 'Abierta después de esta carrera',
  `id_carrera_hasta` int NOT NULL COMMENT 'Cierra antes de esta carrera',
  `abierto` tinyint(1) DEFAULT '1',
  `cambios_gratis` int DEFAULT '3' COMMENT 'Cambios gratuitos en esta ventana',
  `coste_extra` int DEFAULT '4' COMMENT 'Puntos perdidos por cambio extra'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventana_mercado`
--

INSERT INTO `ventana_mercado` (`id`, `id_carrera_desde`, `id_carrera_hasta`, `abierto`, `cambios_gratis`, `coste_extra`) VALUES
(1, 1, 2, 1, 3, 4),
(2, 2, 3, 1, 3, 4),
(3, 3, 4, 1, 3, 4),
(4, 4, 5, 1, 3, 4),
(5, 5, 6, 1, 3, 4),
(6, 6, 7, 1, 3, 4),
(7, 7, 8, 1, 3, 4),
(8, 8, 9, 1, 3, 4),
(9, 9, 10, 1, 3, 4),
(10, 10, 11, 1, 3, 4),
(11, 11, 12, 1, 3, 4),
(12, 12, 13, 1, 3, 4),
(13, 13, 14, 1, 3, 4),
(14, 14, 15, 1, 3, 4),
(15, 15, 16, 1, 3, 4),
(16, 16, 17, 1, 3, 4),
(17, 17, 18, 1, 3, 4),
(18, 18, 19, 1, 3, 4),
(19, 19, 20, 1, 3, 4),
(20, 20, 21, 1, 3, 4),
(21, 21, 22, 1, 3, 4),
(22, 22, 23, 1, 3, 4),
(23, 23, 24, 1, 3, 4);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id_carrera`),
  ADD KEY `id_temporada` (`id_temporada`);

--
-- Indices de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD PRIMARY KEY (`id_clasificacion`),
  ADD UNIQUE KEY `id_equipo` (`id_equipo`);

--
-- Indices de la tabla `equipos_fantasy`
--
ALTER TABLE `equipos_fantasy`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `escuderias`
--
ALTER TABLE `escuderias`
  ADD PRIMARY KEY (`id_escuderia`);

--
-- Indices de la tabla `escuderia_equipo_fantasy`
--
ALTER TABLE `escuderia_equipo_fantasy`
  ADD PRIMARY KEY (`id_relacion`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_escuderia` (`id_escuderia`);

--
-- Indices de la tabla `historial_plantilla`
--
ALTER TABLE `historial_plantilla`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `pilotos`
--
ALTER TABLE `pilotos`
  ADD PRIMARY KEY (`id_piloto`),
  ADD KEY `id_escuderia` (`id_escuderia`);

--
-- Indices de la tabla `pilotos_equipo_fantasy`
--
ALTER TABLE `pilotos_equipo_fantasy`
  ADD PRIMARY KEY (`id_piloto_equipo`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_piloto` (`id_piloto`);

--
-- Indices de la tabla `puntos_desglose`
--
ALTER TABLE `puntos_desglose`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_resultado` (`id_resultado`);

--
-- Indices de la tabla `puntos_escuderia_fantasy`
--
ALTER TABLE `puntos_escuderia_fantasy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_escuderia` (`id_escuderia`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `puntos_fantasy`
--
ALTER TABLE `puntos_fantasy`
  ADD PRIMARY KEY (`id_punto`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_piloto` (`id_piloto`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `puntos_fantasy_carrera`
--
ALTER TABLE `puntos_fantasy_carrera`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipo_carrera` (`id_equipo`,`id_carrera`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `resultados_carrera`
--
ALTER TABLE `resultados_carrera`
  ADD PRIMARY KEY (`id_resultado`),
  ADD KEY `id_carrera` (`id_carrera`),
  ADD KEY `id_piloto` (`id_piloto`);

--
-- Indices de la tabla `sync_log`
--
ALTER TABLE `sync_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `temporadas`
--
ALTER TABLE `temporadas`
  ADD PRIMARY KEY (`id_temporada`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `ventana_mercado`
--
ALTER TABLE `ventana_mercado`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  MODIFY `id_clasificacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `equipos_fantasy`
--
ALTER TABLE `equipos_fantasy`
  MODIFY `id_equipo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `escuderias`
--
ALTER TABLE `escuderias`
  MODIFY `id_escuderia` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `escuderia_equipo_fantasy`
--
ALTER TABLE `escuderia_equipo_fantasy`
  MODIFY `id_relacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_plantilla`
--
ALTER TABLE `historial_plantilla`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pilotos`
--
ALTER TABLE `pilotos`
  MODIFY `id_piloto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `pilotos_equipo_fantasy`
--
ALTER TABLE `pilotos_equipo_fantasy`
  MODIFY `id_piloto_equipo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `puntos_desglose`
--
ALTER TABLE `puntos_desglose`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- AUTO_INCREMENT de la tabla `puntos_escuderia_fantasy`
--
ALTER TABLE `puntos_escuderia_fantasy`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `puntos_fantasy`
--
ALTER TABLE `puntos_fantasy`
  MODIFY `id_punto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `puntos_fantasy_carrera`
--
ALTER TABLE `puntos_fantasy_carrera`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `resultados_carrera`
--
ALTER TABLE `resultados_carrera`
  MODIFY `id_resultado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT de la tabla `sync_log`
--
ALTER TABLE `sync_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `temporadas`
--
ALTER TABLE `temporadas`
  MODIFY `id_temporada` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventana_mercado`
--
ALTER TABLE `ventana_mercado`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD CONSTRAINT `carreras_ibfk_1` FOREIGN KEY (`id_temporada`) REFERENCES `temporadas` (`id_temporada`);

--
-- Filtros para la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD CONSTRAINT `clasificacion_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`);

--
-- Filtros para la tabla `equipos_fantasy`
--
ALTER TABLE `equipos_fantasy`
  ADD CONSTRAINT `equipos_fantasy_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `escuderia_equipo_fantasy`
--
ALTER TABLE `escuderia_equipo_fantasy`
  ADD CONSTRAINT `escuderia_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `escuderia_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`);

--
-- Filtros para la tabla `pilotos`
--
ALTER TABLE `pilotos`
  ADD CONSTRAINT `pilotos_ibfk_1` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`);

--
-- Filtros para la tabla `pilotos_equipo_fantasy`
--
ALTER TABLE `pilotos_equipo_fantasy`
  ADD CONSTRAINT `pilotos_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `pilotos_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`);

--
-- Filtros para la tabla `puntos_desglose`
--
ALTER TABLE `puntos_desglose`
  ADD CONSTRAINT `desglose_ibfk_1` FOREIGN KEY (`id_resultado`) REFERENCES `resultados_carrera` (`id_resultado`) ON DELETE CASCADE;

--
-- Filtros para la tabla `puntos_fantasy`
--
ALTER TABLE `puntos_fantasy`
  ADD CONSTRAINT `puntos_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `puntos_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`),
  ADD CONSTRAINT `puntos_fantasy_ibfk_3` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`);

--
-- Filtros para la tabla `resultados_carrera`
--
ALTER TABLE `resultados_carrera`
  ADD CONSTRAINT `resultados_carrera_ibfk_1` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`),
  ADD CONSTRAINT `resultados_carrera_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
