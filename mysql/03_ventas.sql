-- =====================================================
-- PROCEDIMIENTO - Genera 2000 ventas
-- =====================================================

USE operaciones;

DELIMITER $$

DROP PROCEDURE IF EXISTS generar_ventas$$

CREATE PROCEDURE generar_ventas()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_fecha DATE;
    DECLARE v_sucursal VARCHAR(150);
    DECLARE v_cliente_ruc VARCHAR(30);
    DECLARE v_total DECIMAL(12,2);
    DECLARE v_num_items INT;
    DECLARE v_item_count INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_numero_factura VARCHAR(50);
    DECLARE v_venta_id INT;
    
    WHILE v_contador <= 2000 DO
        -- Fecha aleatoria 2023-2025
        SET v_fecha = DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 1095) DAY);
        
        -- Sucursal con variaciones
        SET v_sucursal = CASE FLOOR(RAND() * 12)
            WHEN 0 THEN 'Sucursal Norte'
            WHEN 1 THEN 'SUC. NORTE'
            WHEN 2 THEN 'NORTE'
            WHEN 3 THEN 'Sucursal Universitaria'
            WHEN 4 THEN 'Uni'
            WHEN 5 THEN 'UNIVERSIDAD'
            WHEN 6 THEN 'Sucursal Centro'
            WHEN 7 THEN 'CENTRO'
            WHEN 8 THEN 'Sucursal Sur'
            WHEN 9 THEN 'SUR'
            WHEN 10 THEN 'Bodega Central'
            ELSE 'Tienda Online'
        END;
        
        -- RUC con errores
        IF RAND() > 0.7 THEN
            IF RAND() > 0.5 THEN
                SET v_cliente_ruc = CONCAT('179', LPAD(FLOOR(RAND() * 10000000), 7, '0'));
            ELSE
                SET v_cliente_ruc = CONCAT('179', LPAD(FLOOR(RAND() * 10000000), 7, '0'), '-001');
            END IF;
        ELSE
            SET v_cliente_ruc = NULL;
        END IF;
        
        SET v_numero_factura = CONCAT('001-001-', LPAD(v_contador, 9, '0'));
        SET v_total = 0;
        
        -- Insertar cabecera
        INSERT INTO Ventas (numero_factura, fecha_venta, sucursal, cliente_ruc, total)
        VALUES (v_numero_factura, v_fecha, v_sucursal, v_cliente_ruc, 0);
        
        SET v_venta_id = LAST_INSERT_ID();
        
        -- Generar 2-5 ítems
        SET v_num_items = FLOOR(RAND() * 4) + 2;
        SET v_item_count = 0;
        
        WHILE v_item_count < v_num_items DO
            SET v_producto_id = FLOOR(RAND() * 50) + 1;
            SET v_cantidad = FLOOR(RAND() * 10) + 1;
            
            -- Precio con 2% en cero
            IF RAND() > 0.98 THEN
                SET v_precio = 0.00;
            ELSE
                SET v_precio = ROUND(RAND() * 30 + 0.50, 2);
            END IF;
            
            INSERT INTO Detalle_Ventas (venta_id, producto_id, cantidad, precio_unitario)
            VALUES (v_venta_id, v_producto_id, v_cantidad, v_precio);
            
            SET v_total = v_total + (v_cantidad * v_precio);
            SET v_item_count = v_item_count + 1;
        END WHILE;
        
        -- Actualizar total
        UPDATE Ventas SET total = v_total WHERE venta_id = v_venta_id;
        
        SET v_contador = v_contador + 1;
    END WHILE;
END$$

DELIMITER ;

-- Ejecutar
CALL generar_ventas();

-- Verificar
SELECT 'Productos' as Tabla, COUNT(*) as Registros FROM Productos
UNION ALL
SELECT 'Inventario', COUNT(*) FROM Inventario
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes
UNION ALL
SELECT 'Ventas', COUNT(*) FROM Ventas
UNION ALL
SELECT 'Detalles', COUNT(*) FROM Detalle_Ventas;
