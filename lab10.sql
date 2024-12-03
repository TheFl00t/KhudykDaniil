DROP TABLE IF EXISTS `metro_connections`;
DROP TABLE IF EXISTS `metro_stations`;
DROP TABLE IF EXISTS `metro_lines`;
DROP TABLE IF EXISTS `status_codes`;

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `metro_connections` (
  `connection_id` int(11) NOT NULL AUTO_INCREMENT,
  `station_a` int(11) NOT NULL,
  `station_b` int(11) NOT NULL,
  `type_of_connection` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`connection_id`),
  KEY `station_a` (`station_a`),
  KEY `station_b` (`station_b`),
  CONSTRAINT `fk_station_a` FOREIGN KEY (`station_a`) REFERENCES `metro_stations` (`station_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_station_b` FOREIGN KEY (`station_b`) REFERENCES `metro_stations` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `metro_connections` (`station_a`, `station_b`, `type_of_connection`) VALUES
(2, 12, 'Пересадка'),
(10, 11, 'Лінія'),
(4, 5, 'Лінія'),
(6, 7, 'Лінія'),
(1, 2, 'Лінія'),
(2, 5, 'Лінія'),
(5, 4, 'Лінія'),
(3, 10, 'Пересадка'),
(8, 9, 'Лінія'), 
(7, 6, 'Лінія'),
(11, 6, 'Пересадка');

CREATE TABLE `metro_lines` (
  `line_id` int(11) NOT NULL AUTO_INCREMENT,
  `line_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`line_id`),
  KEY `status` (`status`),
  CONSTRAINT `fk_line_status` FOREIGN KEY (`status`) REFERENCES `status_codes` (`status_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `metro_lines` (`line_color`, `status`) VALUES
('Синя', 1),
('Зелена', 1),
('Червона', 1);

CREATE TABLE `metro_stations` (
  `station_id` int(11) NOT NULL AUTO_INCREMENT,
  `station_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `line` int(11) DEFAULT NULL,
  `station_status` int(11) DEFAULT NULL,
  `station_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`station_id`),
  KEY `line` (`line`),
  KEY `station_status` (`station_status`),
  CONSTRAINT `fk_station_line` FOREIGN KEY (`line`) REFERENCES `metro_lines` (`line_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_station_status` FOREIGN KEY (`station_status`) REFERENCES `status_codes` (`status_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `metro_stations` (`station_name`, `line`, `station_status`, `station_order`) VALUES
('Держпром', 3, 1, 1),
('Центральний ринок', 1, 1, 1),
('Університет', 2, 1, 7),
('Проспект Гагаріна', 1, 1, 3),
('Майдан Конституції', 1, 1, 2),
('Архітектора Бекетова', 3, 1, 2),
('Київська', 2, 1, 5),
('Академіка Павлова', 2, 1, 3),
('Академіка Барабашова', 2, 1, 4),
('Пушкінська', 2, 1, 6),
('Захисників України', 3, 1, 3),
('Історичний музей', 1, 1, 4);

CREATE TABLE `status_codes` (
  `status_id` int(11) NOT NULL AUTO_INCREMENT,
  `status_description` varchar(255) NOT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `status_codes` (`status_id`, `status_description`) VALUES
(1, 'Активний'),
(2, 'Неактивний');

-- SQL - Запроси
-- Вибір усіх станцій з пересадками
SELECT 
    s1.station_name AS `Station A`,
    s2.station_name AS `Station B`,
    c.type_of_connection AS `Connection_Type`
FROM metro_connections c
INNER JOIN metro_stations s1 ON c.station_a = s1.station_id
INNER JOIN metro_stations s2 ON c.station_b = s2.station_id
WHERE c.type_of_connection = 'Пересадка';