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
  WHERE country.id = city.country_id);
  
-- Correlated subquery with Alias
SELECT
  *
FROM city main_city
WHERE rating > (
  SELECT
    AVG(rating)
  FROM city avg_city
  WHERE main_city.country_id = avg_city.country_id);
  
-- Subquery with IN
SELECT *
FROM trip
WHERE city_id IN (
  SELECT id
  FROM city
  WHERE rating < 4);
  
-- Subquery with EXISTS
SELECT *
FROM country
WHERE EXISTS (
  SELECT country_id
  FROM mountain
  WHERE country_id = mountain.country_id)
  
-- Subquery with NOT EXISTS
SELECT *
FROM mountain
WHERE NOT EXISTS(
  SELECT mountain_id
  FROM hiking_trip
  WHERE hiking_trip.mountain_id = mountain.id
);

-- Subquery with ALL
SELECT *
FROM hiking_trip main_trip
WHERE length >= ALL (
  SELECT length
  FROM hiking_trip sub_trip
  WHERE main_trip.mountain_id = sub_trip.mountain_id
);

-- Trips those last shorter than any hiking trip with the same price
SELECT *
FROM trip
WHERE days < ANY (
  SELECT days 
  FROM hiking_trip
  WHERE trip.price = hiking_trip.price
);

-- Subquery in FROM clause 1
SELECT *
FROM mountain, (
  SELECT *
  FROM country
  WHERE population >= 50000
  ) AS large_country
WHERE mountain.country_id = large_country.id
;

-- Subquery in FROM clause 2
SELECT 
  length,
  height
FROM hiking_trip, (
  SELECT *
  FROM mountain
  WHERE height >= 3000
  ) AS tall_mountains
WHERE tall_mountains.id = hiking_trip.mountain_id
;

-- Subquery in SELECT clause
SELECT 
  name,
	(SELECT COUNT(*)
	  FROM hiking_trip
	  WHERE hiking_trip.mountain_id = mountain.id) AS count
FROM mountain
;