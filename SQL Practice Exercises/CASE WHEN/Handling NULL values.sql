-- Exploration 1
SELECT name
FROM product
WHERE launch_date IS NOT NULL;

-- NULL vs non-equality
SELECT 
  name
FROM product
WHERE price != 299.99 
OR price IS NULL;