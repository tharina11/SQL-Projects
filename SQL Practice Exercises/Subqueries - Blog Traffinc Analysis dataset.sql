-- Explore data 1
SELECT
  first_name,
  last_name,
  name AS category,
  COUNT(*) AS articles_number
FROM author
JOIN article
  ON author.id = article.author_id
JOIN article_category
  ON article.article_category_id = article_category.id
GROUP BY first_name, last_name, category
ORDER BY last_name, first_name

-- Traffic for article categories in May 2020
WITH cte AS (
SELECT 
  name AS category,
  article_traffic.views,
  visit_date
FROM article_category
JOIN article
  ON article_category.id = article.article_category_id
JOIN article_traffic
  ON article.url = article_traffic.url
)
SELECT 
  category,
  SUM(views) AS total_traffic
FROM cte
WHERE visit_date >= '2020-05-01' 
  AND visit_date < '2020-06-01'
GROUP BY category
  ;

-- Articles of a specific category
SELECT
  title
FROM article
WHERE article_category_id = (
  SELECT
    article_category_id
  FROM article
  WHERE title = 'Dog Toys Cheat Sheet')
  
-- Articles with less traffic than average
SELECT
  title,
  SUM(views) AS total_views
FROM article
JOIN article_traffic 
  ON article.url = article_traffic.url
GROUP BY title
  HAVING SUM(views) < (
    SELECT
      SUM(views)/ COUNT(DISTINCT url)
    FROM article_traffic
  )
  
-- Percentage of authors without any article
WITH cte AS (
SELECT
  author_id,
  url
FROM author
LEFT JOIN article
ON author.id = article.author_id
ORDER BY author_id
)
  SELECT
    ROUND((
      SELECT COUNT(*)
      FROM author
      LEFT JOIN article     
        ON author.id = article.author_id
      WHERE url IS NULL
    )* 100.0 / COUNT(*) ,2) AS percentage
  FROM author;
    
-- Date of the highest views
WITH cte AS(
  SELECT
    title,
    views,
    visit_date
  FROM article
  JOIN article_traffic 
    ON article.url = article_traffic.url
  WHERE title = 'Best Dog Camping Equipment'
  )
    SELECT
      visit_date,
      views
    FROM cte
    WHERE views = (
      SELECT
        MAX(views)
      FROM cte);
	  
-- 
WITH cte AS (
SELECT
  title,
  SUM(views) AS total_views
FROM article
JOIN product_category
  ON article.article_category_id = product_category.id
JOIN article_product_traffic
  ON article.url = article_product_traffic.article_url
WHERE name = 'Product' OR name = 'Bundle' 
GROUP By title)

  SELECT
    title,
    total_views
  FROM cte
WHERE total_views >= ALL (SELECT
   total_views
  FROM cte);
  
-- Date of highest traffic for each article
SELECT
  title,
  visit_date,
  views
FROM article
JOIN article_traffic t1
  ON article.url = t1.url
WHERE views = (
    SELECT
      MAX(views)
    FROM article_traffic t2
    WHERE t1.url = t2.url);

-- Add last 3 exercises