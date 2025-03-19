-- SELECT
--     *
-- FROM vende;

-- SELECT
--     g.codbeb AS "codbeb"
-- FROM bebedor b
-- JOIN gusta g ON g.ci = b.ci
-- WHERE nombre = 'José Reverte';



SELECT DISTINCT 
    f.ci,
    b.nombre
FROM vende v
JOIN frecuenta f ON v.codfs = f.codfs
JOIN bebedor b ON b.ci = f.ci
WHERE NOT EXISTS (
    SELECT 
        q0."codbeb"
    FROM (
        SELECT
            g.codbeb AS "codbeb"
        FROM bebedor b
        JOIN gusta g ON g.ci = b.ci
        WHERE nombre = 'José Reverte'
    ) q0
    WHERE NOT EXISTS (
        SELECT 
            1 
        FROM vende v_inner
        WHERE v_inner.codfs = v.codfs AND v_inner.codbeb = q0."codbeb"
    )
);
