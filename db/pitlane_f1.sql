-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 15-02-2026 a las 15:31:20
-- Versión del servidor: 8.0.44
-- Versión de PHP: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pitlane f1`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreras`
--

CREATE TABLE `carreras` (
  `id_carrera` int NOT NULL,
  `id_temporada` int NOT NULL,
  `numero_carrera` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `circuito` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `nombre_equipo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `presupuesto` int DEFAULT '100000000',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escuderias`
--

CREATE TABLE `escuderias` (
  `id_escuderia` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `precio_base` int NOT NULL,
  `logo_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escuderia_equipo_fantasy`
--

CREATE TABLE `escuderia_equipo_fantasy` (
  `id_relacion` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_escuderia` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pilotos`
--

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

--
-- Estructura de tabla para la tabla `pilotos_equipo_fantasy`
--

CREATE TABLE `pilotos_equipo_fantasy` (
  `id_piloto_equipo` int NOT NULL,
  `id_equipo` int NOT NULL,
  `id_piloto` int NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP
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
  `detalle` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `estado` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temporadas`
--

CREATE TABLE `temporadas` (
  `id_temporada` int NOT NULL,
  `anio` int NOT NULL,
  `activa` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Indices de la tabla `puntos_fantasy`
--
ALTER TABLE `puntos_fantasy`
  ADD PRIMARY KEY (`id_punto`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_piloto` (`id_piloto`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `resultados_carrera`
--
ALTER TABLE `resultados_carrera`
  ADD PRIMARY KEY (`id_resultado`),
  ADD KEY `id_carrera` (`id_carrera`),
  ADD KEY `id_piloto` (`id_piloto`);

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
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  MODIFY `id_clasificacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `equipos_fantasy`
--
ALTER TABLE `equipos_fantasy`
  MODIFY `id_equipo` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `escuderias`
--
ALTER TABLE `escuderias`
  MODIFY `id_escuderia` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `escuderia_equipo_fantasy`
--
ALTER TABLE `escuderia_equipo_fantasy`
  MODIFY `id_relacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pilotos`
--
ALTER TABLE `pilotos`
  MODIFY `id_piloto` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pilotos_equipo_fantasy`
--
ALTER TABLE `pilotos_equipo_fantasy`
  MODIFY `id_piloto_equipo` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `puntos_fantasy`
--
ALTER TABLE `puntos_fantasy`
  MODIFY `id_punto` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resultados_carrera`
--
ALTER TABLE `resultados_carrera`
  MODIFY `id_resultado` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `temporadas`
--
ALTER TABLE `temporadas`
  MODIFY `id_temporada` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT;

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
