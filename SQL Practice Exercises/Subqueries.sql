-- Example 1
SELECT *
FROM city
WHERE area = (
  SELECT
    area
  FROM city
  WHERE name = 'Paris'
);