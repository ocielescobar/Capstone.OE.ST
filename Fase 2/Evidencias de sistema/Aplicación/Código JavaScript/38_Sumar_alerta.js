// Fuente del nodo n8n: Sumar alerta
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');
staticData.alertas = (staticData.alertas || 0) + 1;

return $input.all();
