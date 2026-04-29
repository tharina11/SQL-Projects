-- Simple CASE WHEN 1
SELECT
  name,
  CASE place_limit
    WHEN 5 THEN 'few places'
    WHEN 10 THEN 'average number of places'
    WHEN 15 THEN 'numerous places'
    ELSE 'other'
  END 
FROM course;

-- Simple CASE WHEN 2
SELECT
 candidate_id,
 course_id,
 CASE status
   WHEN 'accepted' THEN 1
   ELSE 0 END 
   AS accepted
FROM application;

-- Simple CASE WHEN 3
SELECT
  id,
  preferred_contact,
  CASE preferred_contact
    WHEN 'mail' THEN 'traditional'
    WHEN 'mobile' THEN 'modern'
    WHEN 'e-mail' THEN 'modern'
    ELSE 'other' 
    END 
FROM candidate;

-- Simple CASE WHEN 4
SELECT
  name,
  first_name,
  last_name,
  CASE fee
    WHEN 50 THEN 'high'
    ELSE 'low'
  END AS fee_information
FROM course
JOIN application 
ON course.id = application.course_id
JOIN candidate
ON application.candidate_id = candidate.id
ORDER BY name DESC;


-- ## Searched CASE WHEN ##
-- Example 1
SELECT
  first_name,
  last_name,
  CASE 
    WHEN score_language > 80 THEN 'amazing linguist'
    WHEN score_language > 50 THEN 'can speak a bit'
    ELSE 'cannot speak a word' 
  END AS language_skills
FROM candidate;

-- Example 2
SELECT
  first_name,
  last_name,
  CASE 
    WHEN score_math + score_language >= 150 THEN 'excellent'
    WHEN score_math + score_language BETWEEN 100 AND 149 THEN 'good'
    ELSE 'poor'
  END AS overall_result
FROM candidate;

-- With NULL 1
SELECT
  first_name,
  last_name,
  CASE 
    WHEN preferred_contact IS NULL THEN 'not provided' 
    WHEN preferred_contact IS NOT NULL THEN 'provided'
  END AS contact_info
FROM candidate;

-- With NULL 2
SELECT
  id,
  score_math,
  CASE
    WHEN score_math > 60 THEN 'above average' 
    WHEN score_math <= 60 THEN 'below average'
    ELSE 'not available' 
  END AS result
FROM candidate;

-- Search CASE WHEN 5
SELECT
  name,
  first_name,
  last_name,
  CASE
    WHEN score_math > 80 THEN 'qualified'
    WHEN score_math > 70 
      AND score_language > 50 THEN 'qualified'
    WHEN score_math BETWEEN 50 AND 70 THEN 'possible'
    ELSE 'rejected'
  END AS qualification
FROM course
JOIN application
  ON course.id = application.course_id
JOIN candidate
  ON application.candidate_id = candidate.id
WHERE course.id = 3;

--## CASE WHEN with aggreagations ##
-- Example 1
SELECT
  SUM(CASE WHEN pay_date = '2015-06-03' THEN fee ELSE 0 END) AS june_3rd,
  SUM(CASE WHEN pay_date = '2015-06-04' THEN fee ELSE 0 END) AS june_4th
FROM application;

-- Example 2
SELECT
  SUM(CASE WHEN fee = 50 THEN 1 ELSE 0 END) AS full_fee_sum,
  SUM(CASE WHEN fee = 10 THEN 1 ELSE 0 END) AS reduced_fee_sum,
  SUM(CASE WHEN fee = 0 THEN 1 ELSE 0 END) AS free_sum, 
  SUM(CASE WHEN fee IS NULL THEN 1 ELSE 0 END) AS null_fee_sum
FROM application;

-- Example 3
SELECT 
  SUM(CASE WHEN preferred_contact = 'mobile' THEN 1 ELSE 0 END) AS mobile_sum,
  SUM(CASE WHEN preferred_contact = 'e-mail' THEN 1 ELSE 0 END) AS email_sum,
  SUM(CASE WHEN preferred_contact = 'mail' THEN 1 ELSE 0 END) AS mail_sum,
  SUM(CASE WHEN preferred_contact IS NULL THEN 1 ELSE 0 END) AS null_sum
FROM candidate
WHERE score_math >= 30 AND score_language >= 30;

-- Example 4
SELECT
  COUNT(CASE WHEN scholarship = 't' THEN scholarship END) AS scholarship_present,
  COUNT(CASE WHEN scholarship = 'f' THEN scholarship END) AS scholarship_missing
FROM course;