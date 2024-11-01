-- 1
SELECT
        (SELECT name FROM regions WHERE uuid = cities.region) AS region_name,
        SUM(population) AS total_population
FROM cities
GROUP BY region;

-- 2
SELECT
        (SELECT regions.name FROM regions WHERE regions.uuid = cities.region) AS region_name,
        SUM(population) AS total_population
FROM cities
GROUP BY region
HAVING COUNT(name) >= 10;

-- 3
SELECT name, population
FROM cities
WHERE region IN (
        SELECT uuid
        FROM regions
        WHERE area_quantity >= 5
)
ORDER BY population
LIMIT 5 OFFSET 10;

-- 4
SELECT
        (SELECT regions.name FROM regions WHERE regions.uuid = cities.region) AS region_name,
        SUM(population) AS total_population
FROM cities
WHERE population > 300000
GROUP BY region_name;

-- 5
SELECT name, population
FROM cities
WHERE
        (population < 150000 OR population > 500000)
        AND region IN (
                SELECT uuid
                FROM regions
                WHERE NOT area_quantity > 5
        )
