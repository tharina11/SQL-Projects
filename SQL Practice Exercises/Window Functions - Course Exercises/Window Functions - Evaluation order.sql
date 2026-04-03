-- Window function in Subquery
SELECT
  id,
  country,
  views 
FROM (
  SELECT
    id,
  	country,
    views,
    AVG(views) OVER() AS avg_views
  FROM auction) c
WHERE views < avg_views

-- Example 2
SELECT
  country,
  AVG(final_price) 
FROM auction 
GROUP BY country
WHERE AVG(final_price) > (SELECT 
  							AVG(final_price) FROM auction)
							
-- Same answer with a window function
WITH cte AS
  (
SELECT 
  country,
  final_price,
  AVG(final_price) OVER() AS avg_overall
FROM auction) 

SELECT 
  country,
  AVG(final_price)
FROM cte
GROUP BY country, avg_overall
HAVING AVG(final_price) > avg_overall

-- Example 3
SELECT
  group_no,
  MIN(asking_price),
  AVG(asking_price),
  MAX(asking_price)
FROM
  (SELECT
    asking_price,
    NTILE(6) OVER(ORDER BY asking_price) AS group_no
  FROM auction) c
GROUP BY group_no
ORDER By group_no;

-- Example 4
SELECT
  id,
  views,
  quartile
FROM
  (SELECT
      id,
      views,
      NTILE(4) OVER(ORDER BY views DESC) AS quartile
    FROM auction) s
ORDER by quartile


-- What window functions see
-- Aggregations with window functions 1
SELECT
  country,
  MIN(participants),
  AVG(MIN(participants)) OVER()
FROM auction
GROUP BY country

-- Aggreagation with window functions 2
SELECT
  category_id,
  MAX(asking_price),
  AVG(MAX(asking_price)) OVER()
FROM auction
GROUP BY category_id

-- Aggreagation with window functions 3
SELECT
  category_id,
  SUM(final_price),
  RANK() OVER(ORDER BY SUM(final_price) DESC)
FROM auction
GROUP BY category_id

-- Aggreagation with window functions 4
SELECT
  ended,
  AVG(views),
  RANK() OVER(ORDER BY AVG(views) DESC)
FROM auction
GROUP BY ended

-- Day-to-day deltas with GROUP BY 1
SELECT
  ended,
  SUM(views),
  LAG(SUM(views)) OVER(ORDER BY ended) AS previous_day,
  SUM(views) - LAG(SUM(views)) OVER(ORDER BY ended) AS delta
FROM auction
GROUP BY ended
ORDER BY ended

-- Day-to-day deltas with GROUP BY 2
SELECT
  category_id,
  ended,
  AVG(final_price) AS daily_avg_final_price,
  MAX(AVG(final_price)) OVER (PARTITION BY category_id) AS daily_max_avg
FROM auction
GROUP BY category_id, ended
ORDER BY category_id, ended

-- Quiz exercise 1
SELECT
  bucket,
  MIN(rating),
  MAX(rating)
FROM (
  SELECT
    id,
    rating,
    NTILE(4) OVER(ORDER BY rating) AS bucket
  FROM book) a
GROUP BY bucket

-- Quiz exercise 2
SELECT 
  author_id,
  COUNT(id) AS number_of_books,
  RANK() OVER(ORDER BY COUNT(id) DESC)
FROM book
GROUP BY author_id

-- Quiz exercise 3
SELECT 
  publish_year,
  COUNT(id),
  LAG(COUNT(id)) OVER(ORDER BY publish_year)
FROM book
GROUP BY publish_year