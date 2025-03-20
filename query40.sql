-- ################################################################################
-- CONSULTA: (42) Las fuentes de soda que son frecuentadas por al menos dos 
--                bebedores que le gustan al menos 3 de las bebidas que sirven.
-- LISTO
-- ################################################################################

SELECT
    q0."codfs",
    fs.nombrefs
FROM (
    SELECT
        g.ci AS "ci",
        COUNT(DISTINCT v.codbeb) AS "codbeb",
        v.codfs AS "codfs"
    FROM gusta g
    JOIN vende v ON g.codbeb = v.codbeb
    GROUP BY
        g.ci,
        v.codfs
    HAVING
        COUNT(DISTINCT v.codbeb) >= 3
    ORDER BY
        g.ci
) q0
JOIN frecuenta f ON f.ci = q0."ci" AND f.codfs = q0."codfs"
JOIN fuente_soda fs ON f.codfs = fs.codfs
GROUP BY
    q0."codfs",
    fs.nombrefs
HAVING
    COUNT(DISTINCT q0."ci") >= 2;