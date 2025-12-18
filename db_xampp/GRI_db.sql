-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-12-2025 a las 18:21:08
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gri`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `celebrations`
--

CREATE TABLE `celebrations` (
  `id` int(11) NOT NULL,
  `type` enum('Batismo','Casamento','Obito') NOT NULL,
  `date` date NOT NULL,
  `details` text DEFAULT NULL,
  `signed_by_user_id` int(11) DEFAULT NULL,
  `signed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `owner_user_id` int(11) NOT NULL,
  `nome_batizado` varchar(100) DEFAULT NULL,
  `pai` varchar(100) DEFAULT NULL,
  `mae` varchar(100) DEFAULT NULL,
  `padrinho1` varchar(100) DEFAULT NULL,
  `padrinho2` varchar(100) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `conjuge_user_id` int(11) DEFAULT NULL,
  `testemunha1` varchar(100) DEFAULT NULL,
  `testemunha2` varchar(100) DEFAULT NULL,
  `nome_falecido` varchar(100) DEFAULT NULL,
  `data_nascimento_falecido` date DEFAULT NULL,
  `data_obito` date DEFAULT NULL,
  `local_sepultura` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `celebrations`
--

INSERT INTO `celebrations` (`id`, `type`, `date`, `details`, `signed_by_user_id`, `signed_at`, `created_at`, `owner_user_id`, `nome_batizado`, `pai`, `mae`, `padrinho1`, `padrinho2`, `data_nascimento`, `conjuge_user_id`, `testemunha1`, `testemunha2`, `nome_falecido`, `data_nascimento_falecido`, `data_obito`, `local_sepultura`) VALUES
(9, 'Batismo', '2025-12-17', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-17 22:45:21', 1, 'Maria Castanha', 'Pepito Rodrigues', 'Heidy Vieira', 'Marc Marquez', 'Alexandra Rodrigues', '2025-11-05', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'Casamento', '2025-12-17', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-17 22:46:22', 4, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Virgilio Rodrigues', 'Inocencia Henriques', NULL, NULL, NULL, NULL),
(11, 'Obito', '2025-12-17', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-17 22:48:34', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Lucy Faria', '1999-06-29', '2025-08-30', 'Funchal, São Martinho'),
(12, 'Casamento', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 16:56:13', 1, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Pedro Gonçalves', 'Maria Pereira', NULL, NULL, NULL, NULL),
(13, 'Batismo', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 16:57:58', 1, 'João Marques', 'Marco Marques', 'Maria Joana', 'Gabriel Rodrigues', 'Ana Da Silva', '2025-12-18', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'Obito', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 16:58:40', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'João Marques', '2024-01-10', '2025-12-18', 'Funchal'),
(15, 'Batismo', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 17:12:31', 3, 'Thiago Sá', 'João Sá', 'Margarida', 'João Nascimento', 'Karina Reis', '2025-12-18', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 'Casamento', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 17:13:45', 3, NULL, NULL, NULL, NULL, NULL, NULL, 5, 'Lucas Neto', 'Leticia Rodrigues', NULL, NULL, NULL, NULL),
(17, 'Obito', '2025-12-18', 'Detalhes gerados automaticamente', NULL, NULL, '2025-12-18 17:14:21', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'João Sá', '1981-01-01', '2025-12-01', 'Santa Cruz');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL,
  `celebration_id` int(11) NOT NULL,
  `owner_user_id` int(11) NOT NULL,
  `type` varchar(150) NOT NULL,
  `fee_amount` decimal(10,2) DEFAULT 0.00,
  `fee_status` enum('Pendente','Pago') NOT NULL DEFAULT 'Pendente',
  `file_path` varchar(300) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `documents`
--

INSERT INTO `documents` (`id`, `celebration_id`, `owner_user_id`, `type`, `fee_amount`, `fee_status`, `file_path`, `created_at`) VALUES
(29, 9, 1, 'Certidão de Batismo', '15.00', 'Pago', NULL, '2025-12-17 22:56:48'),
(30, 10, 4, 'Certidão de Casamento', '15.00', 'Pendente', NULL, '2025-12-17 22:56:49'),
(31, 14, 1, 'Certidão de Obito', '15.00', 'Pago', NULL, '2025-12-18 17:04:36'),
(32, 17, 5, 'Certidão de Obito', '15.00', 'Pendente', NULL, '2025-12-18 17:15:14'),
(33, 16, 3, 'Certidão de Casamento', '15.00', 'Pendente', NULL, '2025-12-18 17:15:19'),
(34, 13, 1, 'Certidão de Batismo', '15.00', 'Pendente', NULL, '2025-12-18 17:15:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `document_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` varchar(100) NOT NULL,
  `provider_status` enum('Pending','Confirmed','Rejected') NOT NULL DEFAULT 'Pending',
  `provider_reference` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `confirmed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `payments`
--

INSERT INTO `payments` (`id`, `document_id`, `user_id`, `amount`, `method`, `provider_status`, `provider_reference`, `created_at`, `confirmed_at`) VALUES
(43, 29, 1, '15.00', 'MBWay', '', NULL, '2025-12-17 23:01:51', '2025-12-18 00:01:51'),
(44, 29, 1, '15.00', 'MBWay', '', NULL, '2025-12-17 23:01:51', '2025-12-18 00:01:51'),
(45, 31, 1, '15.00', 'Cartão', '', NULL, '2025-12-18 17:18:16', '2025-12-18 18:18:16'),
(46, 31, 1, '15.00', 'Cartão', '', NULL, '2025-12-18 17:18:16', '2025-12-18 18:18:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('Padre','Administracao','Fiel','Voluntario','Gestao') NOT NULL DEFAULT 'Fiel',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'Maria Joana', 'maria@gri.local', 'fiel123', 'Fiel', '2025-12-15 20:45:28'),
(2, 'Jorge Paulo', 'jp@gri.local', 'padre123', 'Padre', '2025-12-15 20:47:11'),
(3, 'João Sá', 'SAjoao23@gri.local', 'fiel123', 'Fiel', '2025-12-16 10:18:10'),
(4, 'Marco Marques', 'marquis@gri.local', 'fiel123', 'Fiel', '2025-12-16 10:19:53'),
(5, 'Margarida', 'maguilida@gri.local', 'fiel123', 'Fiel', '2025-12-16 10:20:26'),
(6, 'Não Agostinho', 'nao54@gri.local', 'fiel123', 'Fiel', '2025-12-16 10:20:44'),
(7, 'Sim Agostinho', 'sim59@gri.local', 'fiel123', 'Fiel', '2025-12-16 10:20:59'),
(8, 'Filipe Filipes', 'pipo@gri.local', 'padre123', 'Padre', '2025-12-16 10:21:55'),
(9, 'Miguel Cardoso', 'cardosoDelas@gri.local', 'padre123', 'Padre', '2025-12-16 10:22:22'),
(10, 'Ricardo Garcês', 'RicGarceres@gri.local', 'admin123', 'Administracao', '2025-12-16 10:22:49'),
(11, 'Miguel Oliveira', 'padre@gri.local', 'padre123', 'Padre', '2025-12-17 22:41:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `celebrations`
--
ALTER TABLE `celebrations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_celebration_padre` (`signed_by_user_id`);

--
-- Indices de la tabla `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_doc_celebration` (`celebration_id`),
  ADD KEY `fk_doc_owner` (`owner_user_id`);

--
-- Indices de la tabla `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payment_document` (`document_id`),
  ADD KEY `fk_payment_user` (`user_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `celebrations`
--
ALTER TABLE `celebrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `documents`
--
ALTER TABLE `documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `celebrations`
--
ALTER TABLE `celebrations`
  ADD CONSTRAINT `fk_celebration_padre` FOREIGN KEY (`signed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `fk_doc_celebration` FOREIGN KEY (`celebration_id`) REFERENCES `celebrations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_doc_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payment_document` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_payment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
