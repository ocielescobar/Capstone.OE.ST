// Fuente del nodo n8n: Resolver acción según colisiones
// Requiere contexto n8n: items, $input u otras variables.

return items.map(({ json }) => {
  const totalExistentes = Number(json.total_informes_existentes ?? 0);
  const colisionesMismoNumero = Number(json.colisiones_mismo_numero ?? 0);
  const crearPlanAutorizable = json.crear_plan_completo_autorizable === true;

  // Si no tiene informes y está autorizado -> CREAR_PLAN
  // Si ya tiene informes previos pero no colisiona -> CONFIGURAR_PLAN_MENSUAL
  const accionSegura = (totalExistentes === 0 && crearPlanAutorizable)
    ? 'CREAR_PLAN'
    : 'CONFIGURAR_PLAN_MENSUAL';

  return {
    json: {
      ...json, // Conserva todos los campos necesarios para la inserción (fechas, tipo, etc.)
      total_informes_existentes: totalExistentes,
      informes_finales_existentes: Number(json.informes_finales_existentes ?? 0),
      cantidad_colisiones: colisionesMismoNumero,
      crear_plan_completo_autorizable: crearPlanAutorizable,
      accion_pid_segura: accionSegura,
      diagnostico_colision: json.diagnostico_colision,
      requiere_configuracion_plan: accionSegura === 'CONFIGURAR_PLAN_MENSUAL',
      puede_insertar_plan_completo: accionSegura === 'CREAR_PLAN' && colisionesMismoNumero === 0,
      
      // Control de producción/simulación
      modo_simulacion: false,
      aplicar_cambio: true
    }
  };
});
