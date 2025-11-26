-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-11-2025 a las 14:52:51
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistemainventarioventas`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_anular_compra` (IN `p_idCompra` INT)   BEGIN
    UPDATE Compra SET total = 0 WHERE idCompra = p_idCompra;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_anular_venta` (IN `p_idVenta` INT)   BEGIN
    UPDATE Venta SET total = 0 WHERE idVenta = p_idVenta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_compra` (IN `p_idProveedor` INT, IN `p_idUsuario` INT, OUT `p_idCompra` INT)   BEGIN
    INSERT INTO Compra (numeroFactura, fecha, total, idProveedor, idUsuario)
    VALUES (fn_generar_numero_factura(), NOW(), 0, p_idProveedor, p_idUsuario);

    SET p_idCompra = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_detalle_compra` (IN `p_idCompra` INT, IN `p_idProducto` INT, IN `p_cantidad` INT, IN `p_precio` DECIMAL(10,2))   BEGIN
    INSERT INTO DetalleCompra (idCompra, idProducto, cantidad, precioUnitario, subtotal)
    VALUES (p_idCompra, p_idProducto, p_cantidad, p_precio, p_cantidad * p_precio);

    UPDATE Compra SET total = fn_total_compra(p_idCompra)
    WHERE idCompra = p_idCompra;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_detalle_venta` (IN `p_idVenta` INT, IN `p_idProducto` INT, IN `p_cantidad` INT, IN `p_precio` DECIMAL(10,2))   BEGIN
    INSERT INTO DetalleVenta (idVenta, idProducto, cantidad, precioUnitario, subtotal)
    VALUES (p_idVenta, p_idProducto, p_cantidad, p_precio, p_cantidad * p_precio);

    UPDATE Venta SET total = fn_total_venta(p_idVenta)
    WHERE idVenta = p_idVenta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_venta` (IN `p_idCliente` INT, IN `p_idUsuario` INT, OUT `p_idVenta` INT)   BEGIN
    INSERT INTO Venta (numeroFactura, fecha, total, idCliente, idUsuario)
    VALUES (fn_generar_numero_venta(), NOW(), 0, p_idCliente, p_idUsuario);

    SET p_idVenta = LAST_INSERT_ID();
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_numero_factura` () RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE ultimo INT;

    SELECT IFNULL(MAX(idCompra), 0) + 1 INTO ultimo FROM Compra;

    RETURN CONCAT('C-', LPAD(ultimo, 5, '0'));
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_numero_venta` () RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE ultimo INT;

    SELECT IFNULL(MAX(idVenta), 0) + 1 INTO ultimo FROM Venta;

    RETURN CONCAT('V-', LPAD(ultimo, 5, '0'));
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_total_compra` (`p_idCompra` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(subtotal) INTO total
    FROM DetalleCompra
    WHERE idCompra = p_idCompra;

    RETURN IFNULL(total,0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_total_venta` (`p_idVenta` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(subtotal) INTO total
    FROM DetalleVenta
    WHERE idVenta = p_idVenta;

    RETURN IFNULL(total, 0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idCategoria` int(11) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idCategoria`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'Tecnología', 'Equipos electrónicos y periféricos', 'Activo'),
(2, 'Oficina', 'Artículos y mobiliario para oficina', 'Activo'),
(3, 'Hogar', 'Artículos para la casa y uso diario', 'Activo'),
(4, 'Accesorios', 'Complementos y gadgets', 'Activo'),
(5, 'Audio', 'Equipos y accesorios de sonido', 'Activo'),
(6, 'Televisión', 'Televisores y pantallas', 'Activo'),
(7, 'Impresión', 'Equipos y suministros de impresión', 'Activo'),
(8, 'Redes', 'Equipos de conectividad y telecomunicaciones', 'Activo'),
(9, 'Tecnología', 'Equipos electrónicos y periféricos', 'Activo'),
(10, 'Oficina', 'Artículos y mobiliario para oficina', 'Activo'),
(11, 'Hogar', 'Artículos para la casa y uso diario', 'Activo'),
(12, 'Accesorios', 'Complementos y gadgets', 'Activo'),
(13, 'Audio', 'Equipos y accesorios de sonido', 'Activo'),
(14, 'Televisión', 'Televisores y pantallas', 'Activo'),
(15, 'Impresión', 'Equipos y suministros de impresión', 'Activo'),
(16, 'Redes', 'Equipos de conectividad y telecomunicaciones', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(120) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `nombre`, `documento`, `telefono`, `correo`, `direccion`, `estado`) VALUES
(1, 'Carlos Ruiz', '1023456789', '3101112233', 'carlos.ruiz@gmail.com', 'Bogotá', 'Activo'),
(2, 'Ana Torres', '1009876543', '3125544332', 'ana.torres@gmail.com', 'Medellín', 'Activo'),
(3, 'Laura Martínez', '1098765432', '3156667788', 'lauram@hotmail.com', 'Cali', 'Activo'),
(4, 'Javier Gómez', '1045678901', '3112345566', 'javierg@gmail.com', 'Cartagena', 'Activo'),
(5, 'Empresa Logística S.A.S', '900123456', '3004458899', 'contacto@logistica.com', 'Bogotá', 'Activo'),
(6, 'Mariana Peña', '1034567890', '3167892345', 'mpe@gmail.com', 'Pereira', 'Activo'),
(7, 'Distribuidora Sigma', '901567890', '3215567432', 'ventas@sigma.com', 'Bucaramanga', 'Activo'),
(8, 'Juan López', '1012345678', '3109875643', 'juanl@gmail.com', 'Cali', 'Activo'),
(9, 'Clínica Vida IPS', '900998877', '3124456677', 'administracion@vidaips.com', 'Medellín', 'Activo'),
(10, 'Alejandro Ríos', '1056783452', '3007894561', 'alejandr@gmail.com', 'Bogotá', 'Activo'),
(11, 'Carlos Ruiz', '1023456789', '3101112233', 'carlos.ruiz@gmail.com', 'Bogotá', 'Activo'),
(12, 'Ana Torres', '1009876543', '3125544332', 'ana.torres@gmail.com', 'Medellín', 'Activo'),
(13, 'Laura Martínez', '1098765432', '3156667788', 'lauram@hotmail.com', 'Cali', 'Activo'),
(14, 'Javier Gómez', '1045678901', '3112345566', 'javierg@gmail.com', 'Cartagena', 'Activo'),
(15, 'Empresa Logística S.A.S', '900123456', '3004458899', 'contacto@logistica.com', 'Bogotá', 'Activo'),
(16, 'Mariana Peña', '1034567890', '3167892345', 'mpe@gmail.com', 'Pereira', 'Activo'),
(17, 'Distribuidora Sigma', '901567890', '3215567432', 'ventas@sigma.com', 'Bucaramanga', 'Activo'),
(18, 'Juan López', '1012345678', '3109875643', 'juanl@gmail.com', 'Cali', 'Activo'),
(19, 'Clínica Vida IPS', '900998877', '3124456677', 'administracion@vidaips.com', 'Medellín', 'Activo'),
(20, 'Alejandro Ríos', '1056783452', '3007894561', 'alejandr@gmail.com', 'Bogotá', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

CREATE TABLE `compra` (
  `idCompra` int(11) NOT NULL,
  `numeroFactura` varchar(30) DEFAULT NULL,
  `fecha` datetime NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `idProveedor` int(11) DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compra`
--

INSERT INTO `compra` (`idCompra`, `numeroFactura`, `fecha`, `total`, `idProveedor`, `idUsuario`) VALUES
(1, 'C-00001', '2025-11-26 08:19:27', 0.00, 1, 1),
(2, 'C-00002', '2025-11-26 08:19:27', 0.00, 2, 1),
(3, 'C-00003', '2025-11-26 08:19:27', 0.00, 3, 1),
(4, 'C-00004', '2025-11-26 08:19:27', 0.00, 4, 2),
(5, 'C-00005', '2025-11-26 08:19:27', 0.00, 5, 2);

--
-- Disparadores `compra`
--
DELIMITER $$
CREATE TRIGGER `tr_revertir_stock_anulacion_compra` AFTER UPDATE ON `compra` FOR EACH ROW BEGIN
    IF NEW.total = 0 AND OLD.total > 0 THEN
        UPDATE Producto p
        JOIN DetalleCompra dc ON p.idProducto = dc.idProducto
        SET p.stock = p.stock - dc.cantidad
        WHERE dc.idCompra = NEW.idCompra;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecompra`
--

CREATE TABLE `detallecompra` (
  `idDetalleCompra` int(11) NOT NULL,
  `idCompra` int(11) DEFAULT NULL,
  `idProducto` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precioUnitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detallecompra`
--

INSERT INTO `detallecompra` (`idDetalleCompra`, `idCompra`, `idProducto`, `cantidad`, `precioUnitario`, `subtotal`) VALUES
(1, 1, 1, 10, 20000.00, 200000.00),
(2, 1, 2, 5, 95000.00, 475000.00),
(3, 2, 3, 3, 350000.00, 1050000.00),
(4, 3, 5, 4, 110000.00, 440000.00),
(5, 4, 7, 6, 100000.00, 600000.00),
(6, 5, 8, 2, 90000.00, 180000.00);

--
-- Disparadores `detallecompra`
--
DELIMITER $$
CREATE TRIGGER `tr_aumentar_stock_compra` AFTER INSERT ON `detallecompra` FOR EACH ROW BEGIN
    UPDATE Producto
    SET stock = stock + NEW.cantidad
    WHERE idProducto = NEW.idProducto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventa`
--

CREATE TABLE `detalleventa` (
  `idDetalleVenta` int(11) NOT NULL,
  `idVenta` int(11) DEFAULT NULL,
  `idProducto` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precioUnitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalleventa`
--

INSERT INTO `detalleventa` (`idDetalleVenta`, `idVenta`, `idProducto`, `cantidad`, `precioUnitario`, `subtotal`) VALUES
(1, 1, 1, 2, 35000.00, 70000.00),
(2, 1, 2, 1, 150000.00, 150000.00),
(3, 2, 3, 1, 520000.00, 520000.00),
(4, 3, 4, 1, 980000.00, 980000.00),
(5, 4, 6, 1, 350000.00, 350000.00),
(6, 5, 8, 2, 130000.00, 260000.00);

--
-- Disparadores `detalleventa`
--
DELIMITER $$
CREATE TRIGGER `tr_disminuir_stock_venta` AFTER INSERT ON `detalleventa` FOR EACH ROW BEGIN
    UPDATE Producto
    SET stock = stock - NEW.cantidad
    WHERE idProducto = NEW.idProducto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadoventa`
--

CREATE TABLE `estadoventa` (
  `idEstadoVenta` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estadoventa`
--

INSERT INTO `estadoventa` (`idEstadoVenta`, `nombre`, `descripcion`) VALUES
(1, 'Pagada', 'Venta cancelada completamente'),
(2, 'Anulada', 'Venta eliminada por error o devolución');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formapago`
--

CREATE TABLE `formapago` (
  `idFormaPago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `formapago`
--

INSERT INTO `formapago` (`idFormaPago`, `nombre`, `descripcion`) VALUES
(1, 'Efectivo', 'Pago en efectivo'),
(2, 'Tarjeta', 'Pago con tarjeta'),
(3, 'Transferencia', 'Pago mediante transferencia bancaria');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `precioCompra` decimal(10,2) NOT NULL,
  `precioVenta` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `estado` varchar(20) DEFAULT 'Activo',
  `idCategoria` int(11) DEFAULT NULL,
  `idProveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `nombre`, `descripcion`, `precioCompra`, `precioVenta`, `stock`, `estado`, `idCategoria`, `idProveedor`) VALUES
(1, 'Mouse Logitech M185', 'Mouse inalámbrico 2.4Ghz', 20000.00, 35000.00, 68, 'Activo', 1, 1),
(2, 'Teclado RedDragon Kumara', 'Teclado mecánico RGB', 95000.00, 150000.00, 34, 'Activo', 1, 2),
(3, 'Monitor Samsung 24\"', 'Pantalla 1080p Full HD', 350000.00, 520000.00, 17, 'Activo', 6, 2),
(4, 'Impresora Epson L3250', 'Sistema de tinta continua', 750000.00, 980000.00, -1, 'Activo', 7, 5),
(5, 'Audífonos JBL Tune 500BT', 'Bluetooth inalámbricos', 110000.00, 175000.00, 4, 'Activo', 5, 1),
(6, 'Silla Ejecutiva Milano', 'Ergonómica tapizado premium', 200000.00, 350000.00, -1, 'Activo', 3, 3),
(7, 'Router TP-Link Archer C6', 'WiFi Gigabit AC1200', 100000.00, 160000.00, 6, 'Activo', 8, 4),
(8, 'Ventilador Samurai 16\"', '3 velocidades', 90000.00, 130000.00, 0, 'Activo', 3, 4),
(9, 'DeskPad XL Gamer', 'Alfombrilla extendida RGB', 25000.00, 55000.00, 0, 'Activo', 4, 1),
(10, 'Cable HDMI Ultra HD', '4K 2 metros', 12000.00, 25000.00, 0, 'Activo', 4, 3),
(11, 'Teclado Logitech K120', 'Teclado USB económico', 30000.00, 55000.00, 0, 'Activo', 1, 1),
(12, 'Parlantes Genius 200W', 'Sonido potente', 85000.00, 145000.00, 0, 'Activo', 5, 3),
(13, 'Monitor LG UltraWide 29\"', 'Panel IPS Full HD', 650000.00, 890000.00, 0, 'Activo', 6, 2),
(14, 'Silla Gamer Corsair T3', 'Edición premium', 750000.00, 1150000.00, 0, 'Activo', 3, 3),
(15, 'Audífonos HyperX Cloud II', 'Alto rendimiento gaming', 220000.00, 350000.00, 0, 'Activo', 5, 1),
(16, 'Mouse Logitech M185', 'Mouse inalámbrico 2.4Ghz', 20000.00, 35000.00, 0, 'Activo', 1, 1),
(17, 'Teclado RedDragon Kumara', 'Teclado mecánico RGB', 95000.00, 150000.00, 0, 'Activo', 1, 2),
(18, 'Monitor Samsung 24\"', 'Pantalla 1080p Full HD', 350000.00, 520000.00, 0, 'Activo', 6, 2),
(19, 'Impresora Epson L3250', 'Sistema de tinta continua', 750000.00, 980000.00, 0, 'Activo', 7, 5),
(20, 'Audífonos JBL Tune 500BT', 'Bluetooth inalámbricos', 110000.00, 175000.00, 0, 'Activo', 5, 1),
(21, 'Silla Ejecutiva Milano', 'Ergonómica tapizado premium', 200000.00, 350000.00, 0, 'Activo', 3, 3),
(22, 'Router TP-Link Archer C6', 'WiFi Gigabit AC1200', 100000.00, 160000.00, 0, 'Activo', 8, 4),
(23, 'Ventilador Samurai 16\"', '3 velocidades', 90000.00, 130000.00, 0, 'Activo', 3, 4),
(24, 'DeskPad XL Gamer', 'Alfombrilla extendida RGB', 25000.00, 55000.00, 0, 'Activo', 4, 1),
(25, 'Cable HDMI Ultra HD', '4K 2 metros', 12000.00, 25000.00, 0, 'Activo', 4, 3),
(26, 'Teclado Logitech K120', 'Teclado USB económico', 30000.00, 55000.00, 0, 'Activo', 1, 1),
(27, 'Parlantes Genius 200W', 'Sonido potente', 85000.00, 145000.00, 0, 'Activo', 5, 3),
(28, 'Monitor LG UltraWide 29\"', 'Panel IPS Full HD', 650000.00, 890000.00, 0, 'Activo', 6, 2),
(29, 'Silla Gamer Corsair T3', 'Edición premium', 750000.00, 1150000.00, 0, 'Activo', 3, 3),
(30, 'Audífonos HyperX Cloud II', 'Alto rendimiento gaming', 220000.00, 350000.00, 0, 'Activo', 5, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `idProveedor` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(120) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`idProveedor`, `nombre`, `telefono`, `correo`, `direccion`, `estado`) VALUES
(1, 'TecnoCol', '3104567890', 'contacto@tecnocol.com', 'Bogotá', 'Activo'),
(2, 'DataStore', '3156789023', 'ventas@datastore.com', 'Cali', 'Activo'),
(3, 'ImportSmart', '3125648790', 'info@importsmart.com', 'Medellín', 'Activo'),
(4, 'RedComTech', '3117659874', 'support@redcomtech.com', 'Barranquilla', 'Activo'),
(5, 'ColPrinter', '3205567890', 'service@colprinter.com', 'Bogotá', 'Activo'),
(6, 'TecnoCol', '3104567890', 'contacto@tecnocol.com', 'Bogotá', 'Activo'),
(7, 'DataStore', '3156789023', 'ventas@datastore.com', 'Cali', 'Activo'),
(8, 'ImportSmart', '3125648790', 'info@importsmart.com', 'Medellín', 'Activo'),
(9, 'RedComTech', '3117659874', 'support@redcomtech.com', 'Barranquilla', 'Activo'),
(10, 'ColPrinter', '3205567890', 'service@colprinter.com', 'Bogotá', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idRol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `dbUser` varchar(50) DEFAULT NULL,
  `dbPass` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idRol`, `nombre`, `descripcion`, `dbUser`, `dbPass`) VALUES
(1, 'Administrador', 'Control total del sistema', 'admin_db', 'Admin123*'),
(2, 'Vendedor', 'Gestiona ventas e inventario', 'vendedor_db', 'Vendedor123*'),
(3, 'Analista', 'Consulta información y reportes', 'analista_db', 'Analista123*');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nombreUsuario` varchar(80) NOT NULL,
  `contrasena` varchar(200) NOT NULL,
  `estado` varchar(20) DEFAULT 'Activo',
  `idRol` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `nombreUsuario`, `contrasena`, `estado`, `idRol`) VALUES
(1, 'admin', 'admin123', 'Activo', 1),
(2, 'vendedor1', 'venta123', 'Activo', 2),
(3, 'analista1', 'analista123', 'Activo', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idVenta` int(11) NOT NULL,
  `numeroFactura` varchar(30) NOT NULL,
  `fecha` datetime NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) DEFAULT NULL,
  `impuesto` decimal(10,2) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `idEstadoVenta` int(11) DEFAULT NULL,
  `idFormaPago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`idVenta`, `numeroFactura`, `fecha`, `total`, `descuento`, `impuesto`, `idCliente`, `idUsuario`, `idEstadoVenta`, `idFormaPago`) VALUES
(1, 'V-00001', '2025-11-26 08:13:11', 260000.00, 0.00, 0.00, 1, 2, 1, 1),
(2, 'V-00002', '2025-11-26 08:13:11', 260000.00, 0.00, 0.00, 2, 2, 1, 2),
(3, 'V-00003', '2025-11-26 08:13:11', 260000.00, 5.00, 0.00, 3, 2, 1, 1),
(4, 'V-00004', '2025-11-26 08:13:11', 260000.00, 0.00, 0.00, 4, 2, 1, 3),
(5, 'V-00005', '2025-11-26 08:13:11', 260000.00, 10.00, 0.00, 5, 2, 1, 1);

--
-- Disparadores `venta`
--
DELIMITER $$
CREATE TRIGGER `tr_revertir_stock_anulacion_venta` AFTER UPDATE ON `venta` FOR EACH ROW BEGIN
    IF NEW.total = 0 AND OLD.total > 0 THEN
        UPDATE Producto p
        JOIN DetalleVenta dv ON p.idProducto = dv.idProducto
        SET p.stock = p.stock + dv.cantidad
        WHERE dv.idVenta = NEW.idVenta;
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`);

--
-- Indices de la tabla `compra`
--
ALTER TABLE `compra`
  ADD PRIMARY KEY (`idCompra`),
  ADD KEY `idProveedor` (`idProveedor`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD PRIMARY KEY (`idDetalleCompra`),
  ADD KEY `idCompra` (`idCompra`),
  ADD KEY `idProducto` (`idProducto`);

--
-- Indices de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD PRIMARY KEY (`idDetalleVenta`),
  ADD KEY `idVenta` (`idVenta`),
  ADD KEY `idProducto` (`idProducto`);

--
-- Indices de la tabla `estadoventa`
--
ALTER TABLE `estadoventa`
  ADD PRIMARY KEY (`idEstadoVenta`);

--
-- Indices de la tabla `formapago`
--
ALTER TABLE `formapago`
  ADD PRIMARY KEY (`idFormaPago`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `idCategoria` (`idCategoria`),
  ADD KEY `idProveedor` (`idProveedor`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`idProveedor`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idRol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD KEY `idRol` (`idRol`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idVenta`),
  ADD KEY `idCliente` (`idCliente`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `idEstadoVenta` (`idEstadoVenta`),
  ADD KEY `idFormaPago` (`idFormaPago`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idCategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `compra`
--
ALTER TABLE `compra`
  MODIFY `idCompra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  MODIFY `idDetalleCompra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  MODIFY `idDetalleVenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `estadoventa`
--
ALTER TABLE `estadoventa`
  MODIFY `idEstadoVenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `formapago`
--
ALTER TABLE `formapago`
  MODIFY `idFormaPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `idProveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `idVenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`idProveedor`) REFERENCES `proveedor` (`idProveedor`),
  ADD CONSTRAINT `compra_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD CONSTRAINT `detallecompra_ibfk_1` FOREIGN KEY (`idCompra`) REFERENCES `compra` (`idCompra`),
  ADD CONSTRAINT `detallecompra_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`);

--
-- Filtros para la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD CONSTRAINT `detalleventa_ibfk_1` FOREIGN KEY (`idVenta`) REFERENCES `venta` (`idVenta`),
  ADD CONSTRAINT `detalleventa_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`idCategoria`),
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`idProveedor`) REFERENCES `proveedor` (`idProveedor`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `rol` (`idRol`);

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `venta_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `venta_ibfk_3` FOREIGN KEY (`idEstadoVenta`) REFERENCES `estadoventa` (`idEstadoVenta`),
  ADD CONSTRAINT `venta_ibfk_4` FOREIGN KEY (`idFormaPago`) REFERENCES `formapago` (`idFormaPago`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
