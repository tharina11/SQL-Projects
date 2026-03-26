-- LEAD() example
SELECT
  day,
  users,
  LEAD(users) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 1

-- day-to-day calculation with LEAD()
SELECT
  day,
  revenue,
  LEAD(revenue) OVER(ORDER BY day),
  LEAD(revenue) OVER(ORDER BY day) - revenue AS difference
FROM statistics
WHERE website_id = 1

-- LEAD() with two parameters and day filter
SELECT
  day,
  users,
  LEAD(users, 7) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 2
AND day BETWEEN '2016-05-01' AND '2016-05-14'

-- Fill null values with -1 in the result of the query above
SELECT
  day,
  users,
  LEAD(users,7, -1) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 2
  AND day BETWEEN '2016-05-01' AND '2016-05-14';
  
-- LAG() Example
SELECT
  day,
  clicks,
  LAG(clicks) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 3

-- LAG example 2
SELECT
  day,
  revenue,
  LAG(revenue,3) OVER(ORDER BY day)
FROM statistics
WHERE website_id= 3;

-- LAG Example 3
SELECT
  day,
  revenue,
  LAG(revenue,3, -1.00) OVER(ORDER BY day)
FROM statistics
WHERE website_id= 3;

-- LEAD example 4
SELECT
  day,
  (revenue/impressions) * 1000 AS RPM,
  LEAD(revenue / impressions, 7) OVER(ORDER BY day) * 1000 AS RPM_7
FROM statistics
WHERE website_id= 2;

-- LAG Example 5
SELECT
  day,
  clicks,
  impressions,
  (clicks::numeric / impressions)* 100 AS conversion,
  LAG((clicks::numeric / impressions) * 100) OVER(ORDER BY day) AS previous_conversion
FROM statistics
WHERE website_id= 1
  AND day BETWEEN '2016-05-15' AND '2016-05-31';