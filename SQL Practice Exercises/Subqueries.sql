-- # Scalar Subqueries #

-- Example 1
SELECT *
FROM city
WHERE area = (
  SELECT
    area
  FROM city
  WHERE name = 'Paris'
);

-- Example 2
SELECT
  name
FROM city
WHERE population < (
  SELECT population
  FROM city
  WHERE name = 'Madrid')
  
-- Subquery with a function
SELECT
  *
FROM trip
WHERE price > (
  SELECT AVG(price)
  FROM trip);
  
 -- Subquery with a function 2
 SELECT *
FROM hiking_trip
WHERE difficulty IN (1,2,3)

-- Subquery with IN and a function
SELECT *
FROM trip
WHERE city_id IN (
  SELECT id
  FROM city
  WHERE area > 100)
  
 -- Cities that are less populated that all the countries in the database
 SELECT *
FROM city
WHERE population < ALL (
  SELECT population
  FROM country
);

-- All the city trips that have the same price as any hiking trip
SELECT *
FROM trip
WHERE price = ANY (
  SELECT price
  FROM hiking_trip
);

-- Correlated subquery 1
SELECT *
FROM country
WHERE population < (
  SELECT min(population)
  FROM city
  WHERE country.id = city.country_id)