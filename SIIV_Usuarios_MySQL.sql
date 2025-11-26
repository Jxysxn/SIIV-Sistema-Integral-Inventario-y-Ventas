
--  CREACIÓN DE USUARIOS MYSQL PARA EL SISTEMA SIIV --


-- Usuario Administrador
CREATE USER 'admin_db'@'localhost' IDENTIFIED BY 'Admin123*';
GRANT ALL PRIVILEGES ON SistemaInventarioVentas.* TO 'admin_db'@'localhost';

-- Usuario Vendedor
CREATE USER 'vendedor_db'@'localhost' IDENTIFIED BY 'Vendedor123*';
GRANT SELECT, INSERT, UPDATE ON SistemaInventarioVentas.* TO 'vendedor_db'@'localhost';

-- Usuario Analista
CREATE USER 'analista_db'@'localhost' IDENTIFIED BY 'Analista123*';
GRANT SELECT ON SistemaInventarioVentas.* TO 'analista_db'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;

-- Ejecutar después de restaurar la BD del sistema --

