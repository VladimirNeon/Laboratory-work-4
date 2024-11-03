-- Видалення таблиць із каскадним видаленням обмежень
DROP TABLE IF EXISTS Publication CASCADE;
DROP TABLE IF EXISTS SearchParameters CASCADE;
DROP TABLE IF EXISTS Work CASCADE;
DROP TABLE IF EXISTS User CASCADE;

-- Створення таблиці User
CREATE TABLE User (
    user_id SERIAL PRIMARY KEY, -- ID користувача, автоматично збільшується
    name VARCHAR(100) NOT NULL, -- Ім'я користувача
    email VARCHAR(255) NOT NULL UNIQUE, -- Електронна пошта користувача
    password VARCHAR(255) NOT NULL -- Пароль користувача
);

-- Обмеження на формат email
ALTER TABLE User ADD CONSTRAINT user_email_format 
    CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Обмеження на формат name (тільки літери і пробіли)
ALTER TABLE User ADD CONSTRAINT user_name_format 
    CHECK (name ~ '^[A-Za-z'' ]+$');

-- Обмеження на довжину паролю (мінімум 7 символів)
ALTER TABLE User ADD CONSTRAINT user_password_length 
    CHECK (LENGTH(password) > 6);

-- Створення таблиці Work
CREATE TABLE Work (
    work_id SERIAL PRIMARY KEY, -- ID твору, автоматично збільшується
    title VARCHAR(255) NOT NULL, -- Назва твору
    content TEXT, -- Зміст твору
    user_id INTEGER NOT NULL REFERENCES User(user_id) -- ID користувача, який створив твір
);

-- Обмеження на довжину title
ALTER TABLE Work ADD CONSTRAINT work_title_length CHECK (LENGTH(title) <= 255);

-- Створення таблиці SearchParameters
CREATE TABLE SearchParameters (
    parameter_id SERIAL PRIMARY KEY, -- ID параметрів пошуку, автоматично збільшується
    genre VARCHAR(50), -- Жанр твору
    author VARCHAR(100), -- Ім'я автора
    keywords VARCHAR(255), -- Ключові слова
    work_id INTEGER NOT NULL REFERENCES Work(work_id) -- ID твору
);

-- Обмеження унікальності для genre та author
ALTER TABLE SearchParameters ADD CONSTRAINT searchparameters_genre_author_unique 
    UNIQUE (genre, author);

-- Створення таблиці Publication
CREATE TABLE Publication (
    publication_id SERIAL PRIMARY KEY, -- ID публікації, автоматично збільшується
    publication_date DATE, -- Дата публікації
    publication_status VARCHAR(50), -- Статус публікації
    user_id INTEGER NOT NULL REFERENCES User(user_id), -- ID користувача, який публікує твір
    work_id INTEGER NOT NULL REFERENCES Work(work_id) -- ID твору
);

-- Обмеження унікальності для publication_status
ALTER TABLE Publication ADD CONSTRAINT publication_status_unique UNIQUE (publication_status);
