-- Create historical table for lessons: 

CREATE TABLE historical_lessons (
    historical_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_type VARCHAR(500),
    genre VARCHAR(500) DEFAULT NULL,  
    instrument_type VARCHAR(500) DEFAULT NULL,  
    lesson_price INT,
    student_name VARCHAR(500),
    student_email VARCHAR(500),
    lesson_date TIMESTAMP
);
-- Query for data insertion/copying from present database into history table: 

INSERT INTO historical_lessons (lesson_type, genre, instrument_type, lesson_price, student_name, student_email, lesson_date)
SELECT
    l.lesson_type,
    CASE WHEN l.lesson_type = 'ensemble' THEN l.target_genre ELSE NULL END as genre,
    CASE WHEN l.lesson_type != 'ensemble' THEN l.instrument_type ELSE NULL END as instrument_type,
    pc.lesson_type_fee + pc.instructor_salary - pc.sibling_discount + pc.skill_level_fee AS lesson_price,
    CONCAT(p.first_name, ' ', p.last_name) AS student_name,
    e.email AS student_email,
    l.time AS lesson_date
FROM
    lesson l
JOIN
    price_category pc ON l.price_id = pc.id
JOIN
    student s ON l.student_id = s.id
JOIN
    person p ON s.person_id = p.id
JOIN
    email e ON p.email_id = e.id;
