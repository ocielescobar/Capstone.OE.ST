-- FUENTE DEL NODO N8N: Crear PID en Base de Datos
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

DECLARE @Proyecto nvarchar(30) = NULLIF(LTRIM(RTRIM(N'{{ $json.pro_codigo }}')), N'');
DECLARE @Version int = TRY_CONVERT(int, N'{{ $json.pro_version }}');
DECLARE @Informe int = TRY_CONVERT(int, COALESCE(NULLIF(N'{{ $json.numero_mes }}', N''), NULLIF(N'{{ $json.numero_mes_propuesto }}', N''), N'1'));
DECLARE @Tipo int = ISNULL(TRY_CONVERT(int, N'{{ $json.inf_tipo_propuesto }}'), 2);
DECLARE @Estado int = ISNULL(TRY_CONVERT(int, N'{{ $json.estado_informe_propuesto }}'), 1);
DECLARE @Nombre nvarchar(100) = NULLIF(LTRIM(RTRIM(N'{{ $json.nombre_propuesto }}')), N'');
DECLARE @Descripcion nvarchar(500) = N'Generado automáticamente vía automatización PID';

-- Parseo compatible con sufijos ISO 'Z' o formato plano YYYY-MM-DD
DECLARE @FechaCorte datetime = COALESCE(
    CAST(TRY_CONVERT(datetimeoffset, N'{{ $json.fecha_corte_propuesta }}') AS datetime),
    TRY_CONVERT(datetime, LEFT(N'{{ $json.fecha_corte_propuesta }}', 10), 23),
    TRY_CONVERT(datetime, LEFT(N'{{ $json.fecha_corte_propuesta }}', 10), 120)
);

DECLARE @FechaEntrega smalldatetime = COALESCE(
    CAST(TRY_CONVERT(datetimeoffset, N'{{ $json.fecha_entrega_propuesta }}') AS smalldatetime),
    TRY_CONVERT(smalldatetime, LEFT(N'{{ $json.fecha_entrega_propuesta }}', 10), 23),
    TRY_CONVERT(smalldatetime, LEFT(N'{{ $json.fecha_entrega_propuesta }}', 10), 120)
);

DECLARE @Usuario nvarchar(50) = N'CORFO\ociel.escobar';

IF @Proyecto IS NOT NULL 
   AND @Version IS NOT NULL 
   AND @Informe IS NOT NULL 
   AND @FechaCorte IS NOT NULL 
   AND @FechaEntrega IS NOT NULL
BEGIN
    /*
    EXEC dbo.INS_PROYECTO_INFORME
        @PROYECTO = @Proyecto,
        @VERSION = @Version,
        @INFORME = @Informe,
        @TIPO = @Tipo,
        @ESTADO = @Estado,
        @NOMBRE = @Nombre,
        @DESCRIPCION = @Descripcion,
        @FECHA_CORTE = @FechaCorte,
        @ENTREGA = @FechaEntrega,
        @USUARIO = @Usuario;
    */

    SELECT 
        @Proyecto AS pro_codigo,
        @Version AS pro_version,
        @Informe AS numero_mes,
        'SIMULADO_INSERCION_OK' AS estado_resultado,
        @FechaCorte AS fecha_corte_aplicada,
        @FechaEntrega AS fecha_entrega_aplicada;
END
ELSE
BEGIN
    SELECT 
        @Proyecto AS pro_codigo,
        @Version AS pro_version,
        @Informe AS numero_mes,
        'ERROR_DATOS_INCOMPLETOS_SP' AS estado_resultado,
        @FechaCorte AS fecha_corte_aplicada,
        @FechaEntrega AS fecha_entrega_aplicada;
END;
