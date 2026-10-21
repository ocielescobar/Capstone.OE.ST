-- FUENTE DEL NODO N8N: Obtener fechas base del proyecto
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

DECLARE @Proyecto nvarchar(30) =
    N'{{ $json.pro_codigo }}';

DECLARE @Version int =
    {{ $json.pro_version }};

SELECT
    px.pro_codigo,
    px.pro_codigo_humano,
    px.pro_version,
    px.pro_estado AS estado_proyecto_real,
    px.pro_formalizaciones,

    px.pro_fecha_inicio,
    px.pro_fecha_termino,
    px._pro_fecha_inicio_oficial,
    px._pro_fecha_termino_oficial,

    pv.ver_fecha_inicio,
    pv.ver_fecha_termino,
    pv.ver_fecha_inicio_oficial,
    pv.ver_fecha_termino_oficial,
    pv.ver_resolucion_fecha,

    COALESCE(
        pv.ver_fecha_inicio_oficial,
        px._pro_fecha_inicio_oficial,
        px.pro_fecha_inicio
    ) AS fecha_inicio_base,

    COALESCE(
        pv.ver_fecha_termino_oficial,
        px._pro_fecha_termino_oficial,
        px.pro_fecha_termino
    ) AS fecha_termino_base,

    DATEFROMPARTS(
        YEAR(
            COALESCE(
                pv.ver_fecha_inicio_oficial,
                px._pro_fecha_inicio_oficial,
                px.pro_fecha_inicio
            )
        ),
        MONTH(
            COALESCE(
                pv.ver_fecha_inicio_oficial,
                px._pro_fecha_inicio_oficial,
                px.pro_fecha_inicio
            )
        ),
        1
    ) AS primer_mes_plan,

    final.inf_numero AS numero_informe_final_existente,
    final.inf_fecha_corte AS fecha_corte_final_existente,
    final.inf_entrega_programada AS fecha_entrega_final_base,

    CAST(
        CASE
            WHEN final.inf_entrega_programada IS NOT NULL
                THEN 1
            ELSE 0
        END
        AS bit
    ) AS plazo_final_disponible,

    CAST(1 AS bit) AS modo_prueba

FROM dbo.PROYECTOS_X AS px

LEFT JOIN dbo.PROYECTO_VERSIONES AS pv
    ON pv.ver_proyecto_codigo = px.pro_codigo
   AND pv.ver_proyecto_version = @Version

OUTER APPLY
(
    SELECT TOP (1)
        i.inf_numero,
        i.inf_fecha_corte,
        i.inf_entrega_programada
    FROM dbo.PROYECTO_INFORME AS i
    WHERE i.inf_proyecto_codigo = px.pro_codigo
      AND i.inf_proyecto_version = @Version
      AND i.inf_tipo = 4
    ORDER BY
        CASE
            WHEN i.inf_entrega_programada IS NULL THEN 1
            ELSE 0
        END,
        i.inf_numero DESC
) AS final

WHERE px.pro_codigo = @Proyecto
  AND px.pro_version = @Version;
