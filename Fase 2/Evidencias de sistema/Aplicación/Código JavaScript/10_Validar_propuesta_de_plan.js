// Fuente del nodo n8n: Validar propuesta de plan
// Requiere contexto n8n: items, $input u otras variables.

function fecha(valor) {
  if (!valor) return null;
  if (typeof valor === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(valor)) {
    const [y, m, d] = valor.split('-').map(Number);
    return new Date(Date.UTC(y, m - 1, d));
  }
  const resultado = new Date(valor);
  return Number.isNaN(resultado.getTime()) ? null : resultado;
}

return items.map(({ json }) => {
  const errores = [];

  const codigo = String(json.pro_codigo || '').trim();
  const version = json.pro_version;
  const numeroMes = Number(json.numero_mes);
  const tipo = Number(json.inf_tipo_propuesto);

  const inicio = fecha(json.fecha_inicio_propuesta);
  const corte = fecha(json.fecha_corte_propuesta);
  const entrega = fecha(json.fecha_entrega_propuesta);

  // 1. Validaciones de Identificación
  if (!codigo) {
    errores.push('Falta el código de proyecto.');
  }

  if (version === null || version === undefined || version === '') {
    errores.push('Falta la versión del proyecto.');
  }

  // 2. Validaciones de Hito
  if (!Number.isInteger(numeroMes) || numeroMes < 1) {
    errores.push(`Número de informe inválido (${numeroMes}).`);
  }

  // 3. Validaciones de Fechas de Período
  if (!inicio || !corte) {
    errores.push('Fechas de inicio o corte incompletas.');
  } else if (corte < inicio) {
    errores.push('La fecha de corte es anterior al inicio del período.');
  }

  // 4. Validación de Entrega Hábil
  if (!entrega) {
    errores.push('No se calculó la fecha de entrega con el calendario institucional.');
  } else if (corte && entrega < corte) {
    errores.push('La fecha de entrega es anterior a la fecha de corte.');
  }

  const propuestaValida = errores.length === 0;

  return {
    json: {
      ...json,
      propuesta_valida: propuestaValida,
      cantidad_informes_propuestos: 1, // 1 informe inmediato para este proyecto
      errores_validacion: errores.length > 0 ? errores.join(' | ') : null,
      requiere_calendario_habil: true,
      calendario_habil_disponible: Boolean(entrega),
      requiere_plazo_final: tipo === 4,
      plazo_final_disponible: Boolean(entrega),
      aplicar_cambio: true,           // Conserva el seguro de simulación
      modo_simulacion: false
    }
  };
});
