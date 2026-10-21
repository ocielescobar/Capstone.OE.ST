// Fuente del nodo n8n: Registrar plan completado
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');
staticData.completos = (staticData.completos || 0) + 1;

return [{
  json: {
    pro_codigo: $json.pro_codigo,
    estado: 'PLAN_COMPLETO',
    mensaje: $json.motivo || 'El plan mensual ya cubrió la vigencia total del proyecto.'
  }
}];
