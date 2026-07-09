-- =====================================================
-- PAPER SMART - Base de Operaciones MySQL
-- =====================================================

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS operaciones;
CREATE DATABASE operaciones;
USE operaciones;

-- TABLA 1: Productos
CREATE TABLE Productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(250) NOT NULL,
    marca VARCHAR(100),
    categoria VARCHAR(100),
    precio_venta DECIMAL(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- TABLA 2: Inventario
CREATE TABLE Inventario (
    inventario_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    sucursal VARCHAR(150) NOT NULL,
    cantidad INT DEFAULT 0,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- TABLA 3: Ventas
CREATE TABLE Ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    fecha_venta DATE NOT NULL,
    sucursal VARCHAR(150),
    cliente_ruc VARCHAR(30),
    total DECIMAL(12,2) NOT NULL
);

-- TABLA 4: Detalle Ventas
CREATE TABLE Detalle_Ventas (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES Ventas(venta_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- TABLA 5: Clientes
CREATE TABLE Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    ruc VARCHAR(30) UNIQUE,
    razon_social VARCHAR(250) NOT NULL,
    ciudad VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE
);
