-- 1
SELECT UPPER(name) AS up_name
FROM cities
ORDER BY name
LIMIT 5 OFFSET 5;

-- 2
SELECT name, LENGTH(name) AS name_len
FROM cities
WHERE NOT LENGTH(name) IN (8,9,10);

-- 3
SELECT COUNT(population) AS pop_in_regions
FROM cities
WHERE region IN ('C','W');

-- 4
SELECT AVG(population) AS avg_pop_in_region
FROM cities
WHERE region = 'W';

-- 5
SELECT COUNT(name) AS number_of_cities
FROM cities
WHERE region = 'E';
