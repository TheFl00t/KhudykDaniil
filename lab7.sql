-- Создание таблиц
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS authors;

CREATE TABLE categories (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE authors (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    ip_address VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE articles (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    context TEXT NOT NULL,
    category_id INT UNSIGNED,
    author_id INT UNSIGNED,
    publication_date DATETIME NOT NULL,

    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE comments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    article_id INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED,
    context TEXT NOT NULL,
    comment_date DATETIME NOT NULL,

    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE ratings (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    article_id INT UNSIGNED NOT NULL,
    ip_address VARCHAR(15) NOT NULL,
    rating TINYINT UNSIGNED NOT NULL CHECK
        (rating BETWEEN 1 AND 5),
    UNIQUE (article_id, ip_address),

    FOREIGN KEY (article_id) REFERENCES articles(id)
);

-- Обновление кодировок
ALTER DATABASE `mydb` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE categories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE authors CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE articles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE ratings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- TABLE: categories
INSERT INTO categories 
    (name)
VALUES ('Игры'), ('Технологии'), ('Спорт'), ('Культура');

-- TABLE: authors
INSERT INTO authors 
    (name, ip_address)
VALUES 
    ('Andreev Andrey Andreevich', '192.180.1.1'),
    ('random_name', '192.100.1.203'),
    ('abcd', '94.111.34.199'),
    ('Galina84', '94.15.137.178'),
    ('guest93451', '60.173.237.241');

-- TABLE: articles
INSERT INTO articles 
    (title, context, category_id, author_id, publication_date)
VALUES
    ('Новые технологии в 2024 году', 'Контент статьи...', 2, 1, '2024-10-13 14:00:00'),
    ('Обзор чемпионата мира', 'Спортивный обзор...', 3, 2, '2024-11-01 12:30:00'),
    ('Перенос даты выхода игры...', 'Counter-Strike был...', 1, 4, '2024-11-28 18:10:00');

-- TABLE: comments
INSERT INTO comments
    (article_id, author_id, context, comment_date)
VALUES
    (1, 2, 'Очень интересная статья, жду продолжения!', '2024-10-13 15:30:00'),
    (1, 3, 'Информация полезная, но хотелось бы больше деталей.', '2024-10-13 16:45:00'),
    (2, 4, 'Согласен с автором, это был потрясающий матч!', '2024-11-01 13:10:00'),
    (2, 5, 'Не думаю, что команда заслужила такую победу.', '2024-11-01 14:50:00'),
    (3, 1, 'Почему опять перенос? Это уже не смешно.', '2024-11-28 19:00:00');

-- TABLE: ratings
INSERT INTO ratings
    (article_id, ip_address, rating)
VALUES
    (1, '60.173.237.241', 4),
    (2, '192.180.1.1', 5),
    (3, '94.111.34.199', 2),
    (3, '60.173.237.241', 1),
    (3, '192.100.1.203', 1);
	

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Вывод всех статей с их категориями и авторами
SELECT articles.title, categories.name AS category, 
    articles.context, authors.name AS author, 
    articles.publication_date
FROM articles
INNER JOIN categories ON
    articles.category_id = categories.id
INNER JOIN authors ON
    articles.author_id = authors.id;

-- Обновление рейтинга
UPDATE ratings
SET rating = 5
WHERE article_id = 3 AND ip_address = '60.173.237.241';

-- Удаление всех комментариев автора
DELETE FROM comments
WHERE author_id = 2;

-- Вывод комментариев к определённой статье
SELECT articles.title, comments.context AS comment, 
    authors.name AS author
FROM comments
INNER JOIN authors ON
    comments.author_id = authors.id
INNER JOIN articles ON
    comments.article_id = articles.id
WHERE articles.id = 1;

-- Количество статей в каждой категории
SELECT categories.name AS category_name,
    COUNT(articles.id) AS articles_count
FROM categories
LEFT JOIN articles ON categories.id = articles.category_id
GROUP BY categories.name;

-- Средний рейтинг статьи
SELECT AVG(ratings.rating) AS average_rating
FROM ratings
INNER JOIN articles ON
    ratings.article_id = articles.id
WHERE articles.id = 3;

-- Добавление новой статьи
INSERT INTO categories (name)
VALUES ('test_category');

INSERT INTO authors (name, ip_address)
VALUES ('test_author', '111.11.11.1');

INSERT INTO articles (
    title,
    context,
    category_id,
    author_id,
    publication_date
)
VALUES (
    'Test_title',
    'Test_context...',
    (SELECT id FROM categories WHERE name = 'test_category'),
    (SELECT id FROM authors WHERE name = 'test_author'),
    '1111-11-11 11:11:11'
);

-- Удаление статьи по id
DELETE FROM comments
WHERE article_id = 6;

DELETE FROM ratings 
WHERE article_id = 6;

DELETE FROM articles 
WHERE id = 4;

DELETE FROM categories
WHERE id = 5;

DELETE FROM authors
WHERE id = 6;
