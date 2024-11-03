-- Видалення таблиць із каскадним видаленням обмежень
DROP TABLE Publication CASCADE CONSTRAINTS;
DROP TABLE SearchParameters CASCADE CONSTRAINTS;
DROP TABLE Work CASCADE CONSTRAINTS;
DROP TABLE User CASCADE CONSTRAINTS;

-- Створення таблиці User
CREATE TABLE User (
    user_id NUMBER(5), -- ID користувача
    name VARCHAR(100), -- Ім'я користувача
    email VARCHAR(255), -- Електронна пошта користувача
    password VARCHAR(255) -- Пароль користувача
);

-- Обмеження первинного ключа для User
ALTER TABLE User ADD CONSTRAINT user_pk PRIMARY KEY (user_id);

-- Обмеження унікальності для email
ALTER TABLE User ADD CONSTRAINT user_email_unique UNIQUE (email);

-- Обмеження цілісності для email та name
ALTER TABLE User ADD CONSTRAINT user_email_format 
    CHECK (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'));
ALTER TABLE User ADD CONSTRAINT user_name_format 
    CHECK (regexp_like(name, '^[A-Za-z'' ]+$'));

-- Обмеження на довжину паролю
ALTER TABLE User MODIFY (password NOT NULL);
ALTER TABLE User ADD CONSTRAINT user_password_length CHECK (LENGTH(password) > 6);

-- Створення таблиці Work
CREATE TABLE Work (
    work_id NUMBER(5), -- ID твору
    title VARCHAR(255), -- Назва твору
    content TEXT, -- Зміст твору
    user_id NUMBER(5) -- ID користувача, який створив твір
);

-- Обмеження первинного ключа для Work
ALTER TABLE Work ADD CONSTRAINT work_pk PRIMARY KEY (work_id);

-- Обмеження зовнішнього ключа для user_id у Work
ALTER TABLE Work ADD CONSTRAINT work_user_fk FOREIGN KEY (user_id)
    REFERENCES User(user_id);

-- Обмеження на довжину title
ALTER TABLE Work MODIFY (title NOT NULL);
ALTER TABLE Work ADD CONSTRAINT work_title_length CHECK (LENGTH(title) <= 255);

-- Створення таблиці SearchParameters
CREATE TABLE SearchParameters (
    parameter_id NUMBER(5), -- ID параметрів пошуку
    genre VARCHAR(50), -- Жанр твору
    author VARCHAR(100), -- Ім'я автора
    keywords VARCHAR(255), -- Ключові слова
    work_id NUMBER(5) -- ID твору
);

-- Обмеження первинного ключа для SearchParameters
ALTER TABLE SearchParameters ADD CONSTRAINT searchparameters_pk PRIMARY KEY (parameter_id);

-- Обмеження зовнішнього ключа для work_id у SearchParameters
ALTER TABLE SearchParameters ADD CONSTRAINT searchparameters_work_fk FOREIGN KEY (work_id)
    REFERENCES Work(work_id);

-- Обмеження унікальності для genre та author
ALTER TABLE SearchParameters ADD CONSTRAINT searchparameters_genre_author_unique 
    UNIQUE (genre, author);

-- Створення таблиці Publication
CREATE TABLE Publication (
    publication_id NUMBER(5), -- ID публікації
    publication_date DATE, -- Дата публікації
    publication_status VARCHAR(50), -- Статус публікації
    user_id NUMBER(5), -- ID користувача, який публікує твір
    work_id NUMBER(5) -- ID твору
);

-- Обмеження первинного ключа для Publication
ALTER TABLE Publication ADD CONSTRAINT publication_pk PRIMARY KEY (publication_id);

-- Обмеження зовнішнього ключа для user_id та work_id у Publication
ALTER TABLE Publication ADD CONSTRAINT publication_user_fk FOREIGN KEY (user_id)
    REFERENCES User(user_id);
ALTER TABLE Publication ADD CONSTRAINT publication_work_fk FOREIGN KEY (work_id)
    REFERENCES Work(work_id);

-- Обмеження унікальності для publication_status
ALTER TABLE Publication ADD CONSTRAINT publication_status_unique UNIQUE (publication_status);
