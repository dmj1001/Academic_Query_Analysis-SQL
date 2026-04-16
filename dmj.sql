USE oct_batch;

-- Retrieve all students ordered by enroll_date
SELECT * 
FROM students 
ORDER BY enroll_date ASC;

-- Retrieve all courses ordered by credits (highest first)
SELECT * 
FROM courses 
ORDER BY credits DESC;

-- Show all enrollments with student name + course name + grade
SELECT e.enrollment_id, s.first_name, s.last_name, c.course_name, e.grade
FROM enrollments_1 as e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enroll_date ASC;

-- Count number of students enrolled in each course
SELECT c.course_name, COUNT(*) AS student_count
FROM enrollments_1 as e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY student_count DESC;

-- Average GPA per course
SELECT c.course_name,
       ROUND(AVG(CASE e.grade
           WHEN 'A' THEN 4.0
           WHEN 'A-' THEN 3.7
           WHEN 'B+' THEN 3.3
           WHEN 'B' THEN 3.0
           WHEN 'B-' THEN 2.7
       END),2) AS avg_gpa
FROM enrollments_1 as e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY avg_gpa DESC;

-- Count enrollments by status
SELECT status, COUNT(*) AS enrollment_count
FROM enrollments_1
GROUP BY status;

-- Find students who have enrolled in more than 2 courses
SELECT s.first_name, s.last_name, COUNT(*) AS course_count
FROM enrollments_1 as e
JOIN students as s ON e.student_id = s.student_id
GROUP BY s.student_id
HAVING course_count > 2
ORDER BY course_count DESC;

-- Find courses with more enrollments than the average
SELECT c.course_name
FROM courses c
WHERE c.course_id IN (
    SELECT course_id
    FROM enrollments_1
    GROUP BY course_id
    HAVING COUNT(*) > (
        SELECT AVG(enrollment_count)
        FROM (
            SELECT COUNT(*) AS enrollment_count
            FROM enrollments_1
            GROUP BY course_id
        ) AS sub
    )
);

-- Students who scored above the average grade in their course
SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM enrollments_1 e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE (
    CASE e.grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
    END
) > (
    SELECT AVG(
        CASE grade
            WHEN 'A' THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B' THEN 3.0
            WHEN 'B-' THEN 2.7
        END
    )
    FROM enrollments_1
    WHERE course_id = e.course_id
);

-- Rank courses by number of enrollments
SELECT c.course_name, COUNT(e.enrollment_id) AS times_enrolled,
       RANK() OVER (ORDER BY COUNT(e.enrollment_id) DESC) AS course_rank
FROM enrollments_1 e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- Rank students by number of courses taken
SELECT s.first_name, s.last_name, COUNT(e.enrollment_id) AS course_count,
       RANK() OVER (ORDER BY COUNT(e.enrollment_id) DESC) AS student_rank
FROM enrollments_1 e
JOIN students s ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name;

-- Use ROW_NUMBER() to assign sequence of enrollments per student
SELECT s.first_name, s.last_name, e.enrollment_id, e.enroll_date,
       ROW_NUMBER() OVER (PARTITION BY s.student_id ORDER BY e.enroll_date) AS enrollment_number
FROM enrollments_1 e
JOIN students s ON e.student_id = s.student_id;

-- Use a CTE to find students with more than 3 enrollments
WITH student_enroll_count AS (
    SELECT student_id, COUNT(*) AS enroll_count
    FROM enrollments_1
    GROUP BY student_id
)
SELECT s.first_name, s.last_name, se.enroll_count
FROM student_enroll_count se
JOIN students s ON se.student_id = s.student_id
WHERE se.enroll_count > 3
ORDER BY se.enroll_count DESC;