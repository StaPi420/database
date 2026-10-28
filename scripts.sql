INSERT INTO reader_categories
    (category_name, max_books, loan_days)
VALUES
    ('Аспирант', 7, 21);

INSERT INTO readers
    (first_name, last_name, birth_date, category_id)
VALUES
    ('Александр', 'Павлов', '2003-05-12',
     (SELECT id_category
      FROM reader_categories
      WHERE category_name = 'Студент'));

INSERT INTO genres (name)
VALUES ('Детектив');

INSERT INTO books (title, id_genre)
VALUES (
    'Шерлок Холмс: Собрание рассказов',
    (SELECT id_genre
     FROM genres
     WHERE name = 'Детектив')
);

INSERT INTO copies
    (inventory_number, id_edition, arrival_date)
VALUES
    ('INV-NEW-001', 1, CURRENT_DATE);

DELETE FROM readers
WHERE id_reader = 8;

DELETE FROM genres
WHERE name = 'Детектив';

DELETE FROM reservations
WHERE id_reservation = 3;

DELETE FROM reservations;

DELETE FROM ill_orders;