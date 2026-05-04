-- Date format
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced = '2008-04-06'
OR produced = '2010-03-01';

-- With logical operators
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced > '2012-12-31';

-- BETWEEN
SELECT
  id,
  date
FROM flight
WHERE date NOT BETWEEN '2015-01-01' AND '2015-12-31';

-- Ordered
SELECT
  id,
  date
FROM flight
WHERE date BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY date DESC

--  Example 1
SELECT DISTINCT
  aircraft.id,
  produced,
  route.code AS route_code
FROM aircraft
JOIN flight
  ON aircraft.id = flight.aircraft_id
JOIN route
  ON flight.route_code = route.code
WHERE produced BETWEEN '2010-01-01' AND '2010-12-31';

-- Time
SELECT
  code
FROM route
WHERE arrival = '09:30:00';

-- BETWEEN 
SELECT
  code
FROM route
WHERE departure BETWEEN '11:00:00' AND '17:00:00';

-- Ordered
SELECT
  code,
  arrival
FROM route
WHERE arrival < '16:00:00'
ORDER BY arrival;

-- Average
SELECT
  AVG(distance) AS average
FROM route
WHERE departure > '8:00:00'

-- Timestamp 1
SELECT
  current_date,
  current_time,
  current_timestamp;

-- Timestamp 2
SELECT
  aircraft.id AS aircraft_id,
  AVG(distance) AS average
FROM aircraft
JOIN flight
ON aircraft.id = flight.aircraft_id
JOIN route
ON flight.route_code = route.code
WHERE launched < '2014-01-01'
GROUP BY aircraft.id
HAVING COUNT(aircraft.id) > 1

-- EXTRACT
SELECT EXTRACT(MONTH FROM withdrawn) AS month,
  withdrawn
FROM aircraft;

-- EXTRACT 2
SELECT
  code,
  EXTRACT(HOUR FROM departure) || '.' || EXTRACT(MIN FROM departure) AS time
FROM route;

-- EXTRACT 3
SELECT
  id,
  date,
  EXTRACT(HOUR FROM date) AS hour
FROM flight;

-- Timezone 1
SELECT departure AT TIME ZONE 'Europe/Warsaw' AS local_time
FROM route
WHERE from_airport = 'KEF'
  AND to_airport = 'GDN';
  
-- Timezone 2
SELECT
  route.code,
  departure AT TIME ZONE 'Asia/Tokyo' AS local_departure,
  arrival AT TIME ZONE 'Asia/Tokyo' AS local_arrival
FROM route
WHERE distance > 600;

-- INTERVAL 1
SELECT
  id,
  withdrawn,
  withdrawn + INTERVAL '1-6' YEAR TO MONTH AS changed_date
FROM aircraft
WHERE id = 5;

-- INTERVAL 2
SELECT
  launched,
  launched - INTERVAL '14 8:41:16' DAY TO SECOND AS test_date
FROM aircraft
WHERE id = 4;

-- INTERVAL 3
SELECT
  code,
  departure + INTERVAL '1' HOUR AS new_departure,
  arrival + INTERVAL '1' HOUR AS new_arrival
FROM route
WHERE departure > '13:00:00';

-- Interval 4
SELECT '2015-01-01' + INTERVAL '5' DAY;

-- INTERVAL with comparison 1
SELECT id,
    model
FROM aircraft
WHERE produced >= '2014-01-01'
  AND produced < CAST('2016-01-01' AS date) + INTERVAL '1' YEAR;
  
-- INTERVAL with comparison 2
SELECT COUNT(id) AS flight_no
FROM flight
WHERE date >= '2015-08-01'
  AND date < CAST('2015-08-01' AS date) + INTERVAL '1' MONTH;

-- INTERVAL 3
SELECT id
FROM aircraft
WHERE produced < CURRENT_DATE - INTERVAL '3' MONTH;

-- Exercise 1
SELECT
  code,
  from_airport,
  to_airport
FROM route
WHERE departure BETWEEN '9:00:00' AND '15:00:00';

-- Exercise 2
SELECT
  from_airport,
  to_airport,
  model
FROM route
JOIN flight
  ON route.code = flight.route_code
JOIN aircraft
  ON flight.aircraft_id = aircraft.id
WHERE flight.date = '2015-07-11';

-- Exercise 3
SELECT
   AVG(delay)
FROM flight
WHERE EXTRACT(MONTH FROM date) = '08';

-- Exercise 4
SELECT
  code,
  COUNT(flight.id) AS count,
  AVG(delay) AS avg
FROM route
JOIN flight
  ON route.code = flight.route_code
WHERE date < CURRENT_DATE - INTERVAL '6' MONTH
GROUP By code;

-- Exercise 5
SELECT
  EXTRACT(YEAR FROM date) AS year,
  AVG(delay) as avg
FROM flight
GROUP BY EXTRACT(YEAR FROM date);

-- Exercise 6
SELECT COUNT(DISTINCT aircraft_id) AS aircraft_no
FROM flight
WHERE date BETWEEN '2015-08-01' AND '2015-09-01';