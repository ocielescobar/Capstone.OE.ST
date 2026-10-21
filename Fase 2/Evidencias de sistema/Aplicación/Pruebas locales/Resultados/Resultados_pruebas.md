# Resultados reales de pruebas locales

Fecha UTC: 2026-10-21T15:57:02.033Z

Runtime: v24.19.0

SHA256 del flujo: d89786062885bc5dc4177e1f6c8d101a12097632a87b883ac3f06de5f521deb1

Funciones JavaScript originales con items y $input simulados; no ejecuta n8n, SQL ni correo.

Total: 12; aprobadas: 7; fallidas: 5; errores: 0.

## CP-01 Aprobada local

Nodo: Normalizar fechas de vigencia

Entrada: {"fecha_inicio_base":"2026-03-05T00:00:00Z"}

Obtenido: {"fecha_inicio_sql":"2026-03-05"}

## CP-02 Aprobada local

Nodo: Normalizar fechas de vigencia

Entrada: {"fecha_inicio_base":null}

Obtenido: {"fecha_inicio_sql":null}

## CP-03 Fallida local

Nodo: Normalizar fechas de vigencia

Entrada: {"fecha_inicio_base":"2026-02-31"}

Obtenido: {"fecha_inicio_sql":"2026-02-31"}

## CP-04 Aprobada local

Nodo: Validar propuesta de plan

Entrada: {"pro_codigo":"PRUEBA-001","pro_version":1,"numero_mes":1,"inf_tipo_propuesto":2,"fecha_inicio_propuesta":"2026-01-01","fecha_corte_propuesta":"2026-01-31","fecha_entrega_propuesta":"2026-02-20"}

Obtenido: {"propuesta_valida":true}

## CP-05 Aprobada local

Nodo: Validar propuesta de plan

Entrada: {"pro_codigo":"PRUEBA-001","pro_version":1,"numero_mes":1,"inf_tipo_propuesto":2,"fecha_inicio_propuesta":"2026-01-01","fecha_corte_propuesta":"2026-01-31","fecha_entrega_propuesta":null}

Obtenido: {"propuesta_valida":false,"errores":"No se calculó la fecha de entrega con el calendario institucional."}

## CP-06 Aprobada local

Nodo: Preparar correcciones mensuales

Entrada: {"inf_estado":2,"inf_fecha_corte":"2026-01-15"}

Obtenido: {"accion":"SIN_CAMBIOS","corte":"2026-01-15"}

## CP-07 Aprobada local

Nodo: Preparar correcciones mensuales

Entrada: {"inf_estado":1,"inf_fecha_corte":"2026-01-15"}

Obtenido: {"accion":"ACTUALIZAR_FECHA_CORTE","corte":"2026-01-31"}

## CP-08 Fallida local

Nodo: Calcular siguiente informe mensual

Entrada: {"fecha_termino":null,"ultima_fecha_corte":"2026-01-31"}

Obtenido: {"plan_finalizado":true,"motivo":"El proyecto ya alcanzó o superó su fecha oficial de término."}

## CP-09 Fallida local

Nodo: Calcular siguiente informe mensual

Entrada: {"fecha_termino":"2026-12-31","ultima_fecha_corte":"2026-01-31","ultimo_inf_numero":1}

Obtenido: {"corte":"2026-03-03","entrega":"2026-03-18"}

## CP-10 Aprobada local

Nodo: Calcular siguiente informe mensual

Entrada: {"fecha_termino":"2026-12-31","ultima_fecha_corte":"2026-12-31"}

Obtenido: {"plan_finalizado":true}

## CP-11 Fallida local

Nodo: Calcular entregas mensuales provisionales

Entrada: {"inf_tipo_propuesto":4,"fecha_entrega_propuesta":"2026-02-20","fecha_entrega_final_base":"2026-03-15"}

Obtenido: {"entrega":"2026-02-20","metodo":"PLAZO_FINAL_EXISTENTE"}

## CP-12 Fallida local

Nodo: Validar propuesta de plan

Entrada: {"pro_codigo":"PRUEBA-001","pro_version":1,"numero_mes":1,"inf_tipo_propuesto":2,"fecha_inicio_propuesta":"2026-01-01","fecha_corte_propuesta":"2026-01-31","fecha_entrega_propuesta":"2026-02-20","modo_simulacion":true,"aplicar_cambio":false}

Obtenido: {"modo_simulacion":false,"aplicar_cambio":true}
