INSERT INTO reader_categories (category_name, max_books, loan_days) VALUES
('Студент', 5, 14),
('Преподаватель', 10, 30),
('Школьник', 3, 14),
('Пенсионер', 5, 21),
('Обычный читатель', 5, 21);

INSERT INTO ill_types (ill_type_name, days) VALUES
('Межбиблиотечный абонемент', 30),
('Электронная доставка документа', 7),
('Временный заказ издания', 21);

INSERT INTO partner_libraries (name, city) VALUES
('Российская государственная библиотека', 'Москва'),
('Российская национальная библиотека', 'Санкт-Петербург'),
('Научная библиотека СГУ', 'Саратов'),
('Национальная библиотека Республики Татарстан', 'Казань');

INSERT INTO employees (first_name, last_name, position) VALUES
('Анна', 'Иванова', 'Библиотекарь'),
('Сергей', 'Петров', 'Старший библиотекарь'),
('Мария', 'Сидорова', 'Заведующий отделом'),
('Алексей', 'Смирнов', 'Библиограф'),
('Елена', 'Кузнецова', 'Специалист МБА');

INSERT INTO genres (name) VALUES
('Роман'),
('Философия'),
('Научная литература'),
('Фантастика'),
('Классическая литература'),
('Программирование');

INSERT INTO authors (first_name, last_name) VALUES
('Лев', 'Толстой'),
('Фёдор', 'Достоевский'),
('Иван', 'Тургенев'),
('Михаил', 'Булгаков'),
('Джордж', 'Оруэлл'),
('Фридрих', 'Ницше'),
('Карл', 'Маркс'),
('Роберт', 'Мартин'),
('Эрих Мария', 'Ремарк'),
('Герман', 'Гессе');

INSERT INTO books (title, id_genre) VALUES
('Война и мир', (SELECT id_genre FROM genres WHERE name = 'Роман')),
('Преступление и наказание', (SELECT id_genre FROM genres WHERE name = 'Роман')),
('Отцы и дети', (SELECT id_genre FROM genres WHERE name = 'Классическая литература')),
('Мастер и Маргарита', (SELECT id_genre FROM genres WHERE name = 'Роман')),
('1984', (SELECT id_genre FROM genres WHERE name = 'Фантастика')),
('Так говорил Заратустра', (SELECT id_genre FROM genres WHERE name = 'Философия')),
('Капитал', (SELECT id_genre FROM genres WHERE name = 'Философия')),
('Чистый код', (SELECT id_genre FROM genres WHERE name = 'Программирование')),
('Три товарища', (SELECT id_genre FROM genres WHERE name = 'Роман')),
('Степной волк', (SELECT id_genre FROM genres WHERE name = 'Философия'));

INSERT INTO book_authors (id_book, id_author)
SELECT b.id_book, a.id_author
FROM (VALUES
    ('Война и мир', 'Лев', 'Толстой'),
    ('Преступление и наказание', 'Фёдор', 'Достоевский'),
    ('Отцы и дети', 'Иван', 'Тургенев'),
    ('Мастер и Маргарита', 'Михаил', 'Булгаков'),
    ('1984', 'Джордж', 'Оруэлл'),
    ('Так говорил Заратустра', 'Фридрих', 'Ницше'),
    ('Капитал', 'Карл', 'Маркс'),
    ('Чистый код', 'Роберт', 'Мартин'),
    ('Три товарища', 'Эрих Мария', 'Ремарк'),
    ('Степной волк', 'Герман', 'Гессе')
) AS v(book_title, first_name, last_name)
JOIN books b ON b.title = v.book_title
JOIN authors a
    ON a.first_name = v.first_name
   AND a.last_name = v.last_name;

INSERT INTO publishers (name, city) VALUES
('Эксмо', 'Москва'),
('АСТ', 'Москва'),
('Азбука', 'Санкт-Петербург'),
('Питер', 'Санкт-Петербург'),
('Альпина', 'Москва');

INSERT INTO editions
    (id_book, title, isbn, publication_year,
     page_count, id_publisher, language)
SELECT
    b.id_book, v.edition_title, v.isbn, v.pub_year,
    v.pages, p.id_publisher, v.lang
FROM (VALUES
    ('Война и мир', 'Война и мир. Том 1',
     '9785000000001', 2020, 640, 'Эксмо', 'Русский'),
    ('Война и мир', 'Война и мир. Полное издание',
     '9785000000002', 2023, 1300, 'АСТ', 'Русский'),
    ('Преступление и наказание', 'Преступление и наказание',
     '9785000000003', 2021, 608, 'Азбука', 'Русский'),
    ('Отцы и дети', 'Отцы и дети',
     '9785000000004', 2019, 256, 'Эксмо', 'Русский'),
    ('Мастер и Маргарита', 'Мастер и Маргарита',
     '9785000000005', 2022, 480, 'АСТ', 'Русский'),
    ('1984', '1984',
     '9785000000006', 2020, 320, 'Азбука', 'Русский'),
    ('1984', 'Nineteen Eighty-Four',
     '9785000000007', 2021, 328, 'Азбука', 'Английский'),
    ('Так говорил Заратустра', 'Так говорил Заратустра',
     '9785000000008', 2018, 416, 'Эксмо', 'Русский'),
    ('Капитал', 'Капитал. Том I',
     '9785000000009', 2022, 976, 'АСТ', 'Русский'),
    ('Чистый код', 'Чистый код',
     '9785000000010', 2023, 464, 'Питер', 'Русский'),
    ('Три товарища', 'Три товарища',
     '9785000000011', 2020, 480, 'Азбука', 'Русский'),
    ('Степной волк', 'Степной волк',
     '9785000000012', 2019, 288, 'Эксмо', 'Русский')
) AS v(book_title, edition_title, isbn, pub_year, pages, publisher_name, lang)
JOIN books b ON b.title = v.book_title
JOIN publishers p ON p.name = v.publisher_name;

INSERT INTO readers
    (first_name, last_name, birth_date, registration_date, category_id)
SELECT
    v.first_name, v.last_name, v.birth_date::DATE, v.reg_date::DATE,
    rc.id_category
FROM (VALUES
    ('Иван', 'Соколов', '2004-03-15', '2025-09-01', 'Студент'),
    ('Мария', 'Волкова', '2002-07-22', '2025-09-05', 'Студент'),
    ('Павел', 'Морозов', '1985-11-10', '2024-02-12', 'Преподаватель'),
    ('Ольга', 'Новикова', '2010-05-18', '2025-10-01', 'Школьник'),
    ('Дмитрий', 'Фёдоров', '1958-01-30', '2023-04-10', 'Пенсионер'),
    ('Екатерина', 'Попова', '1997-08-14', '2024-06-20', 'Обычный читатель'),
    ('Артём', 'Лебедев', '2003-12-05', '2025-09-02', 'Студент'),
    ('Наталья', 'Козлова', '1990-04-27', '2024-11-11', 'Обычный читатель')
) AS v(first_name, last_name, birth_date, reg_date, category_name)
JOIN reader_categories rc ON rc.category_name = v.category_name;

INSERT INTO copies
    (inventory_number, id_edition, arrival_date, last_loan_date)
SELECT
    'INV-' || LPAD(e.id_edition::TEXT, 3, '0') || '-' || n.num,
    e.id_edition,
    DATE '2024-01-15' + (e.id_edition % 180),
    NULL
FROM editions e
CROSS JOIN (VALUES (1), (2)) AS n(num);

INSERT INTO loans
    (id_reader, id_copy, id_employee, loan_date,
     due_date, actual_return_date)
SELECT
    r.id_reader, c.id_copy, emp.id_employee,
    v.loan_date::DATE, v.due_date::DATE, v.return_date::DATE
FROM (VALUES
    ('Иван', 'Соколов', 1, 1, '2026-09-01', '2026-09-15', '2026-09-12'),
    ('Мария', 'Волкова', 3, 2, '2026-10-01', '2026-10-15', '2026-10-14'),
    ('Павел', 'Морозов', 4, 3, '2026-10-10', '2026-11-09', NULL),
    ('Артём', 'Лебедев', 6, 1, '2026-10-20', '2026-11-03', NULL),
    ('Екатерина', 'Попова', 8, 4, '2026-08-01', '2026-08-22', '2026-08-20')
) AS v(first_name, last_name, edition_id, employee_id,
       loan_date, due_date, return_date)
JOIN readers r
    ON r.first_name = v.first_name AND r.last_name = v.last_name
JOIN copies c ON c.id_edition = v.edition_id
    AND c.id_copy = (
        SELECT MIN(c2.id_copy)
        FROM copies c2
        WHERE c2.id_edition = v.edition_id
    )
JOIN employees emp ON emp.id_employee = v.employee_id;

UPDATE copies c
SET last_loan_date = l.last_loan
FROM (
    SELECT id_copy, MAX(loan_date) AS last_loan
    FROM loans
    GROUP BY id_copy
) l
WHERE c.id_copy = l.id_copy;

INSERT INTO reservations
    (id_reader, id_edition, reservation_date, status)
SELECT
    r.id_reader, e.id_edition, v.res_date::DATE, v.status
FROM (VALUES
    ('Иван', 'Соколов', 'Война и мир. Полное издание',
     '2026-10-20', 'Ожидает'),
    ('Мария', 'Волкова', 'Чистый код',
     '2026-10-22', 'Выполнено'),
    ('Артём', 'Лебедев', 'Nineteen Eighty-Four',
     '2026-10-25', 'Ожидает'),
    ('Екатерина', 'Попова', 'Степной волк',
     '2026-10-26', 'Отменено')
) AS v(first_name, last_name, edition_title, res_date, status)
JOIN readers r
    ON r.first_name = v.first_name AND r.last_name = v.last_name
JOIN editions e ON e.title = v.edition_title;

INSERT INTO ill_orders
    (id_reader, id_ill_type, id_employee, order_date,
     completion_date, status)
SELECT
    r.id_reader, t.id_ill_type, emp.id_employee,
    v.order_date::DATE, v.completion_date::DATE, v.status
FROM (VALUES
    ('Иван', 'Соколов', 'Межбиблиотечный абонемент', 5,
     '2026-10-01', '2026-10-15', 'Выполнен'),
    ('Мария', 'Волкова', 'Электронная доставка документа', 4,
     '2026-10-20', NULL, 'В обработке'),
    ('Павел', 'Морозов', 'Временный заказ издания', 5,
     '2026-10-22', NULL, 'Ожидает')
) AS v(first_name, last_name, type_name, employee_id,
       order_date, completion_date, status)
JOIN readers r
    ON r.first_name = v.first_name AND r.last_name = v.last_name
JOIN ill_types t ON t.ill_type_name = v.type_name
JOIN employees emp ON emp.id_employee = v.employee_id;

INSERT INTO ill_order_editions
    (id_ill_order, id_edition, id_partner_library, quantity)
SELECT
    o.id_ill_order, e.id_edition, pl.id_partner_library, v.quantity
FROM (VALUES
    (1, 'Чистый код', 'Научная библиотека СГУ', 1),
    (2, 'Nineteen Eighty-Four', 'Российская государственная библиотека', 1),
    (3, 'Капитал. Том I', 'Российская национальная библиотека', 2)
) AS v(order_id, edition_title, library_name, quantity)
JOIN ill_orders o ON o.id_ill_order = v.order_id
JOIN editions e ON e.title = v.edition_title
JOIN partner_libraries pl ON pl.name = v.library_name;

COMMIT;
