-- 28. Las bebidas que se sirven en las fuentes de soda que son frecuentadas por las personas que no les gusta la malta.

SELECT DISTINCT
    beb.codbeb,
    beb.nombrebeb,
    q0.ci
FROM (
    SELECT
        *
    FROM bebedor beb
    WHERE NOT EXISTS(
        SELECT 
            1
        FROM (
            SELECT 
                b.ci AS "cen_cedula",
                b.nombre AS "cen_nombre"
            FROM (  SELECT 
                        *
                    FROM bebida
                    WHERE nombrebeb = 'Malta') s
            JOIN gusta g ON g.codbeb = s.codbeb
            JOIN bebedor b ON g.ci = b.ci 
        ) 
        WHERE beb.ci = "cen_cedula" AND beb.nombre = "cen_nombre"
    )
) q0 
JOIN frecuenta fr ON q0.ci = fr.ci
JOIN vende v ON fr.codfs = v.codfs
JOIN bebida beb ON v.codbeb = beb.codbeb;