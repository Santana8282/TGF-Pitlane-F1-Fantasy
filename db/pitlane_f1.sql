-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 08-03-2026
-- Versión del servidor: 8.0.44
-- Versión de PHP: 8.2.29
--
-- Base de datos: `pitlane f1`
-- Temporada 2026 - Datos completos

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------
-- Estructura de tabla `carreras`
-- --------------------------------------------------------

CREATE TABLE `carreras` (
  `id_carrera` int NOT NULL,
  `id_temporada` int NOT NULL,
  `numero_carrera` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `circuito` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `clasificacion`
-- --------------------------------------------------------

CREATE TABLE `clasificacion` (
  `id_clasificacion` int NOT NULL,
  `id_equipo` int NOT NULL,
  `puntos_totales` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `equipos_fantasy`
-- --------------------------------------------------------

CREATE TABLE `equipos_fantasy` (
  `id_equipo` int NOT NULL,
  `id_usuario` int NOT NULL,
  `nombre_equipo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `presupuesto` int DEFAULT '100000000',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `escuderias`
-- --------------------------------------------------------

CREATE TABLE `escuderias` (
  `id_escuderia` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `precio_base` int NOT NULL,
  `logo_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `escuderia_equipo_fantasy`
-- --------------------------------------------------------

CREATE TABLE `escuderia_equipo_fantasy` (
  `id_relacion` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_escuderia` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `pilotos`
-- --------------------------------------------------------

CREATE TABLE `pilotos` (
  `id_piloto` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `numero` int NOT NULL,
  `nacionalidad` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_escuderia` int NOT NULL,
  `precio` int NOT NULL,
  `imagen_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `pilotos_equipo_fantasy`
-- --------------------------------------------------------

CREATE TABLE `pilotos_equipo_fantasy` (
  `id_piloto_equipo` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_piloto` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `puntos_fantasy`
-- --------------------------------------------------------

CREATE TABLE `puntos_fantasy` (
  `id_punto` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_piloto` int NOT NULL,
  `id_carrera` int NOT NULL,
  `puntos` int NOT NULL,
  `detalle` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `resultados_carrera`
-- --------------------------------------------------------

CREATE TABLE `resultados_carrera` (
  `id_resultado` int NOT NULL,
  `id_carrera` int NOT NULL,
  `id_piloto` int NOT NULL,
  `posicion` int DEFAULT NULL,
  `puntos_oficiales` int DEFAULT '0',
  `vuelta_rapida` tinyint(1) DEFAULT '0',
  `estado` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `temporadas`
-- --------------------------------------------------------

CREATE TABLE `temporadas` (
  `id_temporada` int NOT NULL,
  `anio` int NOT NULL,
  `activa` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Estructura de tabla `usuarios`
-- --------------------------------------------------------

CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- DATOS: TEMPORADA F1 2026
-- ============================================================

-- --------------------------------------------------------
-- Temporada 2026 (activa)
-- --------------------------------------------------------

INSERT INTO `temporadas` (`id_temporada`, `anio`, `activa`) VALUES
(1, 2026, 1);

-- --------------------------------------------------------
-- Escuderías F1 2026 (11 equipos)
-- precio_base expresado en unidades de presupuesto fantasy
-- --------------------------------------------------------

INSERT INTO `escuderias` (`id_escuderia`, `nombre`, `precio_base`, `logo_url`) VALUES
(1,  'McLaren Mercedes',          35000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/mclaren-logo.png'),
(2,  'Mercedes AMG Petronas',     30000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/mercedes-logo.png'),
(3,  'Oracle Red Bull Racing',    28000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/red-bull-logo.png'),
(4,  'Scuderia Ferrari HP',       27000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/ferrari-logo.png'),
(5,  'Williams Racing',           18000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/williams-logo.png'),
(6,  'Visa Cash App RB',          17000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/racing-bulls-logo.png'),
(7,  'Aston Martin Aramco',       20000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/aston-martin-logo.png'),
(8,  'MoneyGram Haas F1 Team',    15000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/haas-logo.png'),
(9,  'Audi F1 Team',              16000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/audi-logo.png'),
(10, 'BWT Alpine F1 Team',        14000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/alpine-logo.png'),
(11, 'Cadillac F1 Team',          12000000, 'https://www.formula1.com/content/dam/fom-website/teams/2026/cadillac-logo.png');

-- --------------------------------------------------------
-- Pilotos F1 2026 (22 pilotos, 2 por equipo)
-- precio expresado en unidades de presupuesto fantasy
-- --------------------------------------------------------

INSERT INTO `pilotos` (`id_piloto`, `nombre`, `numero`, `nacionalidad`, `id_escuderia`, `precio`, `imagen_url`) VALUES
-- 1. McLaren Mercedes
(1,  'Lando Norris',        1,  'Británico',    1,  30000000, 'https://www.formula1.com/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png'),
(2,  'Oscar Piastri',       81, 'Australiano',  1,  28000000, 'https://www.formula1.com/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png'),

-- 2. Mercedes AMG Petronas
(3,  'George Russell',      63, 'Británico',    2,  27000000, 'https://www.formula1.com/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png'),
(4,  'Kimi Antonelli',      12, 'Italiano',     2,  20000000, 'https://www.formula1.com/content/dam/fom-website/drivers/A/ANTKIM01_Kimi_Antonelli/antkim01.png'),

-- 3. Oracle Red Bull Racing
(5,  'Max Verstappen',      3,  'Neerlandés',   3,  30000000, 'https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png'),
(6,  'Isack Hadjar',        6,  'Francés',      3,  18000000, 'https://www.formula1.com/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png'),

-- 4. Scuderia Ferrari HP
(7,  'Charles Leclerc',     16, 'Monegasco',    4,  27000000, 'https://www.formula1.com/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png'),
(8,  'Lewis Hamilton',      44, 'Británico',    4,  26000000, 'https://www.formula1.com/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png'),

-- 5. Williams Racing
(9,  'Carlos Sainz',        55, 'Español',      5,  22000000, 'https://www.formula1.com/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png'),
(10, 'Alexander Albon',     23, 'Tailandés',    5,  18000000, 'https://www.formula1.com/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png'),

-- 6. Visa Cash App RB (Racing Bulls)
(11, 'Liam Lawson',         30, 'Neozelandés',  6,  17000000, 'https://www.formula1.com/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png'),
(12, 'Arvid Lindblad',      41, 'Sueco',        6,  14000000, 'https://www.formula1.com/content/dam/fom-website/drivers/A/ARVLIN01_Arvid_Lindblad/arvlin01.png'),

-- 7. Aston Martin Aramco
(13, 'Fernando Alonso',     14, 'Español',      7,  20000000, 'https://www.formula1.com/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png'),
(14, 'Lance Stroll',        18, 'Canadiense',   7,  15000000, 'https://www.formula1.com/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png'),

-- 8. MoneyGram Haas F1 Team
(15, 'Esteban Ocon',        31, 'Francés',      8,  15000000, 'https://www.formula1.com/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png'),
(16, 'Oliver Bearman',      87, 'Británico',    8,  14000000, 'https://www.formula1.com/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png'),

-- 9. Audi F1 Team
(17, 'Nico Hülkenberg',     27, 'Alemán',       9,  16000000, 'https://www.formula1.com/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png'),
(18, 'Gabriel Bortoleto',   5,  'Brasileño',    9,  15000000, 'https://www.formula1.com/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png'),

-- 10. BWT Alpine F1 Team
(19, 'Pierre Gasly',        10, 'Francés',      10, 16000000, 'https://www.formula1.com/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png'),
(20, 'Franco Colapinto',    43, 'Argentino',    10, 13000000, 'https://www.formula1.com/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png'),

-- 11. Cadillac F1 Team (nuevo equipo 2026)
(21, 'Valtteri Bottas',     77, 'Finlandés',    11, 13000000, 'https://www.formula1.com/content/dam/fom-website/drivers/V/VALBOT01_Valtteri_Bottas/valbot01.png'),
(22, 'Sergio Pérez',        11, 'Mexicano',     11, 13000000, 'https://www.formula1.com/content/dam/fom-website/drivers/S/SERPER01_Sergio_Perez/serper01.png');

-- --------------------------------------------------------
-- Carreras F1 2026 (24 Grandes Premios)
-- Las fechas corresponden al día de la carrera (domingo)
-- --------------------------------------------------------

INSERT INTO `carreras` (`id_carrera`, `id_temporada`, `numero_carrera`, `nombre`, `circuito`, `fecha`) VALUES
(1,  1,  1,  'GP de Australia',            'Albert Park Circuit, Melbourne',                '2026-03-08'),
(2,  1,  2,  'GP de China',                'Shanghai International Circuit',                '2026-03-15'),
(3,  1,  3,  'GP de Japón',                'Suzuka International Racing Course',             '2026-03-29'),
(4,  1,  4,  'GP de Baréin',               'Bahrain International Circuit, Sakhir',          '2026-04-12'),
(5,  1,  5,  'GP de Arabia Saudí',         'Jeddah Corniche Circuit',                        '2026-04-19'),
(6,  1,  6,  'GP de Miami',                'Miami International Autodrome',                  '2026-05-03'),
(7,  1,  7,  'GP de Canadá',               'Circuit Gilles Villeneuve, Montreal',            '2026-05-24'),
(8,  1,  8,  'GP de Mónaco',               'Circuit de Monaco',                              '2026-06-07'),
(9,  1,  9,  'GP de España - Barcelona',   'Circuit de Barcelona-Catalunya',                 '2026-06-14'),
(10, 1, 10,  'GP de Austria',              'Red Bull Ring, Spielberg',                       '2026-06-28'),
(11, 1, 11,  'GP de Gran Bretaña',         'Silverstone Circuit',                            '2026-07-05'),
(12, 1, 12,  'GP de Bélgica',              'Circuit de Spa-Francorchamps',                   '2026-07-19'),
(13, 1, 13,  'GP de Hungría',              'Hungaroring, Budapest',                          '2026-07-26'),
(14, 1, 14,  'GP de Países Bajos',         'Circuit Zandvoort',                              '2026-08-23'),
(15, 1, 15,  'GP de Italia',               'Autodromo Nazionale di Monza',                   '2026-09-06'),
(16, 1, 16,  'GP de España - Madrid',      'Circuito Madring, Madrid',                       '2026-09-13'),
(17, 1, 17,  'GP de Azerbaiyán',           'Baku City Circuit',                              '2026-09-26'),
(18, 1, 18,  'GP de Singapur',             'Marina Bay Street Circuit',                      '2026-10-11'),
(19, 1, 19,  'GP de Estados Unidos',       'Circuit of the Americas, Austin',                '2026-10-25'),
(20, 1, 20,  'GP de México',               'Autodromo Hermanos Rodriguez, Ciudad de Mexico', '2026-11-01'),
(21, 1, 21,  'GP de Brasil',               'Autodromo Jose Carlos Pace, Sao Paulo',          '2026-11-08'),
(22, 1, 22,  'GP de Las Vegas',            'Las Vegas Strip Circuit',                        '2026-11-21'),
(23, 1, 23,  'GP de Catar',                'Lusail International Circuit',                   '2026-11-29'),
(24, 1, 24,  'GP de Abu Dabi',             'Yas Marina Circuit',                             '2026-12-06');

-- ============================================================
-- ÍNDICES Y CLAVES PRIMARIAS
-- ============================================================

ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id_carrera`),
  ADD KEY `id_temporada` (`id_temporada`);

ALTER TABLE `clasificacion`
  ADD PRIMARY KEY (`id_clasificacion`),
  ADD UNIQUE KEY `id_equipo` (`id_equipo`);

ALTER TABLE `equipos_fantasy`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `id_usuario` (`id_usuario`);

ALTER TABLE `escuderias`
  ADD PRIMARY KEY (`id_escuderia`);

ALTER TABLE `escuderia_equipo_fantasy`
  ADD PRIMARY KEY (`id_relacion`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_escuderia` (`id_escuderia`);

ALTER TABLE `pilotos`
  ADD PRIMARY KEY (`id_piloto`),
  ADD KEY `id_escuderia` (`id_escuderia`);

ALTER TABLE `pilotos_equipo_fantasy`
  ADD PRIMARY KEY (`id_piloto_equipo`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_piloto` (`id_piloto`);

ALTER TABLE `puntos_fantasy`
  ADD PRIMARY KEY (`id_punto`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_piloto` (`id_piloto`),
  ADD KEY `id_carrera` (`id_carrera`);

ALTER TABLE `resultados_carrera`
  ADD PRIMARY KEY (`id_resultado`),
  ADD KEY `id_carrera` (`id_carrera`),
  ADD KEY `id_piloto` (`id_piloto`);

ALTER TABLE `temporadas`
  ADD PRIMARY KEY (`id_temporada`);

ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

-- ============================================================
-- AUTO_INCREMENT
-- ============================================================

ALTER TABLE `carreras`
  MODIFY `id_carrera` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

ALTER TABLE `clasificacion`
  MODIFY `id_clasificacion` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `equipos_fantasy`
  MODIFY `id_equipo` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `escuderias`
  MODIFY `id_escuderia` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

ALTER TABLE `escuderia_equipo_fantasy`
  MODIFY `id_relacion` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `pilotos`
  MODIFY `id_piloto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

ALTER TABLE `pilotos_equipo_fantasy`
  MODIFY `id_piloto_equipo` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `puntos_fantasy`
  MODIFY `id_punto` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `resultados_carrera`
  MODIFY `id_resultado` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `temporadas`
  MODIFY `id_temporada` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT;

-- ============================================================
-- RESTRICCIONES (FOREIGN KEYS)
-- ============================================================

ALTER TABLE `carreras`
  ADD CONSTRAINT `carreras_ibfk_1` FOREIGN KEY (`id_temporada`) REFERENCES `temporadas` (`id_temporada`);

ALTER TABLE `clasificacion`
  ADD CONSTRAINT `clasificacion_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`);

ALTER TABLE `equipos_fantasy`
  ADD CONSTRAINT `equipos_fantasy_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

ALTER TABLE `escuderia_equipo_fantasy`
  ADD CONSTRAINT `escuderia_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `escuderia_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`);

ALTER TABLE `pilotos`
  ADD CONSTRAINT `pilotos_ibfk_1` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`);

ALTER TABLE `pilotos_equipo_fantasy`
  ADD CONSTRAINT `pilotos_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `pilotos_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`);

ALTER TABLE `puntos_fantasy`
  ADD CONSTRAINT `puntos_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  ADD CONSTRAINT `puntos_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`),
  ADD CONSTRAINT `puntos_fantasy_ibfk_3` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`);

ALTER TABLE `resultados_carrera`
  ADD CONSTRAINT `resultados_carrera_ibfk_1` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`),
  ADD CONSTRAINT `resultados_carrera_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
