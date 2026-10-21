-- FUENTE DEL NODO N8N: Aplicar corrección mensual PID
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Proyecto nvarchar(30) = NULLIF(LTRIM(RTRIM(N'{{ $json.pro_codigo }}')), N'');
DECLARE @Version int = TRY_CONVERT(int, N'{{ $json.pro_version }}');
DECLARE @Informe int = TRY_CONVERT(int, N'{{ $json.inf_numero }}');

DECLARE @FechaCortePropuesta datetime = COALESCE(
    CAST(TRY_CONVERT(datetimeoffset, N'{{ $json.fecha_corte_propuesta }}') AS datetime),
    TRY_CONVERT(datetime, LEFT(N'{{ $json.fecha_corte_propuesta }}', 10), 23),
    TRY_CONVERT(datetime, LEFT(N'{{ $json.fecha_corte_propuesta }}', 10), 120)
);

DECLARE @FechaEntrega smalldatetime = COALESCE(
    CAST(TRY_CONVERT(datetimeoffset, N'{{ $json.inf_entrega }}') AS smalldatetime),
    TRY_CONVERT(smalldatetime, LEFT(N'{{ $json.inf_entrega }}', 10), 23),
    TRY_CONVERT(smalldatetime, LEFT(N'{{ $json.inf_entrega }}', 10), 120)
);

DECLARE @AplicarCambio bit = ISNULL(TRY_CONVERT(bit, N'{{ $json.aplicar_cambio }}'), 0);
DECLARE @ModoSimulacion bit = ISNULL(TRY_CONVERT(bit, N'{{ $json.modo_simulacion }}'), 1);

DECLARE
    @Tipo int = ISNULL(TRY_CONVERT(int, N'{{ $json.inf_tipo }}'), 2),
    @Estado int = ISNULL(TRY_CONVERT(int, N'{{ $json.inf_estado }}'), 1),
    @AprobacionFecha datetime = NULL,
    @Nombre nvarchar(100) = ISNULL(NULLIF(LTRIM(RTRIM(N'{{ $json.inf_nombre }}')), N''), N'INFORME DE AVANCE'),
    @Descripcion nvarchar(500) = N'Actualización de fecha de corte mensual';

-- Lectura segura de valores existentes si el registro ya está en base de datos
SELECT
    @Tipo = ISNULL(i.inf_tipo, @Tipo),
    @Estado = ISNULL(i.inf_estado, @Estado),
    @AprobacionFecha = i.inf_aprobacion_fecha,
    @Nombre = ISNULL(i.inf_nombre, @Nombre),
    @Descripcion = ISNULL(i.inf_descripcion, @Descripcion)
FROM dbo.PROYECTO_INFORME AS i
WHERE i.inf_proyecto_codigo = @Proyecto
  AND i.inf_proyecto_version = @Version
  AND i.inf_numero = @Informe;

BEGIN TRY
    /*
    BEGIN TRANSACTION;

    EXEC dbo.UPD_PROYECTO_INFORME
        @PROYECTO = @Proyecto,
        @VERSION = @Version,
        @INFORME = @Informe,
        @TIPO = @Tipo,
        @ESTADO = @Estado,
        @APROBACION_FECHA = @AprobacionFecha,
        @FECHA_CORTE = @FechaCortePropuesta,
        @NOMBRE = @Nombre,
        @DESCRIPCION = @Descripcion,
        @ENTREGA = @FechaEntrega,
        @USUARIO = N'CORFO\ociel.escobar';

    COMMIT TRANSACTION;
    */

    SELECT
        @Proyecto AS pro_codigo,
        @Version AS pro_version,
        @Informe AS inf_numero,
        @FechaCortePropuesta AS inf_fecha_corte_nueva,
        @FechaEntrega AS inf_fecha_entrega,
        'SIMULADO_CORRECCION_OK' AS resultado_ejecucion;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
