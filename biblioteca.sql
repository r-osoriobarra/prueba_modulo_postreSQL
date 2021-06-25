--Prueba - Biblioteca
DROP DATABASE biblioteca;
--Crear la base de datos
CREATE DATABASE biblioteca;

--Conectarse a la base de datos
\c biblioteca

-- Crear entidades del modelo

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

--cargar registros en tablas
\copy addresses FROM 'csv/addresses.csv' CSV HEADER;
\copy members FROM 'csv/members.csv' CSV HEADER;
\copy books FROM 'csv/books.csv' CSV HEADER;
\copy authors FROM 'csv/authors.csv' WITH NULL AS 'null' CSV HEADER ;
\copy members_books FROM 'csv/members_books.csv' CSV HEADER;
\copy books_authors FROM 'csv/books_authors.csv' CSV HEADER;


