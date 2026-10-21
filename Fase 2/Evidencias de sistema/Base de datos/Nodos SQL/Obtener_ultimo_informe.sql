-- FUENTE DEL NODO N8N: Obtener último informe
-- Contiene expresiones {{ ... }}. No ejecutar directamente en SSMS.
-- SQL conservado del JSON, incluidas sus llamadas comentadas.

SELECT 
    p.pro_codigo,
    p.pro_version,
    COALESCE(p._pro_fecha_termino_oficial, p.pro_fecha_termino) AS fecha_termino,
    ISNULL(MAX(i.inf_numero), 0) AS ultimo_inf_numero,
    MAX(i.inf_fecha_corte) AS ultima_fecha_corte
FROM dbo.PROYECTOS_X p
LEFT JOIN dbo.PROYECTO_INFORME i 
    ON i.inf_proyecto_codigo = p.pro_codigo 
   AND i.inf_proyecto_version = p.pro_version
WHERE p.pro_codigo = '{{ $json.pro_codigo }}'
  AND p.pro_version = {{ $json.pro_version }}
GROUP BY 
    p.pro_codigo, 
    p.pro_version, 
    p._pro_fecha_termino_oficial, 
    p.pro_fecha_termino;
