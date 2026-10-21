/* Capstone DUOC - Ociel Escobar y Sebastian Torres.
   Consultas de metadatos. No modifica objetos ni datos ni ejecuta SP.
   Guardar las salidas reales junto al registro de verificaciones. */
SET NOCOUNT ON;
IF DB_NAME() <> N'Innova_Produccion'
    THROW 50001, 'Seleccionar la base de prueba Innova_Produccion.', 1;

-- A. Confirmar el ambiente real.
SELECT CAST(SERVERPROPERTY('ServerName') AS nvarchar(128)) AS servidor,
       DB_NAME() AS base_actual, SYSDATETIMEOFFSET() AS fecha_verificacion;

-- B. Existencia y naturaleza real. No visible no equivale a inexistente.
SELECT esperados.nombre AS objeto_esperado, o.type_desc AS naturaleza,
       CASE WHEN o.object_id IS NULL THEN 'NO_VISIBLE_O_AUSENTE' ELSE 'VISIBLE' END AS estado
FROM (VALUES
 (N'PROYECTOS_X'),(N'PROYECTO_VERSIONES'),(N'PROYECTO_INFORME'),
 (N'PROYECTOS_AFECTOS_R2'),(N'PROYECTO_SITUACION'),(N'TIPO_INFORME'),
 (N'CALENDARIO'),(N'INS_PROYECTO_INFORME'),(N'UPD_PROYECTO_INFORME')
) AS esperados(nombre)
LEFT JOIN sys.schemas s ON s.name=N'dbo'
LEFT JOIN sys.objects o ON o.schema_id=s.schema_id AND o.name=esperados.nombre
ORDER BY esperados.nombre;

-- C. Columnas, tipos, longitudes y nulabilidad reales.
SELECT OBJECT_SCHEMA_NAME(c.object_id) AS esquema, OBJECT_NAME(c.object_id) AS objeto,
       c.column_id, c.name AS columna, t.name AS tipo, c.max_length AS longitud_bytes,
       c.precision, c.scale, c.is_nullable, c.is_identity
FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id
WHERE OBJECT_SCHEMA_NAME(c.object_id)=N'dbo'
  AND OBJECT_NAME(c.object_id) IN (N'PROYECTOS_X',N'PROYECTO_VERSIONES',N'PROYECTO_INFORME',
      N'PROYECTOS_AFECTOS_R2',N'PROYECTO_SITUACION',N'TIPO_INFORME',N'CALENDARIO')
ORDER BY objeto,c.column_id;

-- D. PK y unicidad reales.
SELECT OBJECT_NAME(i.object_id) AS objeto, i.name AS indice,
       i.is_primary_key, i.is_unique, ic.key_ordinal, c.name AS columna
FROM sys.indexes i
JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id=i.index_id
JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
WHERE OBJECT_SCHEMA_NAME(i.object_id)=N'dbo' AND ic.key_ordinal>0
  AND OBJECT_NAME(i.object_id) IN (N'PROYECTOS_X',N'PROYECTO_VERSIONES',N'PROYECTO_INFORME',
      N'PROYECTOS_AFECTOS_R2',N'PROYECTO_SITUACION',N'TIPO_INFORME',N'CALENDARIO')
  AND (i.is_primary_key=1 OR i.is_unique=1)
ORDER BY objeto,indice,ic.key_ordinal;

-- E. FK que involucran los objetos del modelo.
SELECT fk.name AS restriccion, OBJECT_NAME(fk.parent_object_id) AS objeto_origen,
       pc.name AS columna_origen, OBJECT_NAME(fk.referenced_object_id) AS objeto_destino,
       rc.name AS columna_destino, fk.is_disabled, fk.is_not_trusted
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id=fk.object_id
JOIN sys.columns pc ON pc.object_id=fk.parent_object_id AND pc.column_id=fkc.parent_column_id
JOIN sys.columns rc ON rc.object_id=fk.referenced_object_id AND rc.column_id=fkc.referenced_column_id
WHERE OBJECT_NAME(fk.parent_object_id) IN (N'PROYECTOS_X',N'PROYECTO_VERSIONES',N'PROYECTO_INFORME',
      N'PROYECTOS_AFECTOS_R2',N'PROYECTO_SITUACION',N'TIPO_INFORME',N'CALENDARIO')
   OR OBJECT_NAME(fk.referenced_object_id) IN (N'PROYECTOS_X',N'PROYECTO_VERSIONES',N'PROYECTO_INFORME',
      N'PROYECTOS_AFECTOS_R2',N'PROYECTO_SITUACION',N'TIPO_INFORME',N'CALENDARIO')
ORDER BY restriccion,fkc.constraint_column_id;

-- F. Contratos reales: no ejecuta estos procedimientos.
SELECT OBJECT_NAME(p.object_id) AS procedimiento, p.parameter_id, p.name AS parametro,
       t.name AS tipo, p.max_length AS longitud_bytes, p.precision, p.scale, p.is_output
FROM sys.parameters p JOIN sys.types t ON p.user_type_id=t.user_type_id
WHERE OBJECT_SCHEMA_NAME(p.object_id)=N'dbo'
  AND OBJECT_NAME(p.object_id) IN (N'INS_PROYECTO_INFORME',N'UPD_PROYECTO_INFORME')
ORDER BY procedimiento,p.parameter_id;

-- G. Triggers: solo inspección, sin habilitar ni deshabilitar.
SELECT name AS trigger_nombre, is_disabled, is_instead_of_trigger
FROM sys.triggers WHERE parent_id=OBJECT_ID(N'dbo.PROYECTO_INFORME');
