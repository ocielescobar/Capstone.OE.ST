# Evidencias de aplicación del capstone DUOC

Ociel Escobar y Sebastian Torres · 21-10-2026.

## Contenido

- 01_Flujo_actual_PID_R2.json: copia idéntica del flujo actual de 39 nodos.
- 02_Guia_y_evidencias_aplicacion.pdf: alcance, importación, operación y pruebas.
- 03_Inventario_nodos.csv: nodos, tipos, identificadores y conexiones.
- 04_Revision_estructura.json: comprobaciones locales y hash de la fuente.
- Código JavaScript: funciones extraídas. Requieren el contexto de n8n, no son programas independientes.
- Pruebas locales: ejecutor, fixtures y criterios, resultados reales en JSON, CSV y Markdown.
- 05_Registro_capturas_pendientes.csv: registro por completar con capturas auténticas de la instancia.
- MANIFIESTO_SHA256.csv: hashes de archivos entregados, excluido el propio manifiesto.

## Reproducir las pruebas

Con Node.js disponible, abrir una terminal en esta carpeta y ejecutar:

    node ".\Pruebas locales\ejecutar_pruebas.mjs"

El ejecutor incorpora los doce fixtures y criterios de comparación; Fixtures_y_criterios.json los documenta para lectura. El programa carga el JSON original, simula items y $input y escribe los resultados locales. No importa el flujo ni consulta SQL ni invoca correo. No requiere paquetes adicionales.

La salida 1 informa casos fallidos y es esperada en esta versión. Los resultados incluidos indican su runtime, fecha real UTC y hash de la fuente. CP-01 a CP-12 se relacionan con Pruebas.xlsx de Evidencias de documentación. La ejecución local no acredita aceptación integrada.

## Importación y prueba en n8n

1. Trabajar con una copia del workflow en el ambiente del capstone.
2. Importar el JSON con la opción disponible en su instalación o pegar los nodos en un lienzo nuevo. El fragmento no incluye nombre global, active ni settings.
3. Revisar y asignar las credenciales SQL. Las referencias del JSON no incluyen contraseñas; el nombre DRACO no demuestra el entorno real.
4. Comprobar el subflujo baPGZq93Efo5Dti6, sus entradas y el destinatario de prueba; su definición no está incluida.
5. Configurar y verificar America/Santiago y hora local 07:00. El JSON solo declara triggerAtHour=7.
6. Mantener INS_PROYECTO_INFORME y UPD_PROYECTO_INFORME comentados en la copia de demostración. Varios nodos reasignan los indicadores; el modo de simulación no tiene un único origen.
7. Para demostrar la lógica sin servicios externos usar las pruebas locales. Una ejecución conectada del flujo puede enviar correos aunque las escrituras estén comentadas; revisar primero el destinatario de prueba.
8. Guardar ID de ejecución, entradas ficticias, salidas y capturas antes de habilitar la programación.

## Estado real

Las inserciones y actualizaciones de informes están comentadas. Los contadores de creados/corregidos no prueban persistencia. La rama Microsoft SQL mantiene una transacción vacía. Las llamadas de correo siguen configuradas.

Completar el registro de capturas con evidencias auténticas. Las verificaciones de SQL Server están pendientes y se encuentran en la carpeta hermana Base de datos.
