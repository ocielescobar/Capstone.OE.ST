// Fuente del nodo n8n: Calcular siguiente informe mensual
// Requiere contexto n8n: items, $input u otras variables.

const item = $input.first().json;

const fechaTermino = item.fecha_termino ? new Date(item.fecha_termino) : null;
const ultimaFechaCorte = item.ultima_fecha_corte ? new Date(item.ultima_fecha_corte) : null;
const ultimoNumero = item.ultimo_inf_numero || 0;

// Si ya igualó o superó la fecha de término, el plan está finalizado
if (!fechaTermino || (ultimaFechaCorte && ultimaFechaCorte >= fechaTermino)) {
  return [{
    json: {
      ...item,
      plan_finalizado: true,
      motivo: "El proyecto ya alcanzó o superó su fecha oficial de término."
    }
  }];
}

// Proyectar siguiente mes (+1 mes calendario)
let siguienteCorte = new Date(ultimaFechaCorte);
siguienteCorte.setMonth(siguienteCorte.getMonth() + 1);

// Si sobrepasa el término oficial, se acota a la fecha término
if (siguienteCorte > fechaTermino) {
  siguienteCorte = fechaTermino;
}

// Fecha de entrega sugerida (ej. 15 días posteriores al corte)
const siguienteEntrega = new Date(siguienteCorte);
siguienteEntrega.setDate(siguienteEntrega.getDate() + 15);

return [{
  json: {
    ...item,
    plan_finalizado: false,
    siguiente_inf_numero: ultimoNumero + 1,
    siguiente_fecha_corte: siguienteCorte.toISOString().slice(0, 10),
    siguiente_fecha_entrega: siguienteEntrega.toISOString().slice(0, 10),
    nombre_informe: `Informe de Avance N° ${ultimoNumero + 1}`
  }
}];
