-- ## Ranking Functions ##

-- Simple ranking
SELECT
  name,
  genre, 
  updated,
  RANK() OVER(ORDER BY updated)
FROM game

-- Simple DENSE_RANK()
SELECT
  name,
  size, 
  DENSE_RANK() OVER(ORDER BY size)
FROM game

-- ROW_NUMBER() is nondeterministic
SELECT
  name,
  released,
  ROW_NUMBER() OVER(ORDER BY released)
FROM game

-- Add a sort clause
SELECT
  name,
  genre,
  released,
  DENSE_RANK() OVER(ORDER BY released DESC)
FROM game;

-- ORDER BY two columns
SELECT
  name,
  released,
  updated,
  ROW_NUMBER() OVER(ORDER BY released DESC, updated DESC)
FROM game;

-- sort the window function output
SELECT
  name,
  genre,
  RANK() OVER (ORDER BY size)
FROM game
ORDER BY released DESC;

-- Distribute rows using NTILE()
SELECT 
  name,
  genre,
  size,
  NTILE(4) OVER(ORDER BY size DESC)
FROM game

-- Find nth value
WITH cte AS (
SELECT
  name,
  genre,
  size,
  RANK() OVER(ORDER BY size ASC)
FROM game 
  )
SELECT name,
  genre,
  size
FROM cte
WHERE rank = 1