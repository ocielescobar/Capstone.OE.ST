-- FUENTE DEL NODO N8N: Obtener informes actuales
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

DECLARE @Proyecto nvarchar(30) = NULLIF(LTRIM(RTRIM(N'{{ $json.pro_codigo }}')), N'');
DECLARE @Version int = TRY_CONVERT(int, N'{{ $json.pro_version }}');

SELECT 
    i.inf_proyecto_codigo AS pro_codigo,
    i.inf_proyecto_version AS pro_version,
    i.inf_numero,
    i.inf_tipo,
    ti.tpi_descripcion AS tipo_informe,
    ti.tpi_permite_cuota,
    ti.tpi_subsidio,
    ti.tpi_solicitud_financiera,
    i.inf_estado,
    i.inf_fecha_corte,
    i.inf_nombre
FROM dbo.PROYECTO_INFORME AS i
LEFT JOIN dbo.TIPO_INFORME AS ti 
    ON ti.tpi_codigo = i.inf_tipo
WHERE i.inf_proyecto_codigo = @Proyecto 
  AND i.inf_proyecto_version = @Version
ORDER BY i.inf_numero ASC;
