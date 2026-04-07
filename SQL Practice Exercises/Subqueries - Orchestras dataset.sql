-- concerts number and average rating per country
SELECT 
  orchestras.name,
  concerts.country,
  COUNT(concerts.country) AS concerts_no,
  AVG(concerts.rating) AS avg_rating
FROM orchestras
JOIN concerts
ON orchestras.id = concerts.orchestra_id
GROUP BY orchestras.name, concerts.country
HAVING COUNT(concerts.country) > 1

-- Exercise 2
SELECT
  name
FROM orchestras
WHERE year > (
  SELECT
    year
  FROM orchestras
  WHERE name = 'Chamber Orchestra')
AND rating > 7.5

-- Exercise 2
SELECT
  orchestras.name
FROM orchestras
WHERE city_origin IN (
  SELECT
    concerts.city
  FROM concerts 
  WHERE year = 2013)
;

-- Exercise 3
SELECT
  orchestras.name,
  COUNT(members) AS members_count
FROM members
INNER JOIN orchestras
  ON members.orchestra_id = orchestras.id
GROUP BY orchestra_id,orchestras.name
HAVING COUNT(members) = (
  SELECT
  COUNT(members) AS members_count
  FROM members
  INNER JOIN orchestras
    ON members.orchestra_id = orchestras.id
  GROUP BY orchestras.name
  HAVING orchestras.name = 'Musical Orchestra'
);

-- Average members per orchestra
SELECT
  AVG(members_cnt)
FROM (
  SELECT 
    orchestra_id,
    COUNT(members) AS members_cnt
  FROM members
  GROUP BY orchestra_id) AS counted
;

-- Orchestras with more than average memebers
SELECT 
  orchestras.name,
  COUNT(members.id)
FROM orchestras
JOIN members
ON orchestras.id = members.orchestra_id
GROUP BY orchestras.name
HAVING COUNT(members.id) > (
 SELECT
  AVG(members_cnt)
  FROM (
  SELECT 
    orchestra_id,
    COUNT(members) AS members_cnt
    FROM members
    GROUP BY orchestra_id) AS counted
);

-- Correlated subquery 1
SELECT 
  orchestras.name
FROM orchestras
WHERE country_origin IN (SELECT
        concerts.country
       FROM concerts
       WHERE orchestras.id = concerts.orchestra_id)
;

-- Correlated subquery 2
SELECT
  name,
  wage,
  experience
FROM members m1
WHERE wage = (
  SELECT
 	MAX(wage)
  FROM members m2
  WHERE m1.orchestra_id = m2.orchestra_id)
;

-- Correlated subquery 3
SELECT
  members.name AS member,
  orchestras.name AS orchestra
FROM orchestras
JOIN members
  ON members.orchestra_id = orchestras.id
WHERE members.experience = (
  SELECT
 	MAX(experience)
  FROM members
  WHERE members.orchestra_id = orchestras.id)
;

-- Members who earn more than violinists
SELECT
  name
FROM members m1
WHERE wage > (
  SELECT
    AVG(wage)
  FROM members m2
  WHERE m1.orchestra_id = m2.orchestra_id
    AND position = 'violin')
	
-- German orchestras in Ukraine
SELECT
  name,
  rating,
  city_origin,
  (SELECT 
    COUNT(id)
   FROM concerts
   WHERE country = 'Ukraine'
   AND concerts.orchestra_id = orchestras.id)
FROM orchestras
WHERE country_origin = 'Germany'