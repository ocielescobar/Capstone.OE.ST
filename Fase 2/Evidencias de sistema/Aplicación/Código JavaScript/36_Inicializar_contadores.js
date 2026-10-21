// Fuente del nodo n8n: Inicializar contadores
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');
staticData.creados = 0;
staticData.completos = 0;
staticData.alertas = 0;
staticData.corregidos = 0;

return $input.all();
