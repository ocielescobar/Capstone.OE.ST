-- FUENTE DEL NODO N8N: Consultar adjudicados R2 pendientes
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

WITH UltimaVersionVigente AS (
    SELECT 
        DISTINCT(p.pro_codigo),
        MAX(p.pro_version) AS max_version
    FROM Innova_Produccion..PROYECTOS_X p
    LEFT JOIN Innova_Produccion..PROYECTO_SITUACION s 
        ON s.psi_proyecto = p.pro_codigo 
       AND s.psi_tipo_situacion = 27
    WHERE 
        p.pro_estado IN (10, 11, 12, 13)
        AND p.pro_categoria IN (1, 4)
        -- Filtro R2 institucional
        AND EXISTS (
            SELECT 1 
            FROM Innova_Produccion..PROYECTOS_AFECTOS_R2 r2 
            WHERE r2.pr2_proyecto_codigo = p.pro_codigo
        )
        -- Caso 1 (Semáforo 27 activo y no finalizado) O Caso 2 (No existe semáforo 27)
        AND (
            (s.psi_tipo_situacion = 27 AND s.psi_situacion_finalizada = 0)
            OR s.psi_proyecto IS NULL
        )
    GROUP BY p.pro_codigo
),
ResumenInformes AS (
    SELECT 
        DISTINCT(p.pro_codigo),
        p.pro_version,
        p.pro_codigo_humano,
        p.pro_nombre_corto,
        p.pro_nombre_largo,
        p.pro_estado,
        p.pro_categoria,
        p.pro_fecha_creacion,
        p.pro_fecha_actualizacion,
        p.pro_resolucion_fecha,
        COALESCE(p._pro_fecha_inicio_oficial, p.pro_fecha_inicio) AS fecha_inicio,
        COALESCE(p._pro_fecha_termino_oficial, p.pro_fecha_termino) AS fecha_termino,
        COALESCE(YEAR(p.pro_fecha_creacion), TRY_CAST(LEFT(p.pro_codigo, 4) AS INT)) AS ano_origen,
        COUNT(i.inf_numero) AS cant_informes_totales,
        COUNT(CASE WHEN i.inf_estado = 1 THEN 1 END) AS cant_informes_vigentes,
        COUNT(CASE WHEN i.inf_estado <> 1 THEN 1 END) AS cant_informes_no_vigentes
    FROM UltimaVersionVigente uv
    INNER JOIN Innova_Produccion..PROYECTOS_X p 
        ON p.pro_codigo = uv.pro_codigo 
       AND p.pro_version = uv.max_version
    LEFT JOIN Innova_Produccion..PROYECTO_INFORME i 
        ON i.inf_proyecto_codigo = p.pro_codigo 
       AND i.inf_proyecto_version = p.pro_version
    GROUP BY 
        p.pro_codigo,
        p.pro_version,
        p.pro_codigo_humano,
        p.pro_nombre_corto,
        p.pro_nombre_largo,
        p.pro_estado,
        p.pro_categoria,
        p.pro_fecha_creacion,
        p.pro_fecha_actualizacion,
        p.pro_resolucion_fecha,
        p._pro_fecha_inicio_oficial,
        p.pro_fecha_inicio,
        p._pro_fecha_termino_oficial,
        p.pro_fecha_termino
)
SELECT 
    DISTINCT(pro_codigo),
    pro_version,
    pro_codigo_humano,
    pro_estado,
    pro_categoria,
    COALESCE(NULLIF(TRIM(pro_nombre_largo), ''), pro_nombre_corto, pro_codigo_humano) AS nombre_proyecto,
    ano_origen,
    fecha_inicio,
    fecha_termino,
    DATEDIFF(day, fecha_inicio, fecha_termino) AS duracion_dias,
    cant_informes_totales,
    cant_informes_vigentes,
    CASE 
        WHEN cant_informes_totales = 0 THEN 'CREAR_PLAN'
        ELSE 'CONFIGURAR_PLAN_EXISTENTE'
    END AS accion_sugerida,
    pro_resolucion_fecha,
    pro_fecha_actualizacion
FROM ResumenInformes
  WHERE 
    -- 1. Proyectos sin plan inicial
    cant_informes_totales = 0
    -- 2. O proyectos con informes vigentes/pendientes sin informes cerrados definitivos
    OR (cant_informes_vigentes > 0 AND cant_informes_no_vigentes = 0)
  ORDER BY 
    ano_origen DESC, 
    pro_codigo DESC;
