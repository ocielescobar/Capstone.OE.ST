// Fuente del nodo n8n: Sumar corregido
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');
staticData.corregidos = (staticData.corregidos || 0) + 1;

// Retorna un único ítem para notificar al bucle que este proyecto terminó
return [{
  json: {
    estado_proceso: 'CORRECCION_FINALIZADA',
    ok: true
  }
}];
