-- 13. Los bebedores que únicamente frecuentan las fuentes de soda que únicamente sirven algunas de las bebidas que les gustan.
SELECT 
    *
FROM bebedor b
WHERE b.ci NOT IN (
    SELECT DISTINCT
        fr.ci
    FROM frecuenta fr
    JOIN vende v ON v.codfs = fr.codfs
    WHERE (fr.ci, v.codbeb) NOT IN(
        SELECT
            *
        FROM gusta
    )
);