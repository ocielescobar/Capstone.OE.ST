// Fuente del nodo n8n: Normalizar fechas de vigencia
// Requiere contexto n8n: items, $input u otras variables.

function fechaISO(valor) {
  if (
    valor === null ||
    valor === undefined ||
    valor === ''
  ) {
    return null;
  }

  const texto = String(valor).trim();

  // Si ya viene como YYYY-MM-DD o como fecha ISO.
  const coincidenciaISO = texto.match(
    /^(\d{4})-(\d{2})-(\d{2})/
  );

  if (coincidenciaISO) {
    return (
      `${coincidenciaISO[1]}-` +
      `${coincidenciaISO[2]}-` +
      `${coincidenciaISO[3]}`
    );
  }

  // Respaldo por si n8n lo convirtió en un objeto Date
  // o en otro formato reconocible por JavaScript.
  const fecha = new Date(valor);

  if (Number.isNaN(fecha.getTime())) {
    return null;
  }

  const anio = fecha.getUTCFullYear();

  const mes = String(
    fecha.getUTCMonth() + 1
  ).padStart(2, '0');

  const dia = String(
    fecha.getUTCDate()
  ).padStart(2, '0');

  return `${anio}-${mes}-${dia}`;
}

function booleano(valor) {
  return (
    valor === true ||
    valor === 1 ||
    String(valor).trim().toLowerCase() === 'true'
  );
}

return items.map(item => {
  const entrada = item.json;

  const fechaInicioSQL = fechaISO(
    entrada.fecha_inicio_base
  );

  const fechaTerminoSQL = fechaISO(
    entrada.fecha_termino_base
  );

  const fechaEntregaFinalSQL = fechaISO(
    entrada.fecha_entrega_final_base
  );

  const plazoFinalDisponible =
    booleano(entrada.plazo_final_disponible) &&
    fechaEntregaFinalSQL !== null;

  return {
    json: {
      ...entrada,

      proyecto_sql: String(
        entrada.pro_codigo ?? ''
      ).trim(),

      version_sql: String(
        entrada.pro_version ?? ''
      ).trim(),

      fecha_inicio_sql:
        fechaInicioSQL,

      fecha_termino_sql:
        fechaTerminoSQL,

      numero_informe_final_existente:
        entrada.numero_informe_final_existente ?? null,

      fecha_corte_final_sql:
        fechaISO(
          entrada.fecha_corte_final_existente
        ),

      fecha_entrega_final_sql:
        fechaEntregaFinalSQL,

      plazo_final_disponible:
        plazoFinalDisponible
    }
  };
});
