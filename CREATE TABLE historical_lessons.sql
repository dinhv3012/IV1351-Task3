CREATE TABLE historical_lessons (
    historical_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_type VARCHAR(500),  
    genre VARCHAR(500) DEFAULT NULL, 
    instrument_type VARCHAR(500) DEFAULT NULL, 
    lesson_price INT,
    student_id INT,
    lesson_date TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student (id) 
);


INSERT INTO historical_lessons (lesson_type, genre, instrument_type, lesson_price, student_id, lesson_date)
SELECT 
    l.lesson_type,
    CASE WHEN l.lesson_type = 'ensemble' THEN l.target_genre ELSE NULL END as genre,
    CASE WHEN l.lesson_type != 'ensemble' THEN l.instrument_type ELSE NULL END as instrument_type,
    pc.lesson_type_fee + pc.instructor_salary - pc.sibling_discount + pc.skill_level_fee, -- Calculating total price
    l.student_id,
    l.time as lesson_date
FROM 
    lesson l
JOIN 
    price_category pc ON l.price_id = pc.id
JOIN 
    student s ON l.student_id = s.id; 
