CREATE TABLE IF NOT EXISTS reader_categories (
    id_category SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    max_books INT NOT NULL CHECK (max_books > 0),
    loan_days INT NOT NULL CHECK (loan_days > 0)
);

CREATE TABLE IF NOT EXISTS ill_types (
    id_ill_type SERIAL PRIMARY KEY,
    ill_type_name VARCHAR(255) NOT NULL,
    days INT NOT NULL CHECK (days > 0)
);

CREATE TABLE IF NOT EXISTS partner_libraries (
    id_partner_library SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS readers (
    id_reader SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    category_id INT
);

CREATE TABLE IF NOT EXISTS employees (
    id_employee SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS genres (
    id_genre SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS authors (
    id_author SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS books (
    id_book SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    id_genre INT
);

CREATE TABLE IF NOT EXISTS book_authors (
    id_record SERIAL PRIMARY KEY,
    id_book INT NOT NULL,
    id_author INT NOT NULL,
    CONSTRAINT uq_book_author UNIQUE (id_book, id_author)
);

CREATE TABLE IF NOT EXISTS publishers (
    id_publisher SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS editions (
    id_edition SERIAL PRIMARY KEY,
    id_book INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    publication_year INT NOT NULL
        CHECK (publication_year > 0),
    page_count INT NOT NULL
        CHECK (page_count > 0),
    id_publisher INT NOT NULL,
    language VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS copies (
    id_copy SERIAL PRIMARY KEY,
    inventory_number VARCHAR(50) NOT NULL UNIQUE,
    id_edition INT NOT NULL,
    last_loan_date DATE,
    arrival_date DATE NOT NULL,
    CONSTRAINT chk_copy_loan_date
        CHECK (
            last_loan_date IS NULL
            OR last_loan_date >= arrival_date
        )
);

CREATE TABLE IF NOT EXISTS reservations (
    id_reservation SERIAL PRIMARY KEY,
    id_reader INT NOT NULL,
    id_edition INT NOT NULL,
    reservation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS loans (
    id_loan SERIAL PRIMARY KEY,
    id_reader INT NOT NULL,
    id_copy INT NOT NULL,
    id_employee INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    actual_return_date DATE,
    CONSTRAINT chk_loan_dates
        CHECK (due_date >= loan_date),
    CONSTRAINT chk_actual_return_date
        CHECK (
            actual_return_date IS NULL
            OR actual_return_date >= loan_date
        )
);

CREATE TABLE IF NOT EXISTS ill_orders (
    id_ill_order SERIAL PRIMARY KEY,
    id_reader INT NOT NULL,
    id_ill_type INT NOT NULL,
    id_employee INT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    completion_date DATE,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT chk_ill_order_dates
        CHECK (
            completion_date IS NULL
            OR completion_date >= order_date
        )
);

CREATE TABLE IF NOT EXISTS ill_order_editions (
    id_record SERIAL PRIMARY KEY,
    id_ill_order INT NOT NULL,
    id_edition INT NOT NULL,
    id_partner_library INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0)
);


-- Читатели и категории читателей
ALTER TABLE readers
    ADD CONSTRAINT fk_readers_category
    FOREIGN KEY (category_id)
    REFERENCES reader_categories(id_category)
    ON DELETE SET NULL;

-- Книги и жанры
ALTER TABLE books
    ADD CONSTRAINT fk_books_genre
    FOREIGN KEY (id_genre)
    REFERENCES genres(id_genre)
    ON DELETE SET NULL;

-- Связь книг и авторов (многие ко многим)
ALTER TABLE book_authors
    ADD CONSTRAINT fk_book_authors_book
    FOREIGN KEY (id_book)
    REFERENCES books(id_book)
    ON DELETE CASCADE;

ALTER TABLE book_authors
    ADD CONSTRAINT fk_book_authors_author
    FOREIGN KEY (id_author)
    REFERENCES authors(id_author)
    ON DELETE CASCADE;

-- Издания, книги и издательства
ALTER TABLE editions
    ADD CONSTRAINT fk_editions_book
    FOREIGN KEY (id_book)
    REFERENCES books(id_book);

ALTER TABLE editions
    ADD CONSTRAINT fk_editions_publisher
    FOREIGN KEY (id_publisher)
    REFERENCES publishers(id_publisher);

-- Экземпляры книг
ALTER TABLE copies
    ADD CONSTRAINT fk_copies_edition
    FOREIGN KEY (id_edition)
    REFERENCES editions(id_edition);

-- Бронирования
ALTER TABLE reservations
    ADD CONSTRAINT fk_reservations_reader
    FOREIGN KEY (id_reader)
    REFERENCES readers(id_reader);

ALTER TABLE reservations
    ADD CONSTRAINT fk_reservations_edition
    FOREIGN KEY (id_edition)
    REFERENCES editions(id_edition);

-- Выдачи книг
ALTER TABLE loans
    ADD CONSTRAINT fk_loans_reader
    FOREIGN KEY (id_reader)
    REFERENCES readers(id_reader);

ALTER TABLE loans
    ADD CONSTRAINT fk_loans_copy
    FOREIGN KEY (id_copy)
    REFERENCES copies(id_copy);

ALTER TABLE loans
    ADD CONSTRAINT fk_loans_employee
    FOREIGN KEY (id_employee)
    REFERENCES employees(id_employee);

-- Межбиблиотечные заказы
ALTER TABLE ill_orders
    ADD CONSTRAINT fk_ill_orders_reader
    FOREIGN KEY (id_reader)
    REFERENCES readers(id_reader);

ALTER TABLE ill_orders
    ADD CONSTRAINT fk_ill_orders_type
    FOREIGN KEY (id_ill_type)
    REFERENCES ill_types(id_ill_type);

ALTER TABLE ill_orders
    ADD CONSTRAINT fk_ill_orders_employee
    FOREIGN KEY (id_employee)
    REFERENCES employees(id_employee);

-- Связь между межбиблиотечными заказами и изданиями
ALTER TABLE ill_order_editions
    ADD CONSTRAINT fk_ill_order_editions_order
    FOREIGN KEY (id_ill_order)
    REFERENCES ill_orders(id_ill_order)
    ON DELETE CASCADE;

ALTER TABLE ill_order_editions
    ADD CONSTRAINT fk_ill_order_editions_edition
    FOREIGN KEY (id_edition)
    REFERENCES editions(id_edition);

ALTER TABLE ill_order_editions
    ADD CONSTRAINT fk_ill_order_editions_library
    FOREIGN KEY (id_partner_library)
    REFERENCES partner_libraries(id_partner_library);
