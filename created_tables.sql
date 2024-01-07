CREATE TABLE email (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR(500) NOT NULL UNIQUE
);


CREATE TABLE phone (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    phone_no VARCHAR(500) NOT NULL UNIQUE
);


CREATE TABLE instruments (
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
 instrument_type VARCHAR(100) NOT NULL,
 brand VARCHAR(500),
 rent_fee VARCHAR(500)
);


CREATE TABLE price_category (
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
 lesson_type_fee INT,
 instructor_salary INT,
 sibling_discount INT,
 skill_level_fee INT
);

CREATE TABLE studio (
    studio_id VARCHAR(100) NOT NULL PRIMARY KEY,
    street VARCHAR(500),
    zip VARCHAR(500),
    city VARCHAR(500),
    description VARCHAR(2000),
    available_times VARCHAR(500) NOT NULL
);


CREATE TABLE person (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_number VARCHAR(12) NOT NULL,
    first_name VARCHAR(500) NOT NULL,
    last_name VARCHAR(500) NOT NULL,
    age INT,
    street VARCHAR(500) NOT NULL,
    zip VARCHAR(500) NOT NULL,
    city VARCHAR(500) NOT NULL,
    phone_id INT,
    email_id INT,
    UNIQUE(person_number),
    FOREIGN KEY (phone_id) REFERENCES phone (id),
    FOREIGN KEY (email_id) REFERENCES email (id)
);


CREATE TABLE student (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person (id)
);




CREATE TABLE instructor (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id INT NOT NULL,
    employment_id VARCHAR(500) NOT NULL UNIQUE,
    FOREIGN KEY (person_id) REFERENCES person (id)
);



CREATE TABLE instruments_type (
    instrument_teaches_type VARCHAR(500) NOT NULL,
    instructor_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructor (id),
    PRIMARY KEY (instrument_teaches_type, instructor_id)
);


CREATE TABLE lesson (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    price_id INT NOT NULL,
    studio_id VARCHAR(100),
    instrument_type VARCHAR(500) NOT NULL,
    min_of_students INT,
    max_of_students INT,
    amount_of_students INT,
    time TIMESTAMP NOT NULL,
    target_genre VARCHAR(500) NOT NULL,
    student_id INT NOT NULL,
    lesson_type VARCHAR(500),
    skill_level VARCHAR(500)
);


CREATE TABLE student_lesson (
    student_id INT NOT NULL,
    lesson_id INT NOT NULL,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (student_id) REFERENCES student (id),
    FOREIGN KEY (lesson_id) REFERENCES lesson (id)
);


CREATE TABLE lesson_teaches (
    instructor_id INT NOT NULL,
    lesson_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructor (id),
    FOREIGN KEY (lesson_id) REFERENCES lesson (id),
    PRIMARY KEY (instructor_id, lesson_id)
);


CREATE TABLE rent_instrument (
    rent_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    instrument_id INT NOT NULL,
    rental_start TIMESTAMP NOT NULL,
    rental_end TIMESTAMP NOT NULL,
    student_id INT NOT NULL,
    PRIMARY KEY (rent_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments (id),
    FOREIGN KEY (student_id) REFERENCES student (id)
);


CREATE TABLE "sibling"
(
    "id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "student_id" int NOT NULL REFERENCES "student",
    "sibling_id" int NOT NULL REFERENCES "student"
);


