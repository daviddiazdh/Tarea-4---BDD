SET client_encoding TO UTF8;

-- Se fuerza a que los resultados de toda query se presenten en tablas
\pset tuples_only false

DROP TABLE IF EXISTS fuente_soda CASCADE;
DROP TABLE IF EXISTS bebida CASCADE;
DROP TABLE IF EXISTS bebedor CASCADE;
DROP TABLE IF EXISTS gusta CASCADE;
DROP TABLE IF EXISTS frecuenta CASCADE;
DROP TABLE IF EXISTS vende CASCADE;

CREATE TABLE fuente_soda(
    codfs SERIAL PRIMARY KEY,
    nombrefs VARCHAR(100) 
);

CREATE TABLE bebida(
    codbeb SERIAL PRIMARY KEY,
    nombrebeb VARCHAR(100) 
);

CREATE TABLE bebedor(
    ci INT PRIMARY KEY,
    nombre VARCHAR(100) 
);

CREATE TABLE gusta(
    ci INT,
    codbeb INT,
    FOREIGN KEY (ci) REFERENCES bebedor(ci),
    FOREIGN KEY (codbeb) REFERENCES bebida(codbeb) 
);

CREATE TABLE frecuenta(
    ci INT,
    codfs INT,
    FOREIGN KEY (ci) REFERENCES bebedor(ci),
    FOREIGN KEY (codfs) REFERENCES fuente_soda(codfs) 
);

CREATE TABLE vende(
    codfs INT,
    codbeb INT,
    FOREIGN KEY (codfs) REFERENCES fuente_soda(codfs),
    FOREIGN KEY (codbeb) REFERENCES bebida(codbeb)
);
