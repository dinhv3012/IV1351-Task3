-- SQL Task 1 Query to show the number of lessons given per month for the specified year.

-- First, create a view to count different types of lessons per month
CREATE VIEW Monthly_Lesson_Count AS
SELECT 
    TO_CHAR(time, 'Mon') AS "Month",
    COUNT(*) AS "Total",
    COUNT(CASE WHEN lesson_type = 'Individual' THEN 1 END) AS "Individual",
    COUNT(CASE WHEN lesson_type = 'Group' THEN 1 END) AS "Group",
    COUNT(CASE WHEN lesson_type = 'Ensemble' THEN 1 END) AS "Ensemble"
FROM 
    lesson
WHERE 
    EXTRACT(YEAR FROM time) = 2023  
GROUP BY 
    TO_CHAR(time, 'Mon')
ORDER BY 
    MIN(time);

-- Query nr 1:  Select all lessons given each month in a year
CREATE VIEW lesson_count_month AS
    SELECT
	EXTRACT(month FROM time) AS month,
	count(*) FROM lesson WHERE EXTRACT(YEAR FROM time) = '2023' GROUP BY EXTRACT(month FROM time)
	ORDER BY EXTRACT(month FROM time) ASC;


-- SQL Task 2 Query to count the number of students with 0, 1, 2 siblings 

-- First, create a view to count siblings for each student
CREATE VIEW Student_Sibling_Count AS
SELECT 
    s.id AS student_id,
    COUNT(sb.sibling_id) AS sibling_count
FROM 
    student s
    LEFT JOIN sibling sb ON s.id = sb.student_id OR s.id = sb.sibling_id
GROUP BY s.id;

-- Now, use the view to count how many students have 0, 1, 2 siblings

SELECT 
    sibling_count AS "No of Siblings", 
    COUNT(student_id) AS "No of Students"
FROM 
    Student_Sibling_Count
WHERE 
    sibling_count >= 0
GROUP BY 
    sibling_count
ORDER BY 
    sibling_count;

-- Query Task 3, to count the number of lessons been tought by instructor! 

CREATE VIEW instructor_lessons_january_2023 AS
SELECT
    i.id AS "Instructor Id",
    p.first_name AS "First Name",
    p.last_name AS "Last Name",
    COUNT(l.id) AS "No of Lessons"
FROM
    instructor i
JOIN
    lesson_teaches lt ON i.id = lt.instructor_id
JOIN
    lesson l ON lt.lesson_id = l.id
JOIN
    person p ON i.person_id = p.id
WHERE
    l.time >= '2023-01-01' AND
    l.time < '2023-02-01'
GROUP BY
    i.id, p.first_name, p.last_name
HAVING
    COUNT(l.id) > 0
ORDER BY
    COUNT(l.id) DESC;



-- Query nr 5: show and list all ensembles held during the next week, sorted by music genre and weekday

CREATE MATERIALIZED VIEW ensemble_lessons_view AS
SELECT
    CASE
        WHEN EXTRACT(DOW FROM l.time) = 0 THEN 'Sun'
        WHEN EXTRACT(DOW FROM l.time) = 1 THEN 'Mon'
        WHEN EXTRACT(DOW FROM l.time) = 2 THEN 'Tue'
        WHEN EXTRACT(DOW FROM l.time) = 3 THEN 'Wed'
        WHEN EXTRACT(DOW FROM l.time) = 4 THEN 'Thu'
        WHEN EXTRACT(DOW FROM l.time) = 5 THEN 'Fri'
        WHEN EXTRACT(DOW FROM l.time) = 6 THEN 'Sat'
    END AS Day,
    l.target_genre AS Genre,
    CASE
        WHEN (l.max_of_students - l.amount_of_students) = 0 THEN 'No Seats'
        WHEN (l.max_of_students - l.amount_of_students) <= 2 THEN '1 or 2 Seats'
        ELSE 'Many Seats'
    END AS "No of Free Seats"
FROM
    lesson l
WHERE
    l.time >= '2023-01-01' AND
    l.time < '2023-10-01'
    AND l.lesson_type = 'Ensemble'
ORDER BY
    Day ASC,
    Genre ASC;
