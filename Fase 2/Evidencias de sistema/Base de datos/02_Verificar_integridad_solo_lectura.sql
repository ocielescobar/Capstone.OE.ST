/* Verificación dirigida a datos ficticios o autorizados de prueba.
   No crea, inserta, actualiza ni elimina. No invoca INS ni UPD.
   Se detiene si faltan parámetros. Guardar las salidas reales. */
SET NOCOUNT ON;
IF DB_NAME() <> N'Innova_Produccion'
    THROW 50001, 'Seleccionar la base de prueba Innova_Produccion.', 1;
DECLARE @Proyecto nvarchar(30)=NULL; -- código autorizado de prueba
DECLARE @Version int=NULL;          -- versión del fixture
DECLARE @Corte date=NULL;           -- corte a verificar
IF NULLIF(LTRIM(RTRIM(@Proyecto)),N'') IS NULL OR @Version IS NULL OR @Corte IS NULL
    THROW 50002, 'Informar proyecto, version y corte de prueba.', 1;

-- A. Identidad y vigencia del proyecto.
SELECT pro_codigo,pro_version,pro_estado,pro_categoria,
       COALESCE(_pro_fecha_inicio_oficial,pro_fecha_inicio) AS inicio_base,
       COALESCE(_pro_fecha_termino_oficial,pro_fecha_termino) AS termino_base
FROM dbo.PROYECTOS_X WHERE pro_codigo=@Proyecto AND pro_version=@Version;

-- B. Valores de informes para comparar antes/después de una prueba.
SELECT inf_proyecto_codigo,inf_proyecto_version,inf_numero,inf_tipo,inf_estado,
       inf_fecha_corte,inf_entrega_programada
FROM dbo.PROYECTO_INFORME
WHERE inf_proyecto_codigo=@Proyecto AND inf_proyecto_version=@Version
ORDER BY inf_numero;

-- C. Identidades lógicas duplicadas. Cero filas es lo esperado.
SELECT inf_proyecto_codigo,inf_proyecto_version,inf_numero,COUNT(*) AS repeticiones
FROM dbo.PROYECTO_INFORME
WHERE inf_proyecto_codigo=@Proyecto AND inf_proyecto_version=@Version
GROUP BY inf_proyecto_codigo,inf_proyecto_version,inf_numero HAVING COUNT(*)>1;

-- D. Fechas ausentes o entrega anterior al corte: casos por revisar.
SELECT inf_numero,inf_estado,inf_fecha_corte,inf_entrega_programada
FROM dbo.PROYECTO_INFORME
WHERE inf_proyecto_codigo=@Proyecto AND inf_proyecto_version=@Version
  AND (inf_fecha_corte IS NULL OR inf_entrega_programada IS NULL
       OR inf_entrega_programada<inf_fecha_corte);

-- E. Cobertura explícita de quince días hábiles después del corte.
SELECT COUNT(*) AS filas_disponibles,
       COUNT(DISTINCT CAST(FECHA AS date)) AS dias_habiles_distintos,
       MAX(FECHA) AS entrega_calculada,
       CASE WHEN COUNT(*)=15 AND COUNT(DISTINCT CAST(FECHA AS date))=15
            THEN 'COBERTURA_OK' ELSE 'CALENDARIO_INSUFICIENTE_O_DUPLICADO' END AS estado
FROM (SELECT TOP (15) FECHA FROM dbo.CALENDARIO
      WHERE FECHA>@Corte AND ES_HABIL=1 ORDER BY FECHA) AS habiles;
SELECT TOP (15) FECHA,ES_HABIL FROM dbo.CALENDARIO
WHERE FECHA>@Corte AND ES_HABIL=1 ORDER BY FECHA;

-- F. Pendientes y estados ausentes.
SELECT COUNT(*) AS total,
       SUM(CASE WHEN inf_estado=1 THEN 1 ELSE 0 END) AS pendientes,
       SUM(CASE WHEN inf_estado<>1 THEN 1 ELSE 0 END) AS no_pendientes,
       SUM(CASE WHEN inf_estado IS NULL THEN 1 ELSE 0 END) AS estado_no_informado
FROM dbo.PROYECTO_INFORME
WHERE inf_proyecto_codigo=@Proyecto AND inf_proyecto_version=@Version;
