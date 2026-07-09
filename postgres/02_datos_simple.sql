-- =====================================================
-- DATOS SIMPLIFICADOS - PostgreSQL
-- =====================================================

\c gestion_simple

-- SUCURSALES
INSERT INTO Sucursales (codigo, nombre, ciudad, activa) VALUES
('SUC-001', 'Sucursal Norte', 'Quito', TRUE),
('SUC-002', 'Sucursal Universitaria', 'Quito', TRUE),
('SUC-003', 'Sucursal Centro', 'Quito', TRUE),
('SUC-004', 'Sucursal Sur', 'Quito', TRUE),
('SUC-005', 'Tienda Online', 'Quito', TRUE);

-- CLIENTES CORPORATIVOS (con RUCs problemáticos)
INSERT INTO Clientes_Corporativos (ruc, razon_social, segmento, limite_credito, activo) VALUES
('1792345678001', 'Colegio San Francisco S.A.', 'Institución Educativa', 15000.00, TRUE),
('179456789', 'Escuela La Inmaculada', 'Institución Educativa', 18000.00, TRUE),
('1793456789001', 'Unidad Educativa Nuevo Mundo', 'Institución Educativa', 20000.00, TRUE),
('1794567890-001', 'Universidad Del Pacífico', 'Institución Educativa', 50000.00, TRUE),
('1795678901001', 'Instituto Americano', 'Institución Educativa', 12000.00, TRUE),
('1796789012', 'Colegio Internacional', 'Institución Educativa', 14000.00, TRUE),
('1797890123001', 'Empresa Tecnológica S.A.', 'Corporativo Grande', 30000.00, TRUE),
('1798901234-001', 'Consultora ABC', 'Empresa PYME', 8000.00, TRUE),
('1799012345001', 'Estudio Arquitectura', 'Diseñador/Arquitecto', 5000.00, TRUE),
('1790123456001', 'Municipio de Quito', 'Gobierno', 40000.00, TRUE);

-- PRESUPUESTOS (2023-2025)
DO $$
DECLARE
    v_anio INT;
    v_mes INT;
    v_sucursal INT;
    v_meta NUMERIC(15,2);
BEGIN
    FOR v_anio IN 2023..2025 LOOP
        FOR v_mes IN 1..12 LOOP
            FOR v_sucursal IN 1..5 LOOP
                IF random() > 0.3 THEN
                    v_meta := round((20000 + random() * 80000)::numeric, 2);
                    INSERT INTO Presupuestos (sucursal_id, anio, mes, meta_ventas)
                    VALUES (v_sucursal, v_anio, v_mes, v_meta);
                END IF;
            END LOOP;
        END LOOP;
    END LOOP;
END $$;

-- EVALUACIONES (con problemas de calificación)
DO $$
DECLARE
    v_contador INT := 1;
    v_fecha DATE;
    v_sucursal INT;
    v_calif INT;
    v_tipo TEXT;
    tipos TEXT[] := ARRAY['Satisfacción', 'Reclamo', 'Devolución', 'Sugerencia'];
BEGIN
    WHILE v_contador <= 200 LOOP
        v_fecha := '2023-01-01'::date + (floor(random() * 1095))::int;
        v_sucursal := 1 + floor(random() * 5)::int;
        v_tipo := tipos[1 + floor(random() * array_length(tipos, 1))::int];
        
        -- 5% con calificación NULL (error)
        IF random() > 0.95 THEN
            v_calif := NULL;
        ELSE
            v_calif := 1 + floor(random() * 5)::int;
        END IF;
        
        INSERT INTO Evaluaciones (fecha, sucursal_id, calificacion, tipo, comentario)
        VALUES (v_fecha, v_sucursal, v_calif, v_tipo, 'Comentario evaluación #' || v_contador);
        
        v_contador := v_contador + 1;
    END LOOP;
END $$;

-- VENTAS MENSUALES
DO $$
DECLARE
    v_anio INT;
    v_mes INT;
    v_sucursal INT;
BEGIN
    FOR v_anio IN 2023..2025 LOOP
        FOR v_mes IN 1..12 LOOP
            FOR v_sucursal IN 1..5 LOOP
                INSERT INTO Ventas_Mensuales (sucursal_id, anio, mes, total_ventas, num_transacciones)
                VALUES (
                    v_sucursal,
                    v_anio,
                    v_mes,
                    round((50000 + random() * 150000)::numeric, 2),
                    floor(random() * 500) + 100
                );
            END LOOP;
        END LOOP;
    END LOOP;
END $$;

-- Verificar
SELECT 'Sucursales' as Tabla, COUNT(*) as Registros FROM Sucursales
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes_Corporativos
UNION ALL
SELECT 'Presupuestos', COUNT(*) FROM Presupuestos
UNION ALL
SELECT 'Evaluaciones', COUNT(*) FROM Evaluaciones
UNION ALL
SELECT 'Ventas Mensuales', COUNT(*) FROM Ventas_Mensuales;
