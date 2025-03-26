-- 22. Los bebedores a quienes no les gusta bebida alguna pero frecuentan al menos una fuente de soda.
SELECT
    b.ci,
    b.nombre
FROM bebedor b
JOIN frecuenta fr ON b.ci = fr.ci
WHERE b.ci NOT IN (
    SELECT 
        b.ci
    FROM bebedor b
    JOIN gusta g ON b.ci = g.ci
);









-- SELECT 
--     *
-- FROM bebedor b
-- WHERE b.ci NOT IN (
--     SELECT DISTINCT
--         fr.ci
--     FROM frecuenta fr
--     JOIN vende v ON v.codfs = fr.codfs
--     WHERE (fr.ci, v.codbeb) NOT IN(
--         SELECT
--             *
--         FROM gusta
--     )
-- );