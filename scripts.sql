SELECT
    b.title AS book_title,
    g.name AS genre
FROM books b
INNER JOIN genres g
    ON b.id_genre = g.id_genre;

SELECT
    r.first_name,
    r.last_name,
    rc.category_name
FROM readers r
LEFT JOIN reader_categories rc
    ON r.category_id = rc.id_category;

SELECT
    rc.category_name,
    COUNT(r.id_reader)
FROM readers r
RIGHT JOIN reader_categories rc
    ON r.category_id = rc.id_category
GROUP BY rc.id_category, rc.category_name;

SELECT
    b.title AS book_title,
    g.name AS genre
FROM books b
FULL JOIN genres g
    ON b.id_genre = g.id_genre;

SELECT
    r.first_name,
    r.last_name,
    c.inventory_number
FROM readers r
CROSS JOIN copies c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.id_copy = c.id_copy
      AND l.actual_return_date IS NULL
);

SELECT
    r.first_name,
    r.last_name,
    l.id_copy,
    l.loan_date
FROM readers r
CROSS JOIN LATERAL (
    SELECT
        id_copy,
        loan_date
    FROM loans
    WHERE id_reader = r.id_reader
    ORDER BY loan_date DESC
    LIMIT 3
) l;

SELECT
    r1.first_name,
    r1.last_name,
    r2.first_name,
    r2.last_name,
    b.title
FROM loans l1
JOIN loans l2
    ON l1.id_copy <> l2.id_copy
JOIN readers r1
    ON r1.id_reader = l1.id_reader
JOIN readers r2
    ON r2.id_reader = l2.id_reader
JOIN copies c1
    ON c1.id_copy = l1.id_copy
JOIN copies c2
    ON c2.id_copy = l2.id_copy
JOIN editions e
    ON e.id_edition = c1.id_edition
   AND e.id_edition = c2.id_edition
JOIN books b
    ON b.id_book = e.id_book
WHERE l1.id_reader < l2.id_reader;



SELECT id_reader
FROM loans

UNION

SELECT id_reader
FROM ill_orders;



SELECT id_reader, 'Выдача книги' AS activity, loan_date 
FROM loans

UNION ALL

SELECT id_reader, 'Межбиблиотечный заказ' AS activity, completion_date
FROM ill_orders;


SELECT id_reader
FROM loans

EXCEPT

SELECT id_reader
FROM ill_orders;


SELECT id_reader
FROM loans

INTERSECT

SELECT id_reader
FROM ill_orders;


SELECT
    first_name,
    last_name
FROM readers r
WHERE EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.id_reader = r.id_reader
);

SELECT
    title
FROM books
WHERE id_book IN (
    SELECT e.id_book
    FROM editions e
    JOIN copies c ON c.id_edition = e.id_edition
    JOIN loans l ON l.id_copy = c.id_copy
);

SELECT
    r.first_name,
    r.last_name,
    r.registration_date
FROM readers r
WHERE r.registration_date < ALL (
    SELECT r2.registration_date
    FROM readers r2
    JOIN reader_categories rc
        ON rc.id_category = r2.category_id
    WHERE rc.category_name = 'Студенты'
);

SELECT
    title,
    page_count
FROM editions
WHERE page_count > ANY (
    SELECT page_count
    FROM editions
    WHERE id_publisher = 1
);

SELECT
    title,
    publication_year
FROM editions
WHERE publication_year BETWEEN 2000 AND 2020;

SELECT title
FROM books
WHERE title LIKE 'А%';

SELECT title
FROM books
WHERE title ILIKE '%война%';

SELECT
    id_loan,
    id_reader,
    loan_date,
    due_date,
    actual_return_date,
    CASE
        WHEN actual_return_date IS NULL
             AND CURRENT_DATE > due_date
            THEN 'Просрочена'
        WHEN actual_return_date IS NULL
            THEN 'На руках'
        WHEN actual_return_date > due_date
            THEN 'Возвращена с опозданием'
        ELSE 'Возвращена вовремя'
    END
FROM loans;

SELECT
    title,
    CAST(publication_year AS VARCHAR)
FROM editions;

SELECT
    title,
    publication_year::VARCHAR
FROM editions;

SELECT
    first_name,
    last_name,
    COALESCE(category_id::VARCHAR, 'Не указана')
FROM readers;

SELECT
    id_loan,
    id_reader,
    due_date,
    actual_return_date,
    NULLIF(actual_return_date, due_date)
FROM loans;

SELECT
    id_loan,
    id_reader,
    due_date,
    actual_return_date,
    GREATEST(
        due_date,
        COALESCE(actual_return_date, CURRENT_DATE)
    )
FROM loans;

SELECT
    id_loan,
    LEAST(actual_return_date, due_date)
FROM loans;

SELECT
    title,
    LENGTH(title)
FROM books;

SELECT
    title || CHR(45) || 'издание'
FROM books;

SELECT
    title,
    STRPOS(title, ' ') AS space_position
FROM books;

SELECT
    title,
    OVERLAY(title PLACING '***' FROM 1 FOR 3)
FROM books;

SELECT
    title,
    SUBSTRING(title FROM 1 FOR 10) AS short_title
FROM books;

SELECT
    title,
    POSITION('а' IN title)
FROM books;

SELECT
    title,
    REPLACE(title, ' ', '_')
FROM books;

SELECT
    title,
    LOWER(title)
FROM books;

SELECT
    last_name,
    UPPER(last_name)
FROM authors;

SELECT
    first_name,
    last_name,
    BTRIM(first_name),
    LTRIM(last_name)
FROM readers;


SELECT
    l.id_loan,
    r.first_name,
    r.last_name,
    c.inventory_number,
    l.due_date,
    NOW()
FROM loans l
JOIN readers r ON r.id_reader = l.id_reader
JOIN copies c ON c.id_copy = l.id_copy
WHERE l.actual_return_date IS NULL
  AND l.due_date < NOW();

SELECT
    r.first_name,
    r.last_name,
    c.inventory_number,
    l.due_date
FROM loans l
JOIN readers r ON r.id_reader = l.id_reader
JOIN copies c ON c.id_copy = l.id_copy
WHERE l.due_date = CURRENT_DATE
  AND l.actual_return_date IS NULL;

SELECT
    CURRENT_TIME AS current_time,
    CASE
        WHEN CURRENT_TIME BETWEEN '09:00:00' AND '18:00:00'
            THEN 'Библиотека открыта'
        ELSE 'Библиотека закрыта'
    END AS library_status;

SELECT
    l.id_loan,
    r.first_name,
    r.last_name,
    l.loan_date,
    CURRENT_TIMESTAMP - l.loan_date AS time_since_loan
FROM loans l
JOIN readers r ON r.id_reader = l.id_reader;

SELECT
    l.id_loan,
    r.first_name,
    r.last_name,
    l.loan_date,
    CURRENT_TIMESTAMP::TIMESTAMP - l.loan_date AS time_since_loan
FROM loans l
JOIN readers r ON r.id_reader = l.id_reader;

SELECT
    first_name,
    last_name,
    birth_date,
    AGE(CURRENT_DATE, birth_date)
FROM readers
WHERE AGE(CURRENT_DATE, birth_date) >= INTERVAL '60 years';

SELECT
    DATE_PART('month', loan_date) AS loan_month,
    COUNT(*) AS total_loans
FROM loans
GROUP BY DATE_PART('month', loan_date)
ORDER BY loan_month;

SELECT
    EXTRACT(MONTH FROM loan_date) AS loan_month,
    COUNT(*) AS total_loans
FROM loans
GROUP BY EXTRACT(MONTH FROM loan_date)
ORDER BY loan_month;


SELECT
    id_ill_order,
    id_reader,
    order_date,
    LOCALTIMESTAMP
FROM ill_orders;


SELECT
    MIN(page_count) AS min_pages,
    MAX(page_count) AS max_pages
FROM editions;

SELECT
    AVG(page_count) AS average_page_count
FROM editions;

SELECT
    SUM(quantity) AS total_ordered_copies
FROM ill_order_editions;

SELECT
    rc.category_name,
    COUNT(r.id_reader) AS readers_count
FROM reader_categories rc
JOIN readers r
    ON r.category_id = rc.id_category
GROUP BY rc.id_category, rc.category_name
HAVING COUNT(r.id_reader) > 2;
