-- =============================================
-- SCRIPT FINAL DEFINITIVO - SIN FALLOS
-- =============================================

-- 1. ASEGURAR QUE USAMOS LA BASE DE DATOS
USE master;
GO

-- 2. BORRAR SI EXISTE Y CREAR DE NUEVO
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'DB_Inventario')
BEGIN
    ALTER DATABASE DB_Inventario SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DB_Inventario;
END
GO

CREATE DATABASE DB_Inventario;
GO

USE DB_Inventario;
GO

-- 3. CREAR TABLAS CORRECTAMENTE
CREATE TABLE Productos (
    ID_Producto INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Categoria VARCHAR(50),
    Precio_Costo DECIMAL(10,2),
    Stock_Minimo INT,
    Stock_Maximo INT
);
GO

CREATE TABLE Movimientos (
    ID_Movimiento INT IDENTITY(1,1) PRIMARY KEY,
    ID_Producto INT,
    Tipo_Movimiento CHAR(1),
    Cantidad INT,
    Fecha DATE
);
GO

-- 4. INSERTAR DATOS CORRECTAMENTE
INSERT INTO Productos 
(ID_Producto, Nombre, Categoria, Precio_Costo, Stock_Minimo, Stock_Maximo)
VALUES
(1, 'TORNILLO 5MM', 'FERRETERIA', 50.00, 20, 100),
(2, 'TUERCA 5MM', 'FERRETERIA', 30.00, 15, 80),
(3, 'CABLE ROJO', 'ELECTRICIDAD', 250.00, 10, 50),
(4, 'CAJA CARTON', 'EMPAQUE', 120.00, 5, 30),
(5, 'PEGAMENTO INDUSTRIAL', 'QUIMICOS', 8.50, 8, 40),
(6, 'MOTOR ELECTRICO', 'MAQUINARIA', 450.00, 2, 10),
(7, 'SENSOR DE TEMPERATURA', 'ELECTRONICA', 1200.00, 3, 15);
GO

INSERT INTO Movimientos 
(ID_Producto, Tipo_Movimiento, Cantidad, Fecha)
VALUES
(1, 'E', 50, '2024-01-05'),
(1, 'S', 35, '2024-02-10'),
(2, 'E', 40, '2024-01-08'),
(2, 'S', 10, '2024-02-15'),
(3, 'E', 30, '2024-01-10'),
(3, 'S', 5, '2024-01-20'),
(4, 'E', 20, '2024-01-12'),
(4, 'S', 12, '2024-02-01'),
(5, 'E', 50, '2024-01-15'),
(5, 'S', 45, '2024-02-20'),
(6, 'E', 5, '2024-01-20'),
(6, 'S', 1, '2024-02-05'),
(7, 'E', 10, '2024-01-25'),
(7, 'S', 2, '2024-02-10');
GO

-- =============================================
-- 5. CONSULTA FINAL PARA VER LAS TABLAS
-- =============================================

SELECT 
    p.Nombre,
    p.Categoria,
    p.Precio_Costo,
    p.Stock_Minimo,
    SUM(CASE WHEN m.Tipo_Movimiento = 'E' THEN m.Cantidad ELSE 0 END) 
    -
    SUM(CASE WHEN m.Tipo_Movimiento = 'S' THEN m.Cantidad ELSE 0 END) AS Stock_Actual
FROM Productos p
LEFT JOIN Movimientos m ON p.ID_Producto = m.ID_Producto
GROUP BY p.ID_Producto, p.Nombre, p.Categoria, p.Precio_Costo, p.Stock_Minimo;