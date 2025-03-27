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
                WHERE nombrebeb = 'Malta') s
        JOIN gusta g ON g.codbeb = s.codbeb
        JOIN bebedor b ON g.ci = b.ci 
    ) 
    WHERE beb.ci = "cen_cedula" AND beb.nombre = "cen_nombre"
);

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
    WHERE b.nombre = 'Luis Pérez'
);

-- 3. Bebedores que les gusta al menos una bebida y que frecuentan al menos una fuente
SELECT 
    b.nombre,
    b.ci
FROM bebedor b
JOIN frecuenta fs ON fs.ci = b.ci
JOIN gusta g ON g.ci = b.ci
GROUP BY b.nombre, b.ci;

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

-- 6. Los bebedores que no les gustan las bebidas que le gustan a Luis Pérez
SELECT DISTINCT 
    q1."ci",
    beb.nombre
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
) q1
JOIN bebedor beb ON beb.ci = q1."ci"
WHERE NOT EXISTS (
    SELECT 
        q2."codbeb"
    FROM (
        SELECT 
            g.codbeb AS "codbeb"
        FROM bebedor b
        JOIN gusta g ON g.ci = b.ci
        WHERE b.nombre='Yisus Cries'
    ) q2
    WHERE NOT EXISTS (
        SELECT 
            1 
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
        ) q1_inner
        WHERE q1_inner."ci" = q1."ci" AND q1_inner."codbeb" = q2."codbeb"
    )
);

-- 7. Los bebedores que frecuentan las fuentes de soda que frecuenta Luis Pérez.
SELECT DISTINCT
    f.ci, 
    b.nombre
FROM(
    SELECT
        f.codfs AS "codfs",
        fs.nombrefs AS "nombrefs"
    FROM bebedor b
    JOIN frecuenta f ON f.ci = b.ci
    JOIN fuente_soda fs ON fs.codfs = f.codfs
    WHERE b.nombre = 'Luis Pérez'
) q0
JOIN frecuenta f ON q0."codfs" = f.codfs
JOIN bebedor b ON b.ci = f.ci; 

-- 8. Los bebedores que frecuentan algunas de las fuentes de soda que frecuenta Luis Pérez
SELECT DISTINCT
    f.ci,
    b.nombre
FROM (  SELECT
            f.codfs AS "codfs"
        FROM bebedor b
        JOIN frecuenta f ON f.ci = b.ci
        WHERE b.nombre = 'Luis Pérez'
        ) q0
JOIN frecuenta f ON q0."codfs" = f.codfs
JOIN bebedor b ON b.ci = f.ci;

-- 9. Los bebedores que frecuentan sólo las fuentes de soda que frecuenta Luis Pérez
SELECT DISTINCT
    f.ci,
    b.nombre
FROM frecuenta f
JOIN bebedor b ON b.ci = f.ci
WHERE f.ci NOT IN(

    SELECT DISTINCT
        f.ci
    FROM frecuenta f
    WHERE (f.ci, f.codfs) NOT IN(
        SELECT
            f.ci,
            f.codfs
        FROM frecuenta f
        JOIN( 
            SELECT
                f.codfs AS "codfs"
            FROM bebedor b
            JOIN frecuenta f ON f.ci = b.ci
            WHERE b.nombre='Ian Gracias'
        ) q0 ON q0."codfs" = f.codfs
    )

);

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

-- 11. Los bebedores que frecuentan fuentes de soda que sirven al menos todas las bebidas que les gustan.
SELECT 
    q0."ci",
    b.nombre
FROM (
    SELECT 
        g.ci AS "ci",
        COUNT(g.codbeb) AS "bebidasQueVende",
        f.codfs AS "codfs"
    FROM gusta g
    JOIN frecuenta f ON g.ci = f.ci
    JOIN vende v ON v.codfs = f.codfs AND g.codbeb = v.codbeb
    GROUP BY 
        g.ci, f.codfs
    ORDER BY g.ci
) q0
JOIN bebedor b ON b.ci = q0."ci"
JOIN (

    SELECT 
        g.ci AS "ci",
        COUNT(g.codbeb) AS "bebidasQueGusta"
    FROM gusta g
    GROUP BY
        g.ci 
    ORDER BY g.ci

) q1 ON q1."ci" = q0."ci"
WHERE q1."bebidasQueGusta" = q0."bebidasQueVende"
;

-- 12. Los bebedores que sólo frecuentan las fuentes de sodas que sirven al menos las bebidas que les gustan.

SELECT 
    q0."ci",
    b.nombre
FROM (
    SELECT
        f.ci AS "ci",
        COUNT(f.codfs) AS "CountCodFR"
    FROM frecuenta f
    GROUP BY f.ci
) q0
JOIN (
    SELECT 
        q0."ci",
        COUNT(q1."codfs") AS "CountCodFS"
    FROM (
        SELECT
            g.ci AS "ci",
            COUNT(g.codbeb) AS "CodBebGusta"
        FROM gusta g
        GROUP BY g.ci
    ) q0
    JOIN (
        SELECT
            g.ci AS "ci",
            f.codfs AS "codfs",
            COUNT(g.codbeb) AS "CountCodBeb"
        FROM gusta g
        JOIN frecuenta f ON g.ci = f.ci
        GROUP BY g.ci, f.codfs
    ) q1 ON q0."ci" = q1."ci"
    WHERE q0."CodBebGusta" = q1."CountCodBeb"
    GROUP BY q0."ci"
) q1 ON q1."ci" = q0."ci"
JOIN bebedor b ON b.ci = q0."ci"
WHERE q0."CountCodFR" = q1."CountCodFS";


-- 14. Los bebedores que no frecuentan las fuentes de soda que sirven al menos una de las bebidas que no les gustan.
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
        WHERE nombre = 'Luis Pérez'
    ) q0
    WHERE NOT EXISTS (
        SELECT 
            1 
        FROM vende v_inner
        WHERE v_inner.codfs = v.codfs AND v_inner.codbeb = q0."codbeb"
    )
);

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
WHERE b.nombrebeb = 'Malta';

-- 20. Las fuentes de soda que no venden al menos una de las bebidas 
--     que venden en las fuentes de soda frecuentadas por Luis Pérez.
SELECT 
    fs.codfs,
    fs.nombrefs
FROM fuente_soda fs 
WHERE fs.codfs NOT IN (

    SELECT DISTINCT 
        v.codfs
    FROM vende v
    WHERE NOT EXISTS (
        SELECT 
            q2."codbeb" 
        FROM (
            SELECT DISTINCT
                beb.codbeb AS "codbeb"
            FROM bebedor b
            JOIN frecuenta f ON f.ci = b.ci
            JOIN vende v ON v.codfs = f.codfs
            JOIN bebida beb ON beb.codbeb = v.codbeb
            WHERE b.nombre = 'José Reverte'
        ) q2
        WHERE NOT EXISTS (
            SELECT 
                1 
            FROM vende v_inner 
            WHERE v_inner.codfs = v.codfs AND v_inner.codbeb = q2."codbeb"
        )
    )
);

-- 21. Los bebedores a quienes no les gustan al menos dos de las bebidas que no les gustan a Luis Pérez.

SELECT
    b.ci,
    b.nombre
FROM bebedor b
JOIN (

    SELECT 
        g.ci AS "ci",
        COUNT(g.codbeb) AS "codbeb"
    FROM bebida beb
    JOIN gusta g On g.codbeb = beb.codbeb
    WHERE beb.codbeb NOT IN (
        SELECT
            g.codbeb
        FROM bebedor b
        JOIN gusta g ON g.ci = b.ci
        WHERE b.nombre = 'Luis Pérez'
    )
    GROUP BY g.ci
    HAVING COUNT(g.codbeb)>=2

) q0 ON q0."ci" = b.ci;

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
    WHERE b.nombre='Luis Pérez'
    GROUP BY v.codbeb
    HAVING COUNT(f.codfs) >= 2
) q0
JOIN bebida b ON b.codbeb = q0."codbeb";

-- 27. Las bebidas que se sirven en las fuentes de soda que son frecuentadas por las personas que les gusta la malta.
SELECT DISTINCT
    beb.codbeb,
    beb.nombrebeb
FROM (
    SELECT
        *
    FROM bebedor beb
    WHERE EXISTS(
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

-- 28. Las bebidas que se sirven en las fuentes de soda que son frecuentadas por las personas que no les gusta la malta.
SELECT DISTINCT
    beb.codbeb,
    beb.nombrebeb
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

-- 29. Las fuentes de soda que son frecuentadas por las personas que les gusta la malta y que frecuentan la fuente de soda "La Montaña".
SELECT DISTINCT
    f.codfs,
    fs.nombrefs
FROM (

    SELECT DISTINCT
        g.ci AS "ci"
    FROM bebida beb
    JOIN gusta g ON g.codbeb = beb.codbeb
    WHERE beb.nombrebeb = 'Malta'

) q0
JOIN frecuenta f ON f.ci = q0."ci"
JOIN fuente_soda fs ON fs.codfs = f.codfs
WHERE q0."ci" IN (

    SELECT DISTINCT
        f.ci AS "ci"
    FROM fuente_soda fs
    JOIN frecuenta f ON f.codfs = fs.codfs 
    WHERE fs.nombrefs = 'La Montaña'

);

-- 30. La bebida más servida entre las fuentes de soda que frecuenta Luis Pérez
SELECT 
    beb.codbeb,
    beb.nombrebeb
FROM (
    SELECT DISTINCT
        COUNT(DISTINCT f.codfs) AS "Countcodfs",
        v.codbeb AS "codbeb"
    FROM bebedor b
    JOIN frecuenta f ON f.ci = b.ci
    JOIN vende v ON v.codfs = f.codfs
    WHERE b.nombre='Luis Pérez'
    GROUP BY 
        v.codbeb
) q1
JOIN bebida beb ON beb.codbeb = q1."codbeb"
WHERE q1."Countcodfs" IN (
    SELECT 
        MAX(q0."Countcodfs")
    FROM (
        SELECT DISTINCT
            COUNT(DISTINCT f.codfs) AS "Countcodfs",
            v.codbeb AS "codbeb"
        FROM bebedor b
        JOIN frecuenta f ON f.ci = b.ci
        JOIN vende v ON v.codfs = f.codfs
        WHERE b.nombre='Luis Pérez'
        GROUP BY 
            v.codbeb
    ) q0
);

-- 32. El bebedor a quien más bebidas le gustan y más fuentes de soda frecuenta
SELECT
    q0."ci",
    b.nombre
FROM (

    SELECT 
        q1."ci" AS "ci"
    FROM (
        SELECT
            g.ci AS "ci",
            COUNT(g.codbeb) AS "Countcodbeb"
        FROM gusta g
        GROUP BY
            g.ci
    ) q1 
    WHERE q1."Countcodbeb" IN(
        SELECT
            MAX(q0."Countcodbeb")
        FROM(
            SELECT
                g.ci AS "ci",
                COUNT(g.codbeb) AS "Countcodbeb"
            FROM gusta g
            GROUP BY
                g.ci
        ) q0
    )
) q0
JOIN bebedor b ON b.ci = q0."ci"
WHERE q0."ci" IN (

    SELECT
        q1."ci"
    FROM (
        SELECT
            f.ci AS "ci",
            COUNT(f.codfs) AS "Countcodfs"
        FROM frecuenta f
        GROUP BY
            f.ci
    ) q1 
    WHERE q1."Countcodfs" IN(
        SELECT
            MAX(q0."Countcodfs")
        FROM (
            SELECT
                f.ci AS "ci",
                COUNT(f.codfs) AS "Countcodfs"
            FROM frecuenta f
            GROUP BY
                f.ci
        ) q0 
    )
);

-- 34. Las fuentes de soda que venden a menor precio la malta.
SELECT 
    v.codfs,
    MIN(v.precio) AS precio_minimo,
    fs.nombrefs
FROM bebida beb
JOIN vende v ON beb.codbeb = v.codbeb
JOIN fuente_soda fs ON v.codfs = fs.codfs
WHERE beb.nombrebeb = 'Malta'
GROUP BY v.codfs, fs.nombrefs
HAVING MIN(v.precio) = (
    SELECT 
        MIN(precio) 
    FROM vende v2 
    JOIN bebida b2 ON v2.codbeb = b2.codbeb 
    WHERE b2.nombrebeb = 'Malta'
);
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
                WHERE b.nombre = 'Luis Pérez'
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
    WHERE b.nombrebeb = 'Malta'
    GROUP BY f.codfs
    ORDER BY COUNT(f.ci) DESC
    LIMIT 1
) q0 ON q0."codfs" = fs.codfs;

-- 42. Las fuentes de soda que son frecuentadas por al menos dos  bebedores que le gustan al menos 3 de las bebidas que sirven.
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

-- 44. Las fuentes de soda que no sirven bebidas que no le gustan a al menos uno de los bebedores que la frecuentan.
SELECT 
    q0."codfs",
    fs.nombrefs,
    q0."ci"
FROM (

    SELECT
        fs.codfs AS "codfs",
        COUNT(v.codbeb) AS "CountCodBeb",
        f.ci AS "ci" 
    FROM fuente_soda fs
    JOIN vende v ON v.codfs = fs.codfs
    JOIN frecuenta f ON f.codfs = fs.codfs
    JOIN gusta g ON g.ci = f.ci AND g.codbeb = v.codbeb
    GROUP BY fs.codfs, f.ci
    ORDER BY fs.nombrefs

) q0
JOIN fuente_soda fs ON fs.codfs = q0."codfs"
JOIN (

    SELECT
        fs.codfs AS "codfs",
        COUNT(v.codbeb) AS "CountCodBeb"
    FROM fuente_soda fs
    JOIN vende v ON v.codfs = fs.codfs
    GROUP BY fs.codfs
    ORDER BY fs.codfs
) q1 ON q0."codfs" = q1."codfs" AND q0."CountCodBeb" = q1."CountCodBeb"
;

-- 46. Las fuentes de soda que son frecuentadas por el (los) bebedores que le(s) gustan el mayor número de bebidas.
SELECT DISTINCT
    f.codfs,
    fs.nombrefs
FROM (
    SELECT
        g.ci AS "ci",
        COUNT(g.codbeb) AS "Countcodbeb"
    FROM gusta g
    GROUP BY g.ci
) q0 
JOIN frecuenta f ON q0."ci" = f.ci
JOIN fuente_soda fs ON fs.codfs = f.codfs
WHERE q0."Countcodbeb" IN (
    SELECT 
        MAX(q0."Countcodbeb")
    FROM (
        SELECT
            g.ci AS "ci",
            COUNT(g.codbeb) AS "Countcodbeb"
        FROM gusta g
        GROUP BY g.ci
    ) q0
);

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