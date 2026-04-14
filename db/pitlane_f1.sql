
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
CREATE DATABASE IF NOT EXISTS `pitlane_f1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pitlane_f1`;


CREATE TABLE `temporadas` (
  `id_temporada` int NOT NULL AUTO_INCREMENT,
  `anio` int NOT NULL,
  `activa` tinyint DEFAULT 0,
  PRIMARY KEY (`id_temporada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `temporadas` VALUES (1,2026,1);
ALTER TABLE `temporadas` MODIFY `id_temporada` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

CREATE TABLE `carreras` (
  `id_carrera`     int         NOT NULL AUTO_INCREMENT,
  `id_temporada`   int         NOT NULL,
  `numero_carrera` int         NOT NULL,
  `nombre`         varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `circuito`       varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha`          date        NOT NULL,
  PRIMARY KEY (`id_carrera`),
  KEY `id_temporada` (`id_temporada`),
  CONSTRAINT `carreras_ibfk_1` FOREIGN KEY (`id_temporada`) REFERENCES `temporadas` (`id_temporada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `carreras` VALUES
(1,1,1,'Gran Premio de Australia','Albert Park','2026-03-08'),
(2,1,2,'Gran Premio de China','Shanghái','2026-03-15'),
(3,1,3,'Gran Premio de Japón','Suzuka','2026-03-29'),
(4,1,4,'Gran Premio de Miami','Miami International','2026-05-03'),
(5,1,5,'Gran Premio de Canadá','Gilles Villeneuve','2026-05-24'),
(6,1,6,'Gran Premio de Mónaco','Mónaco','2026-06-07'),
(7,1,7,'Gran Premio de Barcelona-Catalunya','Montmeló','2026-06-14'),
(8,1,8,'Gran Premio de Austria','Red Bull Ring','2026-06-28'),
(9,1,9,'Gran Premio de Gran Bretaña','Silverstone','2026-07-05'),
(10,1,10,'Gran Premio de Bélgica','Spa-Francorchamps','2026-07-19'),
(11,1,11,'Gran Premio de Hungría','Hungaroring','2026-07-26'),
(12,1,12,'Gran Premio de Países Bajos','Zandvoort','2026-08-23'),
(13,1,13,'Gran Premio de Italia','Monza','2026-09-06'),
(14,1,14,'Gran Premio de España','Madring','2026-09-13'),
(15,1,15,'Gran Premio de Azerbaiyán','Bakú','2026-09-26'),
(16,1,16,'Gran Premio de Singapur','Marina Bay','2026-10-11'),
(17,1,17,'Gran Premio de Austin','Circuit of the Americas','2026-10-25'),
(18,1,18,'Gran Premio de México','Hermanos Rodríguez','2026-11-01'),
(19,1,19,'Gran Premio de Brasil','Interlagos','2026-11-08'),
(20,1,20,'Gran Premio de Las Vegas','Las Vegas Strip','2026-11-21'),
(21,1,21,'Gran Premio de Qatar','Lusail','2026-11-29'),
(22,1,22,'Gran Premio de Abu Dabi','Yas Marina','2026-12-06');
ALTER TABLE `carreras` MODIFY `id_carrera` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

CREATE TABLE `usuarios` (
  `id_usuario`      int          NOT NULL AUTO_INCREMENT,
  `nombre`          varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `correo`          varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_registro`  datetime     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `usuarios` VALUES (1,'Daniel','ejemplo@ejemplo.com','$2y$12$nynXzVUzSSmush58tA1gzOk8/FCFEYbNx9ZgCWI08H9yCPRrKSqOi','2026-03-23 09:57:26');
ALTER TABLE `usuarios` MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

CREATE TABLE `escuderias` (
  `id_escuderia` int          NOT NULL AUTO_INCREMENT,
  `nombre`       varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `precio_base`  int          NOT NULL,
  `logo_url`     varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_escuderia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `escuderias` VALUES
(1,'Oracle Red Bull Racing',20000000,NULL),
(2,'Scuderia Ferrari HP',19000000,NULL),
(3,'Mercedes-AMG Petronas F1 Team',18000000,NULL),
(4,'McLaren Mastercard F1 Team',18500000,NULL),
(5,'Aston Martin Aramco F1 Team',14000000,NULL),
(6,'BWT Alpine F1 Team',12000000,NULL),
(7,'Atlassian Williams F1 Team',11000000,NULL),
(8,'Visa Cash App Racing Bulls F1 Team',11500000,NULL),
(9,'TGR Haas F1 Team',10000000,NULL),
(10,'Audi Revolut F1 Team',13000000,NULL),
(11,'Cadillac Formula 1 Team',12000000,NULL);
ALTER TABLE `escuderias` MODIFY `id_escuderia` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

CREATE TABLE `pilotos` (
  `id_piloto`    int          NOT NULL AUTO_INCREMENT,
  `nombre`       varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `numero`       int          NOT NULL,
  `nacionalidad` varchar(50)  COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_escuderia` int          NOT NULL,
  `precio`       int          NOT NULL,
  `imagen_url`   varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_piloto`),
  KEY `id_escuderia` (`id_escuderia`),
  CONSTRAINT `pilotos_ibfk_1` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `pilotos` VALUES
(1,'Max Verstappen',3,'Neerlandés',1,28000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png'),
(2,'Isack Hadjar',6,'Francés',1,9000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png'),
(3,'Charles Leclerc',16,'Monegasco',2,24000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png'),
(4,'Lewis Hamilton',44,'Británico',2,22000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png'),
(5,'George Russell',63,'Británico',3,20000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png'),
(6,'Andrea Kimi Antonelli',12,'Italiano',3,11000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/A/ANDANT01_Andrea_Kimi_Antonelli/andant01.png'),
(7,'Lando Norris',1,'Británico',4,25000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png'),
(8,'Oscar Piastri',81,'Australiano',4,19000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png'),
(9,'Fernando Alonso',14,'Español',5,16000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png'),
(10,'Lance Stroll',18,'Canadiense',5,10000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png'),
(11,'Pierre Gasly',10,'Francés',6,13000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png'),
(12,'Franco Colapinto',43,'Argentino',6,9000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png'),
(13,'Alexander Albon',23,'Tailandés',7,12000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png'),
(14,'Carlos Sainz Jr.',55,'Español',7,17000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png'),
(15,'Arvid Lindblad',41,'Británico',8,9000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/A/ARVLIN01_Arvid_Lindblad/arvlin01.png'),
(16,'Liam Lawson',30,'Neozelandés',8,12000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png'),
(17,'Oliver Bearman',87,'Británico',9,10000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png'),
(18,'Esteban Ocon',31,'Francés',9,11000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png'),
(19,'Nico Hülkenberg',27,'Alemán',10,13000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png'),
(20,'Gabriel Bortoleto',5,'Brasileño',10,9000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png'),
(21,'Sergio Pérez',11,'Mexicano',11,14000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/S/SERPER01_Sergio_Perez/serper01.png'),
(22,'Valtteri Bottas',77,'Finlandés',11,10000000,'https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_440/content/dam/fom-website/drivers/V/VALBOT01_Valtteri_Bottas/valbot01.png');
ALTER TABLE `pilotos` MODIFY `id_piloto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

CREATE TABLE `equipos_fantasy` (
  `id_equipo`          int          NOT NULL AUTO_INCREMENT,
  `id_usuario`         int          NOT NULL,
  `nombre_equipo`      varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `presupuesto`        int          DEFAULT 100000000,
  `fecha_creacion`     datetime     DEFAULT CURRENT_TIMESTAMP,
  `puntos_jornada`     int          DEFAULT 0   COMMENT 'Puntos en la última carrera',
  `cambios_disponibles` int         DEFAULT 3   COMMENT 'Cambios gratuitos restantes',
  `cambios_usados`     int          DEFAULT 0   COMMENT 'Cambios usados esta ventana',
  PRIMARY KEY (`id_equipo`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `equipos_fantasy_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `equipos_fantasy` (`id_equipo`,`id_usuario`,`nombre_equipo`,`presupuesto`,`fecha_creacion`) VALUES
(1,1,'Equipo de Daniel',60000000,'2026-03-23 09:57:26');
ALTER TABLE `equipos_fantasy` MODIFY `id_equipo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

CREATE TABLE `clasificacion` (
  `id_clasificacion` int NOT NULL AUTO_INCREMENT,
  `id_equipo`        int NOT NULL,
  `puntos_totales`   int DEFAULT 0,
  PRIMARY KEY (`id_clasificacion`),
  UNIQUE KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `clasificacion_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `clasificacion` MODIFY `id_clasificacion` int NOT NULL AUTO_INCREMENT;

CREATE TABLE `escuderia_equipo_fantasy` (
  `id_relacion`    int      NOT NULL AUTO_INCREMENT,
  `id_equipo`      int      NOT NULL,
  `id_escuderia`   int      NOT NULL,
  `fecha_inclusion` datetime DEFAULT CURRENT_TIMESTAMP,
  `slot`           int      DEFAULT 1,
  PRIMARY KEY (`id_relacion`),
  KEY `id_equipo`    (`id_equipo`),
  KEY `id_escuderia` (`id_escuderia`),
  CONSTRAINT `escuderia_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`)    REFERENCES `equipos_fantasy` (`id_equipo`),
  CONSTRAINT `escuderia_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_escuderia`) REFERENCES `escuderias` (`id_escuderia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `escuderia_equipo_fantasy` MODIFY `id_relacion` int NOT NULL AUTO_INCREMENT;

CREATE TABLE `pilotos_equipo_fantasy` (
  `id_piloto_equipo` int       NOT NULL AUTO_INCREMENT,
  `id_equipo`        int       NOT NULL,
  `id_piloto`        int       NOT NULL,
  `fecha_inclusion`  datetime  DEFAULT CURRENT_TIMESTAMP,
  `es_capitan`       tinyint(1) DEFAULT 0  COMMENT '1 = capitán (puntos x2)',
  `slot`             int        DEFAULT NULL COMMENT 'Posición en plantilla 1-5',
  PRIMARY KEY (`id_piloto_equipo`),
  KEY `id_equipo` (`id_equipo`),
  KEY `id_piloto` (`id_piloto`),
  CONSTRAINT `pilotos_equipo_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos_fantasy` (`id_equipo`),
  CONSTRAINT `pilotos_equipo_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos`         (`id_piloto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `pilotos_equipo_fantasy` (`id_piloto_equipo`,`id_equipo`,`id_piloto`,`fecha_inclusion`,`es_capitan`,`slot`) VALUES
(1,1,9,'2026-03-23 10:13:44',1,1),
(2,1,3,'2026-03-23 10:13:50',0,2);
ALTER TABLE `pilotos_equipo_fantasy` MODIFY `id_piloto_equipo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

CREATE TABLE `resultados_carrera` (
  `id_resultado`       int         NOT NULL AUTO_INCREMENT,
  `id_carrera`         int         NOT NULL,
  `id_piloto`          int         NOT NULL,
  `posicion`           int         DEFAULT NULL,
  `puntos_oficiales`   int         DEFAULT 0,
  `vuelta_rapida`      tinyint(1)  DEFAULT 0,
  `estado`             varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posicion_salida`    int         DEFAULT NULL COMMENT 'Posición en parrilla / qualy',
  `adelantamientos`    int         DEFAULT 0   COMMENT 'Posiciones ganadas en carrera',
  `banderas_amarillas` int         DEFAULT 0   COMMENT 'Causadas por el piloto',
  `banderas_rojas`     int         DEFAULT 0   COMMENT 'Causadas por el piloto',
  `penalizaciones`     int         DEFAULT 0   COMMENT 'Número de penalizaciones recibidas',
  `mejor_sector`       tinyint(1)  DEFAULT 0   COMMENT 'Consiguió el mejor sector de la carrera',
  `pole_position`      tinyint(1)  DEFAULT 0   COMMENT 'Salió desde la pole',
  `fuente_datos`       varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'manual' COMMENT 'manual|api_jolpica|api_ergast',
  PRIMARY KEY (`id_resultado`),
  KEY `id_carrera` (`id_carrera`),
  KEY `id_piloto`  (`id_piloto`),
  CONSTRAINT `resultados_carrera_ibfk_1` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`),
  CONSTRAINT `resultados_carrera_ibfk_2` FOREIGN KEY (`id_piloto`)  REFERENCES `pilotos`  (`id_piloto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `resultados_carrera` MODIFY `id_resultado` int NOT NULL AUTO_INCREMENT;

CREATE TABLE `puntos_fantasy` (
  `id_punto`    int          NOT NULL AUTO_INCREMENT,
  `id_equipo`   int          NOT NULL,
  `id_piloto`   int          NOT NULL,
  `id_carrera`  int          NOT NULL,
  `puntos`      int          NOT NULL,
  `detalle`     varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `es_capitan`  tinyint(1)   DEFAULT 0 COMMENT '1 si era capitán (puntos ya duplicados)',
  `puntos_base` int          DEFAULT 0 COMMENT 'Puntos antes de x2',
  `es_escuderia` tinyint(1)  DEFAULT 0 COMMENT 'Reservado (no usado)',
  PRIMARY KEY (`id_punto`),
  KEY `id_equipo`  (`id_equipo`),
  KEY `id_piloto`  (`id_piloto`),
  KEY `id_carrera` (`id_carrera`),
  CONSTRAINT `puntos_fantasy_ibfk_1` FOREIGN KEY (`id_equipo`)  REFERENCES `equipos_fantasy` (`id_equipo`),
  CONSTRAINT `puntos_fantasy_ibfk_2` FOREIGN KEY (`id_piloto`)  REFERENCES `pilotos`          (`id_piloto`),
  CONSTRAINT `puntos_fantasy_ibfk_3` FOREIGN KEY (`id_carrera`) REFERENCES `carreras`          (`id_carrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `puntos_fantasy` MODIFY `id_punto` int NOT NULL AUTO_INCREMENT;

CREATE TABLE `puntos_escuderia_fantasy` (
  `id`           int          NOT NULL AUTO_INCREMENT,
  `id_equipo`    int          NOT NULL,
  `id_escuderia` int          NOT NULL,
  `id_carrera`   int          NOT NULL,
  `puntos`       int          NOT NULL DEFAULT 0,
  `detalle`      varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_equipo`    (`id_equipo`),
  KEY `id_escuderia` (`id_escuderia`),
  KEY `id_carrera`   (`id_carrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `puntos_fantasy_carrera` (
  `id`               int NOT NULL AUTO_INCREMENT,
  `id_equipo`        int NOT NULL,
  `id_carrera`       int NOT NULL,
  `puntos_brutos`    int DEFAULT 0 COMMENT 'Suma pilotos + escudería sin capitán',
  `bonus_capitan`    int DEFAULT 0 COMMENT 'Puntos extra por capitán (pts_cap * 1)',
  `penalizacion`     int DEFAULT 0 COMMENT 'Puntos perdidos por cambios extra',
  `puntos_total`     int DEFAULT 0 COMMENT 'Total final de la jornada',
  `posicion_jornada` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `equipo_carrera` (`id_equipo`,`id_carrera`),
  KEY `id_carrera` (`id_carrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `puntos_desglose` (
  `id`           int          NOT NULL AUTO_INCREMENT,
  `id_resultado` int          NOT NULL,
  `criterio`     varchar(50)  NOT NULL COMMENT 'posicion|pole|q3|q2|vuelta_rapida|sector|adelantamiento|bonus_supero|retroceso|abandono|dsq|bandera_amarilla|bandera_roja|penalizacion|termino',
  `puntos`       int          NOT NULL COMMENT 'Puede ser negativo',
  `descripcion`  varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_resultado` (`id_resultado`),
  CONSTRAINT `desglose_ibfk_1` FOREIGN KEY (`id_resultado`) REFERENCES `resultados_carrera` (`id_resultado`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `historial_plantilla` (
  `id`           int          NOT NULL AUTO_INCREMENT,
  `id_equipo`    int          NOT NULL,
  `id_carrera`   int          NOT NULL COMMENT 'Próxima carrera cuando se hizo el cambio',
  `accion`       varchar(30)  NOT NULL COMMENT 'fichar|liberar|cambiar_capitan|fichar_escuderia|liberar_escuderia',
  `id_piloto`    int          DEFAULT NULL,
  `id_escuderia` int          DEFAULT NULL,
  `coste_cambio` int          DEFAULT 0   COMMENT 'Puntos de penalización si cambio extra',
  `fecha`        datetime     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_equipo`  (`id_equipo`),
  KEY `id_carrera` (`id_carrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `ventana_mercado` (
  `id`                 int         NOT NULL AUTO_INCREMENT,
  `id_carrera_desde`   int         NOT NULL COMMENT 'Abierta después de esta carrera',
  `id_carrera_hasta`   int         NOT NULL COMMENT 'Cierra antes de esta carrera',
  `abierto`            tinyint(1)  DEFAULT 1,
  `cambios_gratis`     int         DEFAULT 3 COMMENT 'Cambios gratuitos en esta ventana',
  `coste_extra`        int         DEFAULT 4 COMMENT 'Puntos perdidos por cambio extra',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `ventana_mercado` (`id_carrera_desde`,`id_carrera_hasta`,`abierto`,`cambios_gratis`,`coste_extra`) VALUES
(1,2,1,3,4),(2,3,1,3,4),(3,4,1,3,4),(4,5,1,3,4),(5,6,1,3,4),
(6,7,1,3,4),(7,8,1,3,4),(8,9,1,3,4),(9,10,1,3,4),(10,11,1,3,4),
(11,12,1,3,4),(12,13,1,3,4),(13,14,1,3,4),(14,15,1,3,4),(15,16,1,3,4),
(16,17,1,3,4),(17,18,1,3,4),(18,19,1,3,4),(19,20,1,3,4),(20,21,1,3,4),
(21,22,1,3,4),(22,23,1,3,4),(23,24,1,3,4);

CREATE TABLE `sync_log` (
  `id`         int         NOT NULL AUTO_INCREMENT,
  `id_carrera` int         NOT NULL,
  `fecha_sync` datetime    DEFAULT CURRENT_TIMESTAMP,
  `estado`     varchar(20) DEFAULT 'ok' COMMENT 'ok|error|parcial',
  `mensaje`    text        DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_carrera` (`id_carrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;
