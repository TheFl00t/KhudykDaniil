-- 1
SELECT cities.name, regions.name AS region_name,  population
FROM cities
INNER JOIN regions ON cities.region = regions.uuid
WHERE population > 350000

-- 2
SELECT cities.name, regions.name AS region_name
FROM cities, regions
WHERE regions.name = 'Nord' AND cities.region = regions.uuid