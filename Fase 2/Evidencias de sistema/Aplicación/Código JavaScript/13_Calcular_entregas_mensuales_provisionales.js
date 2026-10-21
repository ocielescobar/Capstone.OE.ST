// Fuente del nodo n8n: Calcular entregas mensuales provisionales
// Requiere contexto n8n: items, $input u otras variables.

function normalizarFecha(valor) {
  if (
    valor === null ||
    valor === undefined ||
    valor === ''
  ) {
    return null;
  }

  const texto = String(valor).trim();
  const coincidencia = texto.match(
    /^(\d{4})-(\d{2})-(\d{2})/
  );

  if (coincidencia) {
    return `${coincidencia[1]}-${coincidencia[2]}-${coincidencia[3]}`;
  }

  const fecha = new Date(valor);

  if (Number.isNaN(fecha.getTime())) {
    return null;
  }

  return fecha.toISOString().slice(0, 10);
}

return items.map(({ json }) => {
  const tipo = Number(json.inf_tipo_propuesto);

  const esInformeAvance = tipo === 2;
  const esInformeFinal = tipo === 4;

  let fechaEntrega = null;
  let metodoCalculo = null;
  let observacion = null;

  if (esInformeAvance) {
    fechaEntrega = normalizarFecha(
      json.fecha_entrega_propuesta
    );

    metodoCalculo =
      '15_DIAS_HABILES_CALENDARIO_CORFO';

    observacion =
      'Calculado con calendario institucional Draco (días hábiles y feriados).';
  }

  if (esInformeFinal) {
    fechaEntrega = normalizarFecha(
      json.fecha_entrega_propuesta ??
      json.fecha_entrega_final_base ??
      json.fecha_entrega_final_sql
    );

    if (fechaEntrega) {
      metodoCalculo =
        'PLAZO_FINAL_EXISTENTE';

      observacion =
        'Fecha obtenida del informe final existente del proyecto.';
    } else {
      metodoCalculo =
        'PLAZO_FINAL_NO_DEFINIDO';

      observacion =
        'El plazo del informe final debe obtenerse del acto, convenio o regla institucional.';
    }
  }

  return {
    json: {
      ...json,

      fecha_entrega_propuesta:
        fechaEntrega,

      metodo_calculo_entrega:
        metodoCalculo,

      observacion_entrega:
        observacion,

      requiere_calendario_habil:
        esInformeAvance,

      calendario_habil_disponible:
        esInformeAvance
          ? json.calendario_habil_disponible === true
          : true,

      entrega_es_provisional:
        false,

      requiere_plazo_final:
        esInformeFinal,

      plazo_final_disponible:
        esInformeFinal
          ? Boolean(fechaEntrega)
          : Boolean(json.plazo_final_disponible)
    }
  };
});
