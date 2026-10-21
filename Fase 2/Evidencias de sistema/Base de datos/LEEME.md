# Evidencias de base de datos del capstone DUOC

Ociel Escobar y Sebastian Torres · 21-10-2026.

## Contenido

- 00_Guia_evidencias_base_datos.pdf: alcance y pasos para obtener evidencia real.
- 01_Verificar_metadatos_solo_lectura.sql: servidor, base, columnas, claves, FK, parámetros y triggers; sin cambiar datos u objetos.
- 02_Verificar_integridad_solo_lectura.sql: consultas dirigidas a proyecto y versión de prueba. Requiere completar tres parámetros.
- 03_Indice_consultas_del_flujo.csv: nueve nodos SQL y sus fuentes.
- 04_Objetos_y_dependencias.csv: siete objetos consultados y dos procedimientos previstos.
- 05_Registro_validaciones_pendientes.csv: resultados reales por completar.
- 06_Contrato_observado_procedimientos.md: parámetros inferidos de llamadas comentadas.
- Nodos SQL: fuente extraída del JSON con expresiones n8n {{ ... }}; no ejecutar directamente en SSMS.

## Cómo obtener evidencia integrada

1. Conectarse desde SSMS u otra herramienta al ambiente de prueba autorizado.
2. Seleccionar Innova_Produccion y ejecutar el script 01. Si la base de prueba tiene otro nombre, revisar el contexto y adaptar una copia de trabajo conscientemente.
3. Exportar resultados con fecha real. Un objeto no visible puede estar ausente o restringido por permisos.
4. Completar @Proyecto, @Version y @Corte en una copia del script 02 con datos ficticios o autorizados. Se detiene si faltan estos datos.
5. Guardar las salidas de integridad y completar el registro 05. Comparar valores, no solo conteos, para antes/después.
6. Vincular evidencia con CP-13 a CP-29 de Pruebas.xlsx. No marcar casos integrados aprobados por la sola existencia del script.

## Alcance

No se conectó a SQL Server al crear esta entrega. No se dispone de backups, DDL físico confirmado ni definiciones de procedimientos. El Modelo de datos.pdf de Evidencias de documentación es un modelo lógico inferido.

Las escrituras del flujo se mantienen comentadas. No se cambió el flujo ni se habilitaron operaciones reales. Los scripts proporcionan material verificable para completar las pruebas en el ambiente del equipo.
