-- =====================================================
-- PAPER SMART - VERSIÓN SIMPLIFICADA (5 TABLAS)
-- Base de Gestión PostgreSQL
-- =====================================================

DROP DATABASE IF EXISTS gestion_simple;
CREATE DATABASE gestion_simple;

\c gestion_simple

-- TABLA 1: Sucursales
CREATE TABLE Sucursales (
    sucursal_id SERIAL PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100),
    activa BOOLEAN DEFAULT TRUE
);

-- TABLA 2: Clientes Corporativos
CREATE TABLE Clientes_Corporativos (
    cliente_id SERIAL PRIMARY KEY,
    ruc VARCHAR(30) UNIQUE,
    razon_social VARCHAR(250) NOT NULL,
    segmento VARCHAR(100),
    limite_credito NUMERIC(12,2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT TRUE
);

-- TABLA 3: Presupuestos
CREATE TABLE Presupuestos (
    presupuesto_id SERIAL PRIMARY KEY,
    sucursal_id INT REFERENCES Sucursales(sucursal_id),
    anio INT NOT NULL,
    mes INT NOT NULL,
    meta_ventas NUMERIC(15,2) NOT NULL
);

-- TABLA 4: Evaluaciones
CREATE TABLE Evaluaciones (
    evaluacion_id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    sucursal_id INT REFERENCES Sucursales(sucursal_id),
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    tipo VARCHAR(50),
    comentario TEXT
);

-- TABLA 5: Ventas Mensuales
CREATE TABLE Ventas_Mensuales (
    id SERIAL PRIMARY KEY,
    sucursal_id INT REFERENCES Sucursales(sucursal_id),
    anio INT NOT NULL,
    mes INT NOT NULL,
    total_ventas NUMERIC(15,2),
    num_transacciones INT
);
