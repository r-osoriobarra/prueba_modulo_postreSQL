--Prueba - Biblioteca
DROP DATABASE biblioteca;

--Parte 2

--1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas
--definidas y sus atributos.

--Crear la base de datos
CREATE DATABASE biblioteca;

--Conectarse a la base de datos
\c biblioteca

--Crear entidades del modelo

CREATE TABLE addresses(
    id SERIAL PRIMARY KEY,
    street VARCHAR (20),
    city VARCHAR (15)
);

CREATE TABLE members(
    rut VARCHAR (10) PRIMARY KEY,
    first_name VARCHAR (15),
    last_name VARCHAR (20),
    addresses_id INT REFERENCES addresses(id),
    phone_number INT
);

CREATE TABLE books(
    isbn VARCHAR (15) PRIMARY KEY,
    title VARCHAR (30),
    number_of_pages INT
);

CREATE TABLE authors(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR (15),
    last_name VARCHAR (20),
    year_of_birth INT,
    year_of_death INT
);

CREATE TABLE members_books(
    id SERIAL PRIMARY KEY,
    members_rut VARCHAR (10) REFERENCES members(rut),
    books_isbn VARCHAR (15) REFERENCES books(isbn),
    starting_date DATE NOT NULL,
    expected_return_date DATE NOT NULL,
    real_return_date DATE NOT NULL
);

CREATE TABLE books_authors(
    id SERIAL PRIMARY KEY,
    books_isbn VARCHAR (15) REFERENCES books(isbn),
    authors_id INT REFERENCES authors(id),
    type_of_author VARCHAR (10)
);


--2. Se deben insertar los registros en las tablas correspondientes
\copy addresses FROM 'csv/addresses.csv' CSV HEADER;
\copy members FROM 'csv/members.csv' CSV HEADER;
\copy books FROM 'csv/books.csv' CSV HEADER;
\copy authors FROM 'csv/authors.csv' WITH NULL AS 'null' CSV HEADER ;
\copy members_books FROM 'csv/members_books.csv' CSV HEADER;
\copy books_authors FROM 'csv/books_authors.csv' CSV HEADER;

--3. Realizar las siguientes consultas:

--a. Mostrar todos los libros que posean menos de 300 páginas.
SELECT title, number_of_pages FROM books WHERE number_of_pages < 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970
SELECT first_name, last_name, year_of_birth FROM authors
WHERE year_of_birth > 1970;

--c. ¿Cuál es el libro más solicitado?
SELECT b.title, COUNT(*) AS modal FROM members_books
INNER JOIN books AS b ON isbn = books_isbn
GROUP BY b.title
ORDER BY modal DESC
LIMIT 1;

--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
--debería pagar cada usuario que entregue el préstamo después de 7 días.

--REFORMULACIÓN: Si se cobrara una multa de $100 por cada día de atraso, 
--mostrar cuánto deberían pagar cada usuario que entregue el
--préstamo después de la fecha esperada de devolución.

SELECT m.first_name AS member,
days_late, days_late*100 as fine
FROM (SELECT members_rut,
    SUM(real_return_date::date - expected_return_date::date) AS days_late
    FROM members_books WHERE real_return_date > expected_return_date 
    GROUP BY members_rut,real_return_date,expected_return_date) AS delays
INNER JOIN members AS m ON rut = members_rut
ORDER BY days_late DESC;


