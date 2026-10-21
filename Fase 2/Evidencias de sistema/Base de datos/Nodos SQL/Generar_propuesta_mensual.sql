-- FUENTE DEL NODO N8N: Generar propuesta mensual
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

DECLARE @Proyecto nvarchar(30) = NULLIF(LTRIM(RTRIM(N'{{ $json.proyecto_sql }}')), N'');
DECLARE @Version int = TRY_CONVERT(int, N'{{ $json.version_sql }}');
DECLARE @FechaInicio date = TRY_CONVERT(date, NULLIF(N'{{ $json.fecha_inicio_sql }}', N''), 23);
DECLARE @FechaTermino date = TRY_CONVERT(date, NULLIF(N'{{ $json.fecha_termino_sql }}', N''), 23);

-- 1. Determinar que numero de informe toca crear
DECLARE @UltimoInformeExistente int;
DECLARE @FechaInicioPropuesta date;
DECLARE @FechaCortePropuesta date;
DECLARE @NumeroMesACrear int;

SELECT @UltimoInformeExistente = ISNULL(MAX(inf_numero), 0)
FROM dbo.PROYECTO_INFORME
WHERE inf_proyecto_codigo = @Proyecto
  AND inf_proyecto_version = @Version;

SET @NumeroMesACrear = @UltimoInformeExistente + 1;

-- 2. Calcular las fechas del periodo correspondiente a ese mes
SET @FechaInicioPropuesta = DATEADD(MONTH, @NumeroMesACrear - 1, DATEFROMPARTS(YEAR(@FechaInicio), MONTH(@FechaInicio), 1));
SET @FechaCortePropuesta = EOMONTH(@FechaInicioPropuesta);

-- Si el corte supera la fecha de termino del convenio, se ajusta al termino real
IF @FechaCortePropuesta > @FechaTermino
BEGIN
    SET @FechaCortePropuesta = @FechaTermino;
END;

-- 3. Proyectar UN SOLO registro por proyecto (el hito siguiente)
SELECT
    @Proyecto AS pro_codigo,
    @Version AS pro_version,
    @NumeroMesACrear AS numero_mes,
    @FechaInicioPropuesta AS fecha_inicio_propuesta,
    @FechaCortePropuesta AS fecha_corte_propuesta,
    cal.fecha_entrega_calendario AS fecha_entrega_propuesta,
    
    CASE 
        WHEN @FechaCortePropuesta >= @FechaTermino THEN N'INFORME_FINAL'
        ELSE N'INFORME_AVANCE'
    END AS tipo_periodo_propuesto,
    
    CASE 
        WHEN @FechaCortePropuesta >= @FechaTermino THEN 4
        ELSE 2
    END AS inf_tipo_propuesto,
    
    CASE 
        WHEN @FechaCortePropuesta >= @FechaTermino THEN N'INFORME FINAL'
        ELSE CONCAT(N'INFORME DE AVANCE MES ', @NumeroMesACrear)
    END AS nombre_propuesto,
    
    CAST(1 AS int) AS estado_informe_propuesto,
    CAST(1 AS bit) AS modo_prueba,
    CAST(1 AS bit) AS propuesta_valida,
    CAST(0 AS bit) AS aplicar_cambio,
    CAST(1 AS bit) AS modo_simulacion

FROM (SELECT 1 AS dummy) AS d
OUTER APPLY
(
    SELECT MAX(sub.FECHA) AS fecha_entrega_calendario
    FROM (
        SELECT TOP (15) c.FECHA
        FROM dbo.CALENDARIO AS c
        WHERE c.FECHA > @FechaCortePropuesta
          AND c.ES_HABIL = 1
        ORDER BY c.FECHA ASC
    ) AS sub
) AS cal;
