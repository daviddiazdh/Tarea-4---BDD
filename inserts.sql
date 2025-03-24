INSERT INTO bebedor(ci, nombre) VALUES
(20000001, 'David Nochez'),
(25345637, 'Yisus Cries'),
(12557814, 'Alan Largote'),
(14568902, 'Ian Gracias'),
(20100198, 'José Reverte'),
(20102233, 'Mauricio Chambachán'),
(12881654, 'Samuel LSD'),
(12001002, 'Yriarte Discreto'),
(12001003, 'DJ Coronado'),
(12001523, 'Willy Palma'),
(12001524, 'Juan Alberto');


INSERT INTO bebida(nombrebeb, codbeb) VALUES
('Guepardex', 1),
('Mojito', 2),
('Speed', 3),
('Prime', 4),
('Duff', 5),
('Lechita', 6),
('Café', 7),
('Centauro', 8),
('Reggaeton', 9),
('Técito ZZZ', 10),
('Jugo de guayaba', 11);


INSERT INTO fuente_soda(nombrefs, codfs) VALUES
('Amper', 1),
('Mister Kind', 2),
('Bamboo', 3),
('Canchas', 4),
('Comedor', 5),
('Árbol solitario', 6),
('MAC', 7),
('MYS', 8),
('Aulas', 9);


INSERT INTO gusta(ci, codbeb) VALUES
(20000001, 1),
(20000001, 3),
(20000001, 7),
(20000001, 8),
(25345637, 8),
(25345637, 7),
(25345637, 4),
(12557814, 5),
(12557814, 8),
(12557814, 2),
(12557814, 3),
(14568902, 9),
(14568902, 8),
(14568902, 3),
(14568902, 11),
(20100198, 3),
(20100198, 8),
(20100198, 1),
(20102233, 5),
(20102233, 8),
(20102233, 7),
(20102233, 1),
(12881654, 6),
(12881654, 1),
(12001002, 7),
(12001002, 8),
(12001003, 10),
(12001523, 5),
(12001523, 2);


INSERT INTO frecuenta(ci, codfs) VALUES
(20000001, 1),
(20000001, 2),
(25345637, 1),
(25345637, 4),
(25345637, 5),
(25345637, 7),
(12557814, 7),
(12557814, 1),
(14568902, 7),
(14568902, 1),
(20100198, 1),
(20100198, 7),
(20100198, 3),
(20102233, 7),
(20102233, 4),
(20102233, 1),
(12881654, 6),
(12001002, 9),
(12001003, 8),
(12001003, 5),
(12001523, 8);


INSERT INTO vende(codfs, codbeb, precio) VALUES
(1, 8, 2),
(1, 9, 3),
(1, 7, 5),
(1, 1, 1),
(1, 3, 2),
(2, 2, 3),
(2, 3, 50),
(2, 4, 60),
(2, 9, 100),
(3, 8, 3),
(3, 7, 2),
(4, 9, 10),
(4, 4, 2),
(4, 1, 3),
(5, 1, 1),
(5, 4, 1),
(6, 6, 2), 
(7, 4, 3),
(7, 1, 2),
(8, 10, 1),
(8, 1, 2),
(9, 7, 3);