-- 1
SELECT id, name
FROM cities
WHERE name LIKE '%ськ';

-- 2
SELECT id, name
FROM cities
WHERE name LIKE '%донец%';

-- 3
SELECT id, CONCAT(name, ' (', region, ')') AS new_name, population
FROM cities
WHERE population > 100000
ORDER BY new_name;

-- 4
SELECT id, name, population, (population/40000000)*100 AS pop_per
FROM cities
ORDER BY population
LIMIT 10;

-- 5
SELECT CONCAT(name, ' - ', (population/40000000)*100, '%') AS new_name
FROM cities
WHERE (population/40000000)*100 >= 0.1
ORDER BY (population/40000000)*100;