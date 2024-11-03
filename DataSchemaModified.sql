CREATE TABLE user (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK (name ~ '^[A-Za-z\s]{1,100}$'),
    email VARCHAR(100) NOT NULL UNIQUE CHECK (
        email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ),
    password VARCHAR(255) NOT NULL CHECK (char_length(password) > 6)
);

CREATE TABLE work (
    work_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL CHECK (char_length(title) < 255),
    description VARCHAR(255) CHECK (char_length(description) < 255),
    author VARCHAR(100) NOT NULL CHECK (char_length(author) < 100),
    user_id INT NOT NULL REFERENCES "user" (user_id) ON DELETE CASCADE
);

CREATE TABLE search_parameters (
    parameter_id SERIAL PRIMARY KEY,
    genre VARCHAR(50) CHECK (char_length(genre) < 50),
    author VARCHAR(100) CHECK (char_length(author) < 100),
    keywords VARCHAR(255) CHECK (char_length(keywords) < 255),
    work_id INT NOT NULL REFERENCES work (work_id) ON DELETE CASCADE
);

CREATE TABLE publication (
    publication_id SERIAL PRIMARY KEY,
    publication_date DATE NOT NULL,
    publication_status VARCHAR(50),
    user_id INT NOT NULL REFERENCES "user" (user_id) ON DELETE CASCADE,
    work_id INT NOT NULL REFERENCES work (work_id) ON DELETE CASCADE
);
