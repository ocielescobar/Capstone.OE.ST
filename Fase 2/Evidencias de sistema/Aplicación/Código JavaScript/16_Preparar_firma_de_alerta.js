// Fuente del nodo n8n: Preparar firma de alerta
// Requiere contexto n8n: items, $input u otras variables.

const normalizar = (valor) =>
  String(valor ?? '')
    .trim()
    .replace(/\s+/g, ' ')
    .toUpperCase();

const proyecto = normalizar($json.pro_codigo);
const version = Number($json.pro_version) || 0;
const tipoAlerta = normalizar(
  $json.tipo_alerta || 'PID_R2_SIMULACION_EXITOSA'
);
const bloqueos = Number($json.cantidad_bloqueos_datos ?? $json.cantidad_bloqueos ?? 0);
const motivos = normalizar(
  $json.motivos_no_ejecucion || $json.detalle || 'SIN_BLOQUEOS_DATOS'
);

const totalInformes = $json.cantidad_informes_propuestos ?? 37;
const informesAvance = $json.cantidad_informes_avance ?? 36;
const informesFinales = $json.cantidad_informes_finales ?? 1;

// Cálculo de la firma de trazabilidad
const firmaBase = [
  `PROYECTO=${proyecto}`,
  `VERSION=${version}`,
  `TIPO=${tipoAlerta}`,
  `BLOQUEOS=${bloqueos}`,
  `MOTIVOS=${motivos}`,
].join('|');

// Armado de variables para el subflujo de correo
const asunto = `[PID R2] Simulación de propuesta completada para proyecto ${proyecto}`;
const flujoOrigen = 'Automatización PID R2 - Validación y Firma de Plan';

const cuerpoHtml = `
  <h2>Resumen de Validación PID R2</h2>
  <p><strong>Proyecto:</strong> ${proyecto} (Versión ${version})</p>
  <p><strong>Estado:</strong> SIMULACIÓN EXITOSA - DATOS COMPLETOS</p>
  <p><strong>Informes Propuestos:</strong> ${totalInformes} (Avances: ${informesAvance}, Finales: ${informesFinales})</p>
  <p><strong>Días Hábiles:</strong> Calculados mediante tabla dbo.CALENDARIO (Draco)</p>
  <p><strong>Firma de Trazabilidad:</strong> <code>${firmaBase}</code></p>
  <p><em>El plan mensual ha sido validado correctamente y está listo para formalización cuando se desactive el modo simulación.</em></p>
`;

return {
  json: {
    ...$json,
    destinatario: $json.destinatario || 'ociel.escobar@corfo.cl',
    asunto: asunto,
    cuerpo_html: cuerpoHtml,
    flujo_origen: flujoOrigen,
    firma_alerta_base: firmaBase,
    firma_alerta_base_sql: firmaBase.replace(/'/g, "''"),
  },
};
