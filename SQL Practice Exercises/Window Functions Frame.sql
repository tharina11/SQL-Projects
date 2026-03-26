-- Unbounded preceding window
SELECT
  id,
  placed,
  COUNT(id) OVER(ORDER BY placed ROWS UNBOUNDED PRECEDING) 
FROM single_order

-- Cumulative with unbounded following
SELECT
  id,
  product_id,
  quantity,
SUM(quantity) OVER(ORDER BY id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM order_position
WHERE order_id = 5

-- Cumulative with unbounded following
SELECT
  id,
  name,
  introduced,
  COUNT(id) OVER(ORDER BY introduced DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM product

-- Bounded calculation with ratio
SELECT
  placed,
  total_price,
  AVG(total_price) OVER(ORDER BY placed ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING),
  total_price / AVG(total_price) OVER(ORDER BY placed ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS ratio
FROM single_order

-- Abbreviated window
SELECT
  id,
  changed,
  quantity,
  SUM(quantity) OVER(ORDER BY changed ROWS UNBOUNDED PRECEDING)
FROM stock_change
WHERE product_id = 3

-- Running average of current and three previous orders
SELECT
  placed,
  total_price,
  AVG(total_price) OVER(ORDER BY placed ROWS 3 PRECEDING)
FROM single_order

-- Average total price for single day
SELECT
  id,
  placed,
  total_price,
  AVG(total_price) OVER(ORDER BY placed RANGE CURRENT ROW)
FROM single_order;

-- COUNT for single day
SELECT 
  id,
  quantity,
  changed,
  COUNT(id) OVER(ORDER BY changed RANGE CURRENT ROW)
FROM stock_change
WHERE product_id = 7

-- Cumulative stock changes over days
SELECT
  id, 
  changed,
  COUNT(id) OVER(ORDER BY changed RANGE UNBOUNDED PRECEDING)
FROM stock_change

-- Cumulative with UNBOUNDED FOLLOWING
SELECT
  id,
  placed,
  total_price,
  SUM(total_price) OVER(ORDER BY placed RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM single_order