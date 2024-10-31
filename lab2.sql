-- 1
SELECT id, name, population
FROM cities
WHERE population >= 1000000;

-- 2
SELECT *
FROM cities
WHERE region = 'E' OR region = 'W'
ORDER BY population;

-- 3
SELECT *
FROM cities
WHERE population > 50000 AND region IN ('S','C','N');

-- 4
SELECT *
FROM cities
WHERE population BETWEEN 150000 AND 350000 AND region IN ('E', 'W', 'N')
ORDER BY name
LIMIT 20;

-- 5
SELECT *
FROM cities
WHERE NOT region IN ('E','W')
ORDER BY population
LIMIT 10 OFFSET 10