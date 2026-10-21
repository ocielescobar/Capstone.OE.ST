// Fuente del nodo n8n: Sumar Creado
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');
staticData.creados = (staticData.creados || 0) + 1;
return $input.all();
