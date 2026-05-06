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