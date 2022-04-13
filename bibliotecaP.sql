-- CREACIÓN DATABASE

CREATE DATABASE biblioteca;

\c biblioteca;

-- CREACION DE TABLAS
CREATE TABLE comuna (
    id SERIAL PRIMARY KEY,
    comuna VARCHAR(50)
);

CREATE TABLE socio (
    rut VARCHAR(50) PRIMARY KEY,
    id_comuna INT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(150),
    telefono VARCHAR(15),
    FOREIGN KEY (id_comuna) REFERENCES comuna(id)
);



CREATE TABLE autor (
    cod_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(50),
    apellido_autor VARCHAR(50),
    nacimiento DATE,
    muerte DATE
);

CREATE TABLE libro (
    isbn VARCHAR (15) PRIMARY KEY,
    titulo VARCHAR(100),
    pagina INT,
    dia_prestamo INT
);

CREATE TABLE info_autor (
    isbn VARCHAR(15),
    cod_autor INT,
    tipo_autor VARCHAR(25),
    FOREIGN KEY (cod_autor) REFERENCES autor (cod_autor),
    FOREIGN KEY (isbn) REFERENCES libro (isbn),
    PRIMARY KEY (cod_autor, isbn)
);



CREATE TABLE prestamo (
    id SERIAL PRIMARY KEY,
    rut VARCHAR(50),
    isbn VARCHAR (15),
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (rut) REFERENCES socio (rut),
    FOREIGN KEY (isbn) REFERENCES libro (isbn)
);


-- DATOS TABLA COMUNA
INSERT INTO comuna (comuna) VALUES ('SANTIAGO');


-- DATOS TABLA SOCIO
INSERT INTO socio (rut, id_comuna, nombre, apellido, direccion, telefono) VALUES ('1111111-1', 1, 'JUAN', 'SOTO', 'AVENIDA 1','911111111');
INSERT INTO socio (rut, id_comuna, nombre, apellido, direccion, telefono) VALUES ('2222222-2', 1, 'ANA', 'PEREZ', 'PASAJE 2', '922222222');
INSERT INTO socio (rut, id_comuna, nombre, apellido, direccion, telefono) VALUES ('3333333-3', 1, 'SANDRA', 'AGUILAR', 'AVENIDA 2', '933333333');
INSERT INTO socio (rut, id_comuna, nombre, apellido, direccion, telefono) VALUES ('4444444-4', 1, 'ESTEBAN', 'JEREZ', 'AVENIDA 3', '944444444');
INSERT INTO socio (rut, id_comuna, nombre, apellido, direccion, telefono) VALUES ('5555555-5', 1, 'SILVANA', 'MUÑOZ', 'PASAJE 3','955555555');


-- DATOS TABLA AUTOR
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, nacimiento, muerte) VALUES (1, 'ANDRES', 'ULLOA', '1982-01-01', null);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, nacimiento, muerte) VALUES (2, 'SERGIO', 'MARDONES', '1950-01-01', '2012-01-01');
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, nacimiento, muerte) VALUES (3, 'JOSE', 'SALGADO', '1968-01-01', '2020-01-01');
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, nacimiento, muerte) VALUES (4, 'ANA', 'SALGADO', '1972-01-01', null);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, nacimiento, muerte) VALUES (5, 'MARTIN', 'PORTA', '1976-01-01', null);


-- DATOS TABLA LIBRO
INSERT INTO libro (isbn, titulo, pagina, dia_prestamo) VALUES ('111-1111111-111', 'CUENTOS DE TERROR', 344, 7);
INSERT INTO libro (isbn, titulo, pagina, dia_prestamo) VALUES ('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167, 7);
INSERT INTO libro (isbn, titulo, pagina, dia_prestamo) VALUES ('333-3333333-333', 'HISTORIA DE ASIA', 511, 14);
INSERT INTO libro (isbn, titulo, pagina, dia_prestamo) VALUES ('444-4444444-444', 'MANUAL DE MECÁNICA', 298, 14);

-- DATOS TABLA INFO_AUTOR
INSERT INTO info_autor (isbn, cod_autor, tipo_autor) VALUES ('111-1111111-111', 3, 'PRINCIPAL');
INSERT INTO info_autor (isbn, cod_autor, tipo_autor) VALUES ('111-1111111-111', 4, 'COAUTOR');
INSERT INTO info_autor (isbn, cod_autor, tipo_autor) VALUES ('222-2222222-222', 1, 'PRINCIPAL');
INSERT INTO info_autor (isbn, cod_autor, tipo_autor) VALUES ('333-3333333-333', 2, 'PRINCIPAL');
INSERT INTO info_autor (isbn, cod_autor, tipo_autor) VALUES ('444-4444444-444', 5, 'PRINCIPAL');


-- DATOS TABLA PRESTAMO
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('1111111-1', '111-1111111-111', '20-01-2020', '27-01-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('5555555-5', '222-2222222-222', '20-01-2020', '30-01-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('3333333-3', '333-3333333-333', '22-01-2020', '30-01-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('4444444-4', '444-4444444-444', '23-01-2020', '30-01-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('2222222-2', '111-1111111-111', '27-01-2020', '04-02-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('1111111-1', '444-4444444-444', '31-01-2020', '12-02-2020');
INSERT INTO prestamo (rut, isbn, fecha_prestamo, fecha_devolucion) VALUES ('3333333-3', '222-2222222-222', '31-01-2020', '12-02-2020');


-- CONSULTA LIBROS MENOS DE 300 PAG
SELECT titulo, pagina
FROM libro
WHERE pagina < 300;


-- CONSULTA AUTORES NACIDOS DESPUÉS DEL 01-01-1970
SELECT nombre_autor, apellido_autor
FROM autor
WHERE nacimiento > '01-01-1970';

-- CONSULTA CUAL ES EL LIBRO MAS SOLICITADO
SELECT COUNT(p.isbn), l.titulo
FROM libro l
JOIN prestamo p
ON p.isbn = l.isbn
GROUP BY p.isbn, l.titulo
ORDER BY COUNT(p.isbn) DESC
LIMIT 1;

-- Se utilizó LIMITE de 1 para traer el libro más solicitado y no los libros mas solicitados

-- CONSULTA DE PAGO DE ATRASO POR 7 DIAS

SELECT ((p.fecha_devolucion - p.fecha_prestamo) - 7) * 100 AS deuda, l.titulo, s.nombre, s.apellido
FROM prestamo p
JOIN libro l
ON p.isbn = l.isbn
JOIN socio s
ON s.rut = p.rut
WHERE l.dia_prestamo = 7 AND (p.fecha_devolucion - p.fecha_prestamo) > 7
ORDER BY deuda DESC;


((p.fecha_devolucion - p.fecha_prestamo) - 7) * 100
-- LAS CONDICIONES SERIAN CUANDO LOS DIAS DE PRESTAMO SON IGUALES A 7 Y LA FECHA DE DEVOLUCION MENOS LA FECHA DE PRESTAMO ES MAYOR A 7
