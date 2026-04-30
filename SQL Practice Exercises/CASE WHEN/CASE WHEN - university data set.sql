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

-- Example 5
SELECT
  COUNT(CASE WHEN score_math >= 80 THEN id END) AS good_math,
  COUNT(CASE WHEN score_math < 80 AND score_math >= 60 THEN id END) AS average_math,
  COUNT(CASE WHEN score_math < 60 THEN id END) AS poor_math
FROM candidate
WHERE preferred_contact IS NOT NULL;

-- Example 6 (with DISTINCT)
SELECT
  COUNT(DISTINCT CASE WHEN fee = 50 THEN candidate_id END) AS full_fee_sum,
  COUNT(DISTINCT CASE WHEN fee = 10 THEN candidate_id END) AS reduced_fee_sum
FROM application;

-- ## CASE WHEN with GROUP BY ##
-- Example 1
SELECT
  course_id,
  COUNT(CASE WHEN status= 'accepted' THEN 1 ELSE 0 END) AS accepted,
  COUNT(CASE WHEN status= 'pending' THEN 1 ELSE 0 END) AS pending,
  COUNT(CASE WHEN status= 'rejected' THEN 1 ELSE 0 END) AS rejected
FROM application
GROUP BY course_id
ORDER BY course_id ASC;

-- Example 2
SELECT
  candidate_id AS id,
  COUNT(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END) AS count_accepted,
  COUNT(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS count_rejected,
  COUNT(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS count_pending
FROM application
GROUP BY candidate_id
ORDER BY candidate_id ASC;

-- Example 3
SELECT
  course_id AS id,
  COUNT(DISTINCT CASE WHEN preferred_contact = 'mobile' THEN candidate_id END) AS count_mobile,
  COUNT(DISTINCT CASE WHEN preferred_contact = 'mail' THEN candidate_id END) AS count_mail
FROM application
JOIN course
  ON application.course_id = course.id
JOIN candidate
  ON application.candidate_id = candidate.id
GROUP BY course_id;

-- Example 4
SELECT
  preferred_contact,
  COUNT(id) AS candidates_count,
  CASE WHEN COUNT(id) > 5 THEN 'high' ELSE 'low' END
    AS rating
FROM candidate
GROUP BY preferred_contact;

-- Example 5
SELECT
  CASE
    WHEN score_language >= 70 THEN 'good score'
    WHEN score_language >= 40 THEN 'average score'
    ELSE 'poor score'
  END,
  COUNT(id)
FROM candidate
GROUP BY CASE
    WHEN score_language >= 70 THEN 'good score'
    WHEN score_language >= 40 THEN 'average score'
    ELSE 'poor score'
END;

-- ## Summary ##
-- Example 1
SELECT
  name,
  CASE 
    WHEN graduate_satisfaction > 80 THEN 'satisfied' 
    WHEN graduate_satisfaction > 50 THEN 'moderately satisfied'
    WHEN graduate_satisfaction <= 50 THEN 'not satisfied'
    END AS satisfaction_level
FROM course;

-- Example 2
SELECT
  SUM(CASE WHEN score_math >= 60 AND score_language >= 60 THEN 1 ELSE 0 END) 
    AS versatile_candidates,
  SUM(CASE WHEN score_math < 40 AND score_language < 40 THEN 1 ELSE 0 END) 
    AS poor_candidates
FROM candidate
WHERE preferred_contact IS NOT NULL
;

-- Example 3
SELECT
  name,
  CASE
    WHEN COUNT(DISTINCT candidate_id) > 5 THEN 'high'
    ELSE 'low' END AS popularity
FROM course
JOIN application
  ON course.id = application.course_id
GROUP BY name;

-- Example 4
SELECT
  name,
  place_limit,
  COUNT(DISTINCT candidate_id) AS candidates_no,
  CASE
   WHEN COUNT(DISTINCT candidate_id) > place_limit THEN 'overcrowded'
   ELSE 'within limit' END AS popularity
FROM course
JOIN application
  ON course.id = application.course_id
GROUP BY name, place_limit;