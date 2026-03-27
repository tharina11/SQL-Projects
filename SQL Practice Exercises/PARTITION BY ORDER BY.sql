-- Simple example
SELECT
  store_id,
  day,
  revenue,
  AVG(revenue) OVER(PARTITION BY store_id)
FROM sales;

-- Example 2 PARTITION BY
SELECT
  store_id,
  day,
  transactions,
  SUM(transactions) OVER(PARTITION BY day),
  ROUND(transactions::numeric / SUM(transactions) OVER(PARTITION BY day)*100)
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-07';

-- PARTITION BY ORDER BY example
SELECT
  store_id,
  day,
  customers,
  RANK() OVER(PARTITION BY store_id ORDER BY customers DESC)
FROM sales
WHERE day BETWEEN '2016-08-10' AND '2016-08-14';

-- Divide sales in each store into percentile labels
SELECT
  store_id,
  day,
  revenue,
  NTILE(4) OVER(PARTITION BY store_id ORDER BY revenue DESC)
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-10'

-- The best day in terms of revenue for each store
WITH ranking AS (
  SELECT
    store_id,
    revenue,
    day,
    RANK() OVER(PARTITION BY store_id ORDER BY revenue DESC) AS rank
  FROM sales
)

SELECT
  store_id,
  revenue,
  day
FROM ranking
WHERE rank = 1;

-- Rank with ROW_NUMBER()
SELECT
  store_id,
  day,
  transactions,
  ROW_NUMBER() OVER(PARTITION BY day ORDER BY transactions DESC) AS place_no
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-03'

-- store with best revenue per day
WITH ranking AS (
  SELECT
    day,
    store_id,
    revenue,
    RANK() OVER(PARTITION BY day ORDER BY revenue DESC) AS rank
  FROM sales
)
SELECT
  day,
  store_id,
  revenue
FROM ranking
WHERE rank = 1;

-- Categorize sales results into 4 groups based on transactions
WITH ranking AS (
  SELECT
  store_id,  
  day,
  transactions,
  NTILE(4) OVER(PARTITION BY store_id ORDER BY transactions) AS rank
  FROM sales
)

SELECT
  store_id,  
  day,
  transactions
FROM ranking
WHERE rank = 1;

-- Add range in window frame
SELECT
  store_id,
  day,
  revenue,
  MAX(revenue) OVER(
    PARTITION BY store_id
    ORDER BY day
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-07';

-- Window frame example 2
SELECT
  store_id,
  day,
  transactions,
  AVG(transactions) OVER(
    PARTITION BY store_id
    ORDER BY day
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-10';

-- Calculate future cash flow receivable per store
SELECT
  store_id,
  day,
  revenue,
  SUM(revenue) OVER(
    PARTITION BY store_id
    ORDER BY day
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM sales;


-- Analytical functions example 1
SELECT
  store_id,
  day,
  transactions,
  LAG(transactions) OVER(PARTITION BY store_id ORDER BY day),
  transactions - LAG(transactions) OVER(PARTITION BY store_id ORDER BY day)
FROM sales
  WHERE day BETWEEN '2016-08-05' AND '2016-08-10';
  
-- Analytical function example 2
SELECT
  store_id,
  day,
  revenue,
  FIRST_VALUE(day) OVER(PARTITION BY store_id ORDER BY revenue DESC) AS best_revenue_day
FROM sales
WHERE day BETWEEN '2016-08-01' AND '2016-08-03';

-- Analytical example 3
SELECT
  store_id,
  day,
  revenue,
  LAG(revenue, 7) OVER(PARTITION BY store_id ORDER BY day),
  ROUND((revenue ::numeric/ LAG(revenue, 7) OVER(PARTITION BY store_id ORDER BY day) * 100), 2)
FROM sales;

-- Analytical example 4
SELECT
  store_id,
  day,
  customers,
  NTH_VALUE(customers, 5) OVER(
  							PARTITION BY day ORDER BY customers DESC 
  							ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM sales;

-- Quiz exercise 1
WITH ranking AS (
SELECT 
  day,
  phone,
  DENSE_RANK() OVER(PARTITION BY day ORDER BY free_repairs DESC) AS rank
FROM repairs
  ) 
SELECT 
  day,
  phone
FROM ranking
WHERE rank = 2

-- Quiz exercise 2
SELECT
  phone,
  day,
  revenue,
  NTH_VALUE(revenue, 1) OVER(PARTITION BY phone ORDER BY day) AS first_revenue
FROM repairs

-- Quiz exercise 3
SELECT
  phone,
  day,
  paid_repairs,
  LAG(paid_repairs) OVER(PARTITION BY phone ORDER BY day),
  paid_repairs - LAG(paid_repairs) OVER(PARTITION BY phone ORDER BY day)
FROM repairs
