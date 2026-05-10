-- Challenge 1
SELECT
  description,
  price,
  RANK() OVER(ORDER BY price) AS ranking
FROM room_type
ORDER BY price ASC;

-- Challenge 2
SELECT
  description,
  max_capacity,
  price,
  DENSE_RANK() OVER(PARTITION BY max_capacity ORDER BY price) AS ranking
FROM room_type
ORDER BY max_capacity, ranking;

-- Challenge 3
SELECT
  payment_date,
  SUM(total_price) AS day_sum,
  LAG(SUM(total_price)) OVER(ORDER BY payment_date) AS previous_day_sum,
  SUM(total_price) - LAG(SUM(total_price)) OVER(ORDER BY payment_date) AS day_over_day_difference
FROM booking
GROUP BY payment_date;

-- Challenge 4
SELECT
  payment_date,
  SUM(total_price) AS day_sum,
  LAG(SUM(total_price)) OVER(ORDER BY payment_date) AS previous_day_sum,
  ROUND(SUM(total_price)*100 / LAG(SUM(total_price)) OVER(ORDER BY payment_date), 2) 
    AS day_by_day_difference_percentage
FROM booking
GROUP BY payment_date;

-- Challenge 5
SELECT
  payment_date,
  total_price,
  SUM(total_price) OVER(ORDER BY payment_date RANGE UNBOUNDED PRECEDING) AS running_total
  FROM booking;