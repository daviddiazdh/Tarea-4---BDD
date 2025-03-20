-- 1. Bebedores que no les gusta la malta
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
                WHERE nombrebeb = 'Centauro') s
        JOIN gusta g ON g.codbeb = s.codbeb
        JOIN bebedor b ON g.ci = b.ci 
    ) 
    WHERE beb.ci = "cen_cedula" AND beb.nombre = "cen_nombre"
);
-- Comentarios: Listo

-- 2. Las fuentes de soda que no son frecuentadas por Luis Pérez
SELECT
    *
FROM fuente_soda
WHERE codfs NOT IN (
    SELECT 
        fs.codfs
    FROM bebedor b
    JOIN frecuenta f ON f.ci = b.ci
    JOIN fuente_soda fs ON f.codfs = fs.codfs 
    WHERE b.nombre = 'José Reverte'
);

-- Comentarios: Listo

-- 3. Bebedores que les gusta al menos una bebida y que frecuentan al menos una fuente
SELECT 
    b.nombre,
    b.ci
FROM bebedor b
JOIN frecuenta fs ON fs.ci = b.ci
JOIN gusta g ON g.ci = b.ci
GROUP BY b.nombre, b.ci;

-- Comentarios: Listo

-- 4. Para cada bebedor, las bebidas que no le gustan
SELECT 
    *
FROM bebedor b
CROSS JOIN bebida beb
WHERE (b.ci, b.nombre, beb.codbeb, beb.nombrebeb) NOT IN (
    SELECT 
        b.ci,
        b.nombre,
        beb.codbeb,
        beb.nombrebeb
    FROM bebedor b
    JOIN gusta g ON g.ci = b.ci
    JOIN bebida beb ON g.codbeb = beb.codbeb
);
-- Comentarios: Listo

-- 6. Los bebedores que no les gustan las bebidas que le gustan a Luis Pérez
-- SELECT 
--     b.ci,
--     beb.codbeb
-- FROM bebedor b
-- CROSS JOIN bebida beb
-- WHERE (b.ci, beb.codbeb) NOT IN (
--     SELECT
--     *
--     FROM gusta
-- );

-- 8. Los bebedores que frecuentan algunas de las fuentes de soda que frecuenta Luis Pérez
SELECT
    f.ci
FROM (  SELECT
            f.codfs AS "codfs"
        FROM bebedor b
        JOIN frecuenta f ON f.ci = b.ci
        WHERE b.nombre = 'David Noches'
        ) q0
JOIN frecuenta f ON q0."codfs" = f.codfs;

-- Comentarios: 
-- Devuelve duplicados 
-- Devuelve solo la cedula, falta el nombre

-- 10. Los bebedores que frecuentan alguna fuente de soda que sirve al menos una bebida que les gusta
SELECT
    q0."ci",
    q0."nombre"
FROM (
    SELECT
        b.ci AS "ci",
        b.nombre AS "nombre",
        f.codFS AS "codFS"
    FROM bebedor b
    JOIN frecuenta f ON f.ci = b.ci
) q0
JOIN (
    SELECT
        b.ci AS "ci",
        b.nombre AS "nombre",
        g.codbeb AS "codbeb"
    FROM bebedor b
    JOIN gusta g ON g.ci = b.ci
) q1 ON q1."ci" = q0."ci"
JOIN vende v ON v.codbeb = q1."codbeb" AND v.codFS= q0."codFS"
GROUP BY q0."ci", q0."nombre";

-- Comentarios: Listo.

-- 14. 
SELECT 
    q2."ci",
    b.nombre
FROM(
    SELECT
        q0."ci" AS "ci",
        q0."codbeb" AS "codbeb",
        q1."codfs" AS "codfs"
    FROM (
        SELECT
            b.ci AS "ci",
            beb.codbeb AS "codbeb"
        FROM bebedor b
        CROSS JOIN bebida beb
        WHERE (b.ci, beb.codbeb) NOT IN (
            SELECT 
                *
            FROM gusta
        )
    ) q0 
    JOIN (
        SELECT
            b.ci AS "ci",
            fs.codFS AS "codfs"
        FROM bebedor b
        CROSS JOIN fuente_soda fs
        WHERE (b.ci, fs.codFS) NOT IN (
            SELECT 
                * 
            FROM frecuenta
        )
    ) q1 ON q0."ci" = q1."ci"
) q2
JOIN vende v ON v.codfs = q2."codfs"  AND v.codbeb = q2."codbeb"
JOIN bebedor b ON b.ci = q2."ci";

-- Comentarios:
-- Tiene duplicados.
-- En la query Q6 se restringe a Nombre, pero las tablas no contienen nombre

-- 15. Los bebedores que frecuentan las fuentes de soda que sirven las bebidas que le gustan a Luis Pérez
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
-- Comentarios: 
-- Listo.

-- 17. Los bebedores a quienes les gustan únicamente las bebidas que sirven en las fuentes de soda que frecuentan
SELECT
    *
FROM bebedor bb
WHERE (bb.ci,bb.nombre) NOT IN(
    SELECT
        bb.ci,
        bb.nombre
        FROM gusta g
        JOIN bebedor bb ON g.ci = bb.ci
        WHERE (g.ci,g.codbeb) NOT IN(
            SELECT
                ci,
                codbeb
            FROM frecuenta fr
            JOIN vende vd ON fr.codfs = vd.codfs
        )
        GROUP BY
            bb.ci,
            bb.nombre
);

-- 19. Las fuentes de soda que son frecuentadas por las personas a quienes les gusta la malta
SELECT 
    f.codfs,
    fs.nombrefs,
FROM bebida b
JOIN gusta g ON g.codbeb = b.codbeb
JOIN frecuenta f ON f.ci = g.ci
JOIN fuente_soda fs ON fs.codfs = f.codfs
WHERE b.nombrebeb = 'Lechita';

-- Comentarios: 
-- Listo.

-- 26. Las bebidas que se venden en al menos dos de las fuentes de sodas frecuentadas por Luis Pérez
SELECT 
    b.codbeb,
    b.nombrebeb
FROM(
    SELECT
        v.codbeb AS "codbeb",
        COUNT(f.codfs) AS "Countcodfs"
    FROM bebedor b
    JOIN frecuenta f ON b.ci = f.ci
    JOIN vende v ON v.codfs = f.codfs
    WHERE b.nombre='Ian Gracias'
    GROUP BY v.codbeb
    HAVING COUNT(f.codfs) >= 2
) q0
JOIN bebida b ON b.codbeb = q0."codbeb";

-- Comentarios: 
-- Listo.

-- 36. La bebida más cara en las fuentes de soda que no venden al menos una de las bebidas que le gusta a Luis Pérez
SELECT
    b.codbeb,
    b.nombrebeb
FROM bebida b
JOIN(
    SELECT
        v.codbeb AS "codbeb",
        v.precio AS "precio"
    FROM fuente_soda fs
    JOIN vende v ON fs.codfs = v.codfs
    WHERE fs.codfs NOT IN (
        SELECT DISTINCT 
            v.codfs
        FROM vende v
        WHERE NOT EXISTS (
            SELECT 
                q2."codbeb"
            FROM (
                SELECT
                    g.codbeb AS "codbeb"
                FROM bebedor b
                JOIN gusta g ON g.ci = b.ci
                WHERE b.nombre = 'Mauricio Chambachán'
            ) q2
            WHERE NOT EXISTS (
                SELECT 
                    1 
                FROM vende v_inner
                WHERE v_inner.codfs = v.codfs AND v_inner.codbeb = q2.codbeb
            )
        )
    )
    ORDER BY v.precio DESC
    LIMIT 1
) q3 ON q3."codbeb" = b.codbeb;

-- Comentarios:
-- Listo

-- 31. La fuente de soda que sirve malta y es la más frecuentada
SELECT 
    fs.codfs,
    fs.nombrefs
FROM fuente_soda fs
JOIN (
    SELECT
        COUNT(f.ci) AS "Countci",
        f.codfs AS "codfs"
    FROM bebida b
    JOIN vende v ON v.codbeb = b.codbeb
    JOIN frecuenta f ON f.codfs = v.codfs
    WHERE b.nombrebeb = 'Guepardex'
    GROUP BY f.codfs
    ORDER BY COUNT(f.ci) DESC
    LIMIT 1
) q0 ON q0."codfs" = fs.codfs;

-- Comentarios: Listo

-- 48. Las fuentes de soda que sirven la(s) bebida(s) que más gusta(n).

SELECT DISTINCT 
    v.codfs,
    fs.nombrefs
FROM vende v
JOIN fuente_soda fs ON fs.codfs = v.codfs
WHERE NOT EXISTS (
    SELECT 
        q2."codbeb" 
    FROM (
        SELECT
            g.codbeb AS "codbeb",
            COUNT(g.ci) AS "Countci"
        FROM bebida b
        JOIN gusta g ON g.codbeb = b.codbeb
        GROUP BY g.codbeb
        ORDER BY COUNT(g.ci) DESC
        LIMIT 1
    ) q2
    WHERE NOT EXISTS (
        SELECT 
            1 
        FROM vende v_inner
        WHERE v_inner.codfs = v.codfs AND v_inner.codbeb = q2.codbeb
    )
);

-- Comentarios: 
-- Listo