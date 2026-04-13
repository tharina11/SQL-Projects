-- Example 1
SELECT
  first_name,
  last_name,
  course.title
FROM student
JOIN course_enrollment
 ON student.id = course_enrollment.student_id
JOIN course_edition
  ON course_enrollment.course_edition_id = course_edition.id
JOIN course
  ON course_edition.course_id = course.id
  
-- Lecturers and their courses
SELECT
  first_name,
  last_name,
  title,
  calendar_year,
  term
FROM lecturer
LEFT JOIN course_edition
  ON lecturer.id = course_edition.lecturer_id
LEFT JOIN academic_semester
  ON academic_semester.id = course_edition.academic_semester_id
LEFT JOIN course
  ON course.id = course_edition.course_id;
  
-- students younger than Noel Durrand
SELECT
  first_name,
  last_name,
  birth_date
FROM student
WHERE birth_date > (
  SELECT 
    birth_date
  FROM student
  WHERE first_name = 'Noel' 
  AND last_name = 'Durrand');
  
 -- Grades higher than average of the course
 SELECT
  first_name,
  last_name,
  midterm_grade
FROM student
JOIN course_enrollment
 ON student.id = course_enrollment.student_id
JOIN course_edition
  ON course_enrollment.course_edition_id = course_edition.id
WHERE course_id = 3
AND midterm_grade > (
  SELECT
    AVG(midterm_grade)
  FROM course_enrollment);
  
-- Courses with more lecture hours than average programming path lecture hours
SELECT *
FROM course
WHERE id IN (
SELECT
  id
FROM course
WHERE lecture_hours > (
  SELECT
    AVG(lecture_hours)
  FROM course
  WHERE learning_path = 'Programming')
  );
  
-- Students enrolled in greatest number of courses
SELECT
  student.id AS student_id,
  first_name,
  last_name,
  COUNT(course_edition_id) AS no_of_course_ed
FROM course_enrollment
JOIN student
  ON course_enrollment.student_id = student.id
GROUP BY student.id, first_name, last_name
HAVING COUNT(course_edition_id) >= ALL (
  SELECT
    COUNT(course_edition_id)
  FROM course_enrollment
  GROUP BY student_id);
  
-- Number of students with the same or better grades
SELECT DISTINCT 
  final_grade,
  (SELECT
    COUNT(course_edition_id)
   FROM course_enrollment c2
   WHERE c2.final_grade >= c1.final_grade) AS students_number
FROM course_enrollment c1;

-- Scores above the course edition average
SELECT
  first_name,
  last_name,
  title,
  final_grade
FROM student
JOIN course_enrollment ce1
  ON student.id = ce1.student_id
JOIN course_edition
  ON course_edition.id = ce1.course_edition_id
JOIN course
  ON course.id = course_edition.course_id
WHERE final_grade > (
  SELECT
    AVG(final_grade)
  FROM course_enrollment ce2
  WHERE ce1.course_edition_id = ce2.course_edition_id)
;

-- Average score for each course edition
SELECT
  course_edition_id,
  passed,
  ROUND(AVG(final_grade), 2) AS average_final_grade,
  (SELECT 
    ROUND(AVG(final_grade),2)
  	FROM course_enrollment c2
    WHERE c1.course_edition_id = c2.course_edition_id) AS average_edition_grade
FROM course_enrollment c1
GROUP By course_edition_id, passed

-- Average and count of higer than average scores
SELECT
  title,
  ROUND(AVG(final_grade)) AS average_result,
  COUNT (student_id) AS results_better_than_average
FROM course
JOIN course_edition
  ON course.id = course_edition.course_id
JOIN course_enrollment ce1
  ON course_edition.id = ce1.course_edition_id
WHERE final_grade > (
  SELECT
    AVG(final_grade) AS average_result_per_edition
  FROM course_enrollment ce2
  WHERE ce1.course_edition_id = ce2.course_edition_id
)
GROUP BY 
  course.title;