-- Explore data 1
SELECT
 country_name,
 MIN(fin.result) AS best_time
FROM event e
JOIN discipline d
  ON e.discipline_id = d.id
JOIN final_result fin
  ON fin.event_id = e.id
JOIN athlete a
  ON a.id = fin.athlete_id
JOIN nationality n
  ON n.id = a.nationality_id
  WHERE d.name = 'Men''s 100m' OR  d.name ='Women''s 100m'
GROUP BY country_name
ORDER BY best_time ASC;

-- Explore data 2
SELECT
  last_name,
  first_name,
  result
FROM athlete
JOIN final_result
  ON athlete.id = final_result.athlete_id
JOIN nationality
  ON nationality.id = athlete.nationality_id
WHERE country_name = 'Kenya' 
AND final_result.place = 2;

-- Above average run time
SELECT 
  result
FROM final_result
JOIN event 
  ON final_result.event_id = event.id
JOIN discipline
ON event.discipline_id = discipline.id
WHERE distance = 1500
AND result < (
  SELECT
    AVG(result)
  FROM final_result
  JOIN event 
    ON final_result.event_id = event.id
  JOIN discipline
    ON event.discipline_id = discipline.id
  WHERE distance = 1500
  );
  
 -- Time better than Usain Bolt's best
 WITH cte AS (
SELECT
  first_name,
  last_name,
  result,
  discipline.name as discipline_name
FROM athlete
JOIN final_result
  ON athlete.id = final_result.athlete_id
JOIN event
  ON final_result.event_id = event.id
JOIN discipline
  ON event.discipline_id = discipline.id)
  SELECT
    first_name,
    last_name,
    result,
    discipline_name
  FROM cte
  WHERE result < (
    SELECT
      MIN(result)
    FROM cte
    WHERE first_name = 'Usain' AND last_name = 'BOLT')
	
-- Athlete with the highest participation
WITH cte AS (
SELECT
  first_name,
  last_name,
  COUNT(result) AS participation_count
FROM athlete
JOIN final_result
  ON athlete.id = final_result.athlete_id
GROUP BY first_name,last_name
)
SELECT 
  first_name,
  last_name,
  participation_count
  FROM CTE
WHERE participation_count = (
  SELECT MAX(participation_count) 
  FROM cte
  )
  
