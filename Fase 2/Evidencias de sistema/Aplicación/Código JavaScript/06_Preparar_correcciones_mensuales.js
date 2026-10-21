// Fuente del nodo n8n: Preparar correcciones mensuales
// Requiere contexto n8n: items, $input u otras variables.

function fechaValida(valor) {
  if (!valor) return null;
  const fecha = new Date(valor);
  return Number.isNaN(fecha.getTime()) ? null : fecha;
}

function finDelMes(fecha) {
  return new Date(Date.UTC(
    fecha.getUTCFullYear(),
    fecha.getUTCMonth() + 1,
    0,
    0,
    0,
    0
  ));
}

function formatoFecha(fecha) {
  if (!fecha) return null;
  return fecha.toISOString().slice(0, 10);
}

return items.map(({ json }) => {
  const corteActual = fechaValida(json.inf_fecha_corte);
  const esPendiente = Number(json.inf_estado) === 1;

  let accion = 'SIN_CAMBIOS';
  let motivo = 'El informe cuenta con parametrización válida.';
  let cortePropuesto = corteActual;

  if (!corteActual) {
    if (esPendiente) {
      accion = 'ASIGNAR_FECHA_CORTE';
      motivo = 'Se requiere asignar fecha de corte mensual.';
      
      // Si es informe final o no hay corte, tomamos fecha_termino del proyecto
      const fechaTerminoRef = fechaValida(json.fecha_termino || json._pro_fecha_termino_oficial);
      if (fechaTerminoRef) {
        cortePropuesto = finDelMes(fechaTerminoRef);
      } else {
        // En caso de no tener fecha término, sugerir fin del mes actual
        cortePropuesto = finDelMes(new Date());
      }
    } else {
      accion = 'BLOQUEADO_NO_PENDIENTE';
      motivo = 'Informe sin fecha de corte pero no está en estado pendiente.';
    }
  } else {
    const ultimoDia = finDelMes(corteActual);
    const estaCerradoAlFinDeMes = corteActual.getUTCDate() === ultimoDia.getUTCDate();

    if (!estaCerradoAlFinDeMes && esPendiente) {
      accion = 'ACTUALIZAR_FECHA_CORTE';
      cortePropuesto = ultimoDia;
      motivo = 'Se propone ajustar la fecha de corte al último día del mes calendario.';
    } else if (!esPendiente) {
      accion = 'SIN_CAMBIOS';
      motivo = 'Informe ya tramitado o cerrado (no pendiente).';
    }
  }

  return {
    json: {
      ...json,
      accion_correccion: accion,
      motivo_correccion: motivo,
      fecha_corte_original: formatoFecha(corteActual),
      fecha_corte_propuesta: formatoFecha(cortePropuesto),
      aplicar_cambio: true,
      modo_simulacion: false
    }
  };
});
