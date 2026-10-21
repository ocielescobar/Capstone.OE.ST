# Contrato observado en las llamadas comentadas

Se describen parámetros que aparecen en el JSON, no firmas verificadas ni definiciones reales. Comparar con sys.parameters mediante el script 01.

## INS_PROYECTO_INFORME

Crear PID en Base de Datos referencia @PROYECTO, @VERSION, @INFORME, @TIPO, @ESTADO, @NOMBRE, @DESCRIPCION, @FECHA_CORTE, @ENTREGA y @USUARIO. La llamada está comentada. El SELECT devuelve SIMULADO_INSERCION_OK si hay datos mínimos.

La rama Microsoft SQL añade @APROBACION_FECHA=NULL y usa @TIPO=1. Conserva el INSERT comentado en una transacción vacía. Confirmar esta diferencia respecto de avance=2 de la rama inicial con el catálogo y la regla institucional.

## UPD_PROYECTO_INFORME

Aplicar corrección mensual PID referencia @PROYECTO, @VERSION, @INFORME, @TIPO, @ESTADO, @APROBACION_FECHA, @FECHA_CORTE, @NOMBRE, @DESCRIPCION, @ENTREGA y @USUARIO. Transacción y llamada comentadas; devuelve SIMULADO_CORRECCION_OK.

La entrega se construye desde inf_entrega. Obtener informes actuales no selecciona ese campo; verificar su propagación antes de preparar una actualización real.

## Evidencia física pendiente

Adjuntar contrato, tipos y permisos obtenidos del ambiente. Si el administrador entrega DDL o definiciones autorizadas, conservarlas con fecha y origen. No se incluye un CREATE TABLE ni procedimientos inventados. Ningún script preparado habilita triggers o ejecuta INS/UPD.
