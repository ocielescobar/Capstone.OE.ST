// Fuente del nodo n8n: Consolidar métricas del proceso
// Requiere contexto n8n: items, $input u otras variables.

const staticData = $getWorkflowStaticData('global');

const creados = staticData.creados || 0;
const completos = staticData.completos || 0;
const alertas = staticData.alertas || 0;
const corregidos = staticData.corregidos || 0;
const totalAnalizados = creados + completos + alertas + corregidos;

const fechaFin = new Date().toLocaleString("es-CL", { timeZone: "America/Santiago" });

return [{
  json: {
    estado_lote: "PROCESO_FINALIZADO",
    fecha_termino: fechaFin,
    total_procesados: totalAnalizados,
    planes_creados: creados,
    planes_corregidos: corregidos,
    planes_al_dia: completos,
    alertas_incompletos: alertas
  }
}];
