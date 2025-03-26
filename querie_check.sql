-- 34. Las fuentes de soda que venden a menor precio la malta.
SELECT 
    v.codfs,
    MIN(v.precio) AS precio_minimo,
    fs.nombrefs
FROM bebida beb
JOIN vende v ON beb.codbeb = v.codbeb
JOIN fuente_soda fs ON v.codfs = fs.codfs
WHERE beb.nombrebeb = 'Centauro'
GROUP BY v.codfs, fs.nombrefs
HAVING MIN(v.precio) = (
    SELECT 
        MIN(precio) 
    FROM vende v2 
    JOIN bebida b2 ON v2.codbeb = b2.codbeb 
    WHERE b2.nombrebeb = 'Centauro'
);


-- Q0 ← σ(NombreBeb=’Malta’)(BEBIDA)
-- Q1 ← Q0 ▷◁∗ VENDE
-- Q2 ← Q1 ▷◁∗ FRECUENTA SODA
-- Q3 ← IMIN precio(Q2)