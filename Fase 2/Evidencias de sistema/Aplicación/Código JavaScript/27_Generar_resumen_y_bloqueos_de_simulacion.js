// Fuente del nodo n8n: Generar resumen y bloqueos de simulación
// Requiere contexto n8n: items, $input u otras variables.

return items.map(({ json }) => {
  const bloqueos = [];

  if (!json.propuesta_valida) {
    bloqueos.push(json.errores_validacion || 'Propuesta no válida');
  }
  if (json.modo_simulacion === true) {
    bloqueos.push('Modo simulación activo (escritura bloqueada por seguridad)');
  }
  if (json.aplicar_cambio !== true) {
    bloqueos.push('Flag aplicar_cambio en false');
  }

  return {
    json: {
      pro_codigo: json.pro_codigo,
      pro_version: json.pro_version,
      pro_codigo_humano: json.pro_codigo_humano,
      resultado_ejecucion: 'SIMULADO_NO_APLICADO',
      propuesta_valida: json.propuesta_valida,
      numero_mes_propuesto: json.numero_mes,
      fecha_corte_propuesta: json.fecha_corte_propuesta,
      fecha_entrega_propuesta: json.fecha_entrega_propuesta,
      tipo_periodo_propuesto: json.tipo_periodo_propuesto,
      modo_simulacion: json.modo_simulacion,
      aplicar_cambio: json.aplicar_cambio,
      cantidad_bloqueos: bloqueos.length,
      motivos_no_ejecucion: bloqueos.join(' | '),
      fecha_simulacion: new Date().toISOString()
    }
  };
});
