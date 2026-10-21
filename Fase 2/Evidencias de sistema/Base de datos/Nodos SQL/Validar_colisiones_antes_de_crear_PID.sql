-- FUENTE DEL NODO N8N: Validar colisiones antes de crear PID
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

DECLARE @Proyecto nvarchar(30) = NULLIF(LTRIM(RTRIM(N'{{ $json.pro_codigo }}')), N'');
DECLARE @Version int = TRY_CONVERT(int, N'{{ $json.pro_version }}');
DECLARE @InformePropuesto int = TRY_CONVERT(int, N'{{ $json.numero_mes ?? $json.numero_mes_propuesto }}');

SELECT
    @Proyecto AS pro_codigo,
    @Version AS pro_version,
    @InformePropuesto AS numero_mes_propuesto,

    -- Recuperación de los campos borrados para que pasen al siguiente nodo
    N'{{ $json.numero_mes }}' AS numero_mes,
    N'{{ $json.fecha_corte_propuesta }}' AS fecha_corte_propuesta,
    N'{{ $json.fecha_entrega_propuesta }}' AS fecha_entrega_propuesta,
    TRY_CONVERT(int, N'{{ $json.inf_tipo_propuesto }}') AS inf_tipo_propuesto,
    TRY_CONVERT(int, N'{{ $json.estado_informe_propuesto }}') AS estado_informe_propuesto,
    N'{{ $json.nombre_propuesto }}' AS nombre_propuesto,

    COUNT(i.inf_numero) AS total_informes_existentes,

    ISNULL(
        SUM(CASE WHEN i.inf_numero = @InformePropuesto THEN 1 ELSE 0 END), 0
    ) AS colisiones_mismo_numero,

    ISNULL(
        SUM(CASE WHEN i.inf_tipo = 4 THEN 1 ELSE 0 END), 0
    ) AS informes_finales_existentes,

    CAST(
        CASE WHEN COUNT(i.inf_numero) = 0 THEN 1 ELSE 0 END AS bit
    ) AS crear_plan_completo_autorizable,

    CAST(
        CASE WHEN ISNULL(SUM(CASE WHEN i.inf_numero = @InformePropuesto THEN 1 ELSE 0 END), 0) = 0 
        THEN 1 ELSE 0 END AS bit
    ) AS numero_informe_disponible,

    CASE
        WHEN COUNT(i.inf_numero) = 0 THEN 'SIN_INFORMES_EXISTENTES_CREAR_PLAN'
        WHEN ISNULL(SUM(CASE WHEN i.inf_numero = @InformePropuesto THEN 1 ELSE 0 END), 0) > 0 THEN 'COLISION_NUMERO_INFORME'
        ELSE 'PROYECTO_CON_PLAN_EXISTENTE_CONFIGURAR'
    END AS diagnostico_colision,

    CASE
        WHEN COUNT(i.inf_numero) = 0 THEN 'CREAR_PLAN'
        ELSE 'CONFIGURAR_PLAN_MENSUAL'
    END AS accion_recomendada

FROM dbo.PROYECTO_INFORME AS i
WHERE i.inf_proyecto_codigo = @Proyecto
  AND i.inf_proyecto_version = @Version;
