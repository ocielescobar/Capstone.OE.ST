-- FUENTE DEL NODO N8N: Microsoft SQL
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

BEGIN TRANSACTION;
/*
EXEC dbo.INS_PROYECTO_INFORME
    @PROYECTO = '{{ $json.pro_codigo }}',
    @VERSION = {{ $json.pro_version }},
    @INFORME = {{ $json.siguiente_inf_numero }},
    @TIPO = 1,
    @ESTADO = 1,
    @APROBACION_FECHA = NULL,
    @FECHA_CORTE = '{{ $json.siguiente_fecha_corte }}',
    @NOMBRE = N'{{ $json.nombre_informe }}',
    @DESCRIPCION = N'Generación mensual automática siguiente período',
    @ENTREGA = '{{ $json.siguiente_fecha_entrega }}',
    @USUARIO = N'CORFO\ociel.escobar';
*/
COMMIT TRANSACTION;
