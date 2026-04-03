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
  
 -- FIRST_VALUE() example
 SELECT
  day,
  users,
  FIRST_VALUE(users) OVER(ORDER BY users)
FROM statistics
 WHERE website_id = 2;
 
 -- FIRST_VALUE() example 2
 SELECT
  day,
  revenue,
  FIRST_VALUE(revenue) OVER(ORDER BY day)
FROM statistics
 WHERE website_id = 3;
 
 -- LAST_VALUE() example. Simply LAST_VALUE(..) OVER(ORDER BY) does not work
 -- This assumes RANGE UNBOUNDED PRECEDING
 SELECT
  name,
  opened,
  LAST_VALUE(opened) OVER(
    ORDER BY opened
    ROWS BETWEEN UNBOUNDED PRECEDING
      AND UNBOUNDED FOLLOWING)
FROM website;

-- LAST_VALUE() example 2
SELECT
  day,
  impressions,
  LAST_VALUE(impressions) OVER(
  							ORDER BY users 
  							ROWS BETWEEN UNBOUNDED PRECEDING
  							AND UNBOUNDED FOLLOWING)
FROM statistics
WHERE website_id = 1

-- LAST_VALUE() example 3
SELECT
  day,
  users,
  LAST_VALUE(users) OVER(
  						ORDER BY day 
  						ROWS BETWEEN UNBOUNDED PRECEDING
  						AND UNBOUNDED FOLLOWING),
  users - LAST_VALUE(users) OVER(
  						ORDER BY day 
  						ROWS BETWEEN UNBOUNDED PRECEDING
  						AND UNBOUNDED FOLLOWING)
FROM statistics
WHERE website_id = 1

-- Third highest value using NTH_VALUE()
SELECT
  day,
  revenue,
  NTH_VALUE(revenue, 3) OVER(
    ORDER BY revenue DESC 
    ROWS BETWEEN UNBOUNDED PRECEDING
      AND UNBOUNDED FOLLOWING)
  FROM statistics
WHERE website_id= 2
  AND day BETWEEN '2016-05-15' AND '2016-05-31';
  
-- Practice exercise 1
SELECT
  website_id,
  revenue,
  FIRST_VALUE(revenue) OVER(ORDER BY revenue DESC) AS highest_revenue,
  LAST_VALUE(revenue) OVER(ORDER BY revenue DESC 
   ROWS BETWEEN UNBOUNDED PRECEDING
      AND UNBOUNDED FOLLOWING) AS lowest_revenue
  FROM statistics
  WHERE day = '2016-05-14';
  
  
  -- Meadian value of the month
  SELECT
  day,
  clicks,
  NTH_VALUE(clicks, 16) OVER(ORDER BY clicks DESC 
   ROWS BETWEEN UNBOUNDED PRECEDING
      AND UNBOUNDED FOLLOWING)
  FROM statistics
WHERE website_id = 1;

-- ratio calculation with FIRST_VALUE
SELECT
  day,
  clicks,
  ROUND((clicks / FIRST_VALUE(clicks) OVER(
    ORDER BY clicks DESC)::numeric) * 100)
FROM statistics
WHERE website_id = 3;


-- Quiz exercise 1
SELECT 
  day,
  price,
  LEAD(price) OVER()
FROM advertisement

-- Quiz exercise 2
SELECT 
  day,
  price,
  LAG(price, 7) OVER(),
  price - LAG(price, 7) OVER()
FROM advertisement

-- Quiz exercise 3
SELECT 
  day,
  price,
  FIRST_VALUE(price) OVER(ORDER BY price DESC) AS highest_price,
  FIRST_VALUE(price) OVER(ORDER BY price) AS lowest_price
FROM advertisement