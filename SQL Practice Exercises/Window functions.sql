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