-- OVER() all rows of the table
SELECT
first_name,
last_name,
salary,
SUM(salary) OVER()
FROM employee

-- Filter on department and apply window function
SELECT
  first_name,
  last_name,
  salary,
  salary - AVG(salary) OVER() as difference
FROM purchase
WHERE department_id = 3;

-- Count number of employees per employee (not meaningful)
SELECT
  first_name,
  last_name,
  salary,
  COUNT(id) OVER()
FROM employee
WHERE salary > 4000

-- Compare max purchase price of the department with each purchase price
SELECT
  id,
  department_id,
  item,
  price,
  MAX(price) OVER(),
  MAX(price) OVER() - price AS difference
FROM purchase
WHERE department_id = 3;

-- Two window functions
SELECT
  id,
  item,
  price,
  AVG(price) OVER(),
  SUM(price) OVER()
FROM purchase;

-- Window Function across multiple departments
SELECT
  first_name,
  last_name,
  salary,
  AVG(salary) OVER()
FROM employee
WHERE department_id IN (1,2,3)


-- Window after joining two tables
SELECT
  p.id,
  name,
  item,
  price,
  MIN(price) OVER(), 
  price - MIN(price) OVER()
FROM purchase p
JOIN department d
ON d.id = p.department_id


-- ## PARTITION BY ## --
-- Number of journeys per date
SELECT 
  id, 
  date,
  COUNT(route_id) OVER(PARTITION BY date)
FROM journey

-- Fiter and count with PARTITION BY
SELECT
  id, 
  model,
  first_class_places, 
  second_class_places,
  COUNT(id) OVER(PARTITION BY model)
FROM train
WHERE first_class_places > 30 
  AND second_class_places > 180
  
-- PARTITION BY multiple columns
SELECT 
  journey.id,
  date,
  model,
  max_speed,
  MAX(max_speed) OVER(PARTITION BY route_id, date)
FROM journey
JOIN train
ON train.id = journey.train_id

-- Multiple window functions
SELECT 
  journey.id,
  train.production_year,
  COUNT(journey.id) OVER(PARTITION BY train_id) AS journeys_by_train,
  COUNT(journey.id) OVER(PARTITION BY route_id) AS journeys_by_route
FROM journey
JOIN train
ON train.id = journey.train_id

-- Window function with excluding one value
SELECT 
  ticket.id,
  price,
  date,
  AVG(price) OVER(PARTITION BY date),
  COUNT(ticket.id) OVER(PARTITION BY date)
FROM ticket
JOIN journey
ON ticket.journey_id = journey.id
WHERE train_id <> 5

-- Division in a window function
SELECT
  id,
  price,
  price / SUM(price) OVER(PARTITION BY journey_id)::numeric AS ratio
FROM ticket