CREATE DATABASE IF NOT EXISTS airport_data;
USE airport_data;
-- importing data from csv file into database 
SELECT* FROM flight_data;
-- DATA CLEANING 
SELECT * FROM flight_data
WHERE CAST(nsmiles AS UNSIGNED) IS NULL
   OR CAST(passengers AS UNSIGNED) IS NULL
   OR CAST(fare AS DECIMAL(10, 2)) IS NULL
   OR CAST(large_ms AS DECIMAL(10, 4)) IS NULL
   OR CAST(fare_lg AS DECIMAL(10, 2)) IS NULL
   OR CAST(lf_ms AS DECIMAL(10, 4)) IS NULL
   OR CAST(fare_low AS DECIMAL(10, 2)) IS NULL;
SET SQL_SAFE_UPDATES = 0;
UPDATE flight_data
SET nsmiles = NULL
WHERE CAST(nsmiles AS UNSIGNED) IS NULL;

UPDATE flight_data
SET passengers = NULL
WHERE CAST(passengers AS UNSIGNED) IS NULL;

UPDATE flight_data
SET fare = NULL
WHERE CAST(fare AS DECIMAL(10, 2)) IS NULL;

UPDATE flight_data
SET large_ms = NULL
WHERE CAST(large_ms AS DECIMAL(10, 4)) IS NULL;

UPDATE flight_data
SET fare_lg = NULL
WHERE CAST(fare_lg AS DECIMAL(10, 2)) IS NULL;

UPDATE flight_data
SET lf_ms = NULL
WHERE CAST(lf_ms AS DECIMAL(10, 4)) IS NULL;

UPDATE flight_data
SET fare_low = NULL
WHERE CAST(fare_low AS DECIMAL(10, 2)) IS NULL;
DELETE FROM flight_data
WHERE nsmiles IS NULL
   OR passengers IS NULL
   OR fare IS NULL
   OR large_ms IS NULL
   OR fare_lg IS NULL
   OR lf_ms IS NULL
   OR fare_low IS NULL;
   CREATE TABLE flight_data_cleaned (
    tbl VARCHAR(255) NULL,
    Year INT NULL,
    quarter INT NULL,
    citymarketid_1 INT NULL,
    citymarketid_2 INT NULL,
    city1 VARCHAR(255) NULL,
    city2 VARCHAR(255) NULL,
    airportid_1 INT NULL,
    airportid_2 INT NULL,
    airport_1 VARCHAR(10) NULL,
    airport_2 VARCHAR(10) NULL,
    nsmiles INT NULL,
    passengers INT NULL,
    fare DECIMAL(10, 2) NULL,
    carrier_lg VARCHAR(10) NULL,
    large_ms DECIMAL(10, 4) NULL,
    fare_lg DECIMAL(10, 2) NULL,
    carrier_low VARCHAR(10) NULL,
    lf_ms DECIMAL(10, 4) NULL,
    fare_low DECIMAL(10, 2) NULL,
    Geocoded_City1 VARCHAR(100) NULL,
    Geocoded_City2 VARCHAR(100) NULL,
    tbl1apk VARCHAR(50) NULL
);
INSERT INTO flight_data_cleaned (tbl, Year, quarter, citymarketid_1, citymarketid_2, city1, city2, airportid_1, airportid_2, airport_1, airport_2, nsmiles, passengers, fare, carrier_lg, large_ms, fare_lg, carrier_low, lf_ms, fare_low, Geocoded_City1, Geocoded_City2, tbl1apk)
SELECT tbl,
       CAST(Year AS UNSIGNED) AS Year,
       CAST(quarter AS UNSIGNED) AS quarter,
       CAST(citymarketid_1 AS UNSIGNED) AS citymarketid_1,
       CAST(citymarketid_2 AS UNSIGNED) AS citymarketid_2,
       city1,
       city2,
       CAST(airportid_1 AS UNSIGNED) AS airportid_1,
       CAST(airportid_2 AS UNSIGNED) AS airportid_2,
       airport_1,
       airport_2,
       CAST(nsmiles AS UNSIGNED) AS nsmiles,
       CAST(passengers AS UNSIGNED) AS passengers,
       CAST(fare AS DECIMAL(10, 2)) AS fare,
       carrier_lg,
       CAST(large_ms AS DECIMAL(10, 4)) AS large_ms,
       CAST(fare_lg AS DECIMAL(10, 2)) AS fare_lg,
       carrier_low,
       CAST(lf_ms AS DECIMAL(10, 4)) AS lf_ms,
       CAST(fare_low AS DECIMAL(10, 2)) AS fare_low,
       Geocoded_City1,
       Geocoded_City2,
       tbl1apk
FROM flight_data
WHERE nsmiles IS NOT NULL
  AND passengers IS NOT NULL
  AND fare IS NOT NULL
  AND large_ms IS NOT NULL
  AND fare_lg IS NOT NULL
  AND lf_ms IS NOT NULL
  AND fare_low IS NOT NULL;
  SELECT * FROM flight_data_cleaned LIMIT 10;
  -- DELETING UNIMPORTANT COLUMNS
  ALTER TABLE flight_data
  DROP COLUMN nsmiles,
  DROP COLUMN fare,
  DROP COLUMN carrier_lg,
  DROP COLUMN large_ms,
  DROP COLUMN fare_lg,
  DROP COLUMN carrier_low,
  DROP COLUMN lf_ms,
  DROP COLUMN fare_low,
  DROP COLUMN Geocoded_City1,
  DROP COLUMN Geocoded_City2,
  DROP COLUMN tbl1apk,
  ALTER TABLE flight_data
  DROP COLUMN tbl;
  --seperating city 1
ALTER TABLE flight_data
ADD COLUMN Capital_of_Arriving_city VARCHAR(50),
ADD COLUMN Arriving_State VARCHAR(50),
ADD COLUMN Arriving_City VARCHAR(50);
UPDATE flight_data
SET Capital_of_arriving_city = SUBSTRING_INDEX(city1, ',', 1),
    Arriving_City = SUBSTRING_INDEX(city1, ',', 1),
    Arriving_State = TRIM(SUBSTRING_INDEX(city1, ',', -1));
    SELECT Capital_of_arriving_city, Arriving_State, Arriving_City FROM flight_data;
    UPDATE flight_data 
SET Capital_of_arriving_city = CASE
    WHEN Arriving_City = 'Washington' THEN 'Washington, D.C.'
    WHEN Arriving_City = 'Austin' THEN 'Austin, TX'
    WHEN Arriving_City = 'Sacramento' THEN 'Sacramento, CA'
    
    ELSE 'No Capital'
END;
SELECT Capital_of_arriving_city, Arriving_State, Arriving_City FROM flight_data;
SELECT DISTINCT Arriving_State
FROM flight_data;
SELECT COUNT(DISTINCT Arriving_State) AS distinct_state_count
FROM flight_data;
ALTER TABLE flight_data
ADD COLUMN Capital_of_leaving_city VARCHAR(50),
ADD COLUMN  leaving_State VARCHAR(50),
ADD COLUMN leaving_City VARCHAR(50);
UPDATE flight_data
SET Capital_of_leaving_city = SUBSTRING_INDEX(city2, ',', 1),
   leaving_City = SUBSTRING_INDEX(city2, ',', 1),
   leaving_State = TRIM(SUBSTRING_INDEX(city2, ',', -1));
    SELECT Capital_of_leaving_city, leaving_State, leaving_City FROM flight_data;
  UPDATE flight_data 
SET Capital_of_leaving_city = CASE
    WHEN leaving_City = 'Washington' THEN 'Washington, D.C.'
    WHEN leaving_City = 'Austin' THEN 'Austin, TX'
    WHEN leaving_City = 'Sacramento' THEN 'Sacramento, CA'
    
    ELSE 'No Capital'
END;
ALTER TABLE flight_data
DROP COLUMN city1,
DROP COLUMN city2;
ALTER TABLE flight_data 
RENAME COLUMN Capital_of_arriving_city TO Capital_of_leaving_city,
RENAME COLUMN Arriving_State TO leaving_State,
RENAME COLUMN Arriving_City TO leaving_City,
RENAME COLUMN Capital_of_leaving_city TO Capital_of_Arriving_city,
RENAME COLUMN leaving_State TO Arriving_State,
RENAME COLUMN leaving_City TO Arriving_City;
ALTER TABLE flight_data 
RENAME COLUMN citymarketid_1 TO leaving_city_code,
RENAME COLUMN citymarketid_2 TO Arriving_city_code,
RENAME COLUMN airportid_1 TO leaving_airport_code, 
RENAME COLUMN  airportid_2 TO Arriving_airport_code,
RENAME COLUMN airport_1 TO leaving_airport,
RENAME COLUMN airport_2 TO Arriving_airport;

SELECT *, COUNT(*)
FROM flight_data GROUP BY Year,quarter,leaving_city_code,Arriving_city_code,leaving_airport_code,Arriving_airport_code,leaving_airport,Arriving_airport,passengers,Capital_of_leaving_city,leaving_State,leaving_City,Capital_of_Arriving_city,Arriving_State,Arriving_city
HAVING COUNT(*) >1;

-- ANALYSIS Extracting and Analysing data
-- most crowded routs based on the number of passengers
SELECT leaving_airport, arriving_airport, SUM(passengers) AS total_passengers
FROM flight_data
GROUP BY leaving_airport, arriving_airport
ORDER BY total_passengers DESC
LIMIT 10;
-- Analysis of flights in the third quarter of 2021
SELECT leaving_airport, arriving_airport, SUM(passengers) AS total_passengers
FROM flight_data
WHERE year = 2021 AND quarter = 3
GROUP BY leaving_airport, arriving_airport
ORDER BY total_passengers DESC;
-- The most popular destinations for flights departing from Washington
SELECT arriving_city, SUM(passengers) AS total_passengers
FROM flight_data
WHERE leaving_city = 'Washington'
GROUP BY arriving_city
ORDER BY total_passengers DESC;
-- Analysis of flights between Washington and Seattle
SELECT leaving_airport, arriving_airport, SUM(passengers) AS total_passengers
FROM flight_data
WHERE leaving_city = 'Washington' AND arriving_city = 'Seattle'
GROUP BY leaving_airport, arriving_airport
ORDER BY total_passengers DESC;
-- Analysis of demand for trips by state, such as Washington, DC 
SELECT leaving_airport, arriving_airport, SUM(passengers) AS total_passengers
FROM flight_data
WHERE leaving_state = 'DC (Metropolitan Area)'
GROUP BY leaving_airport, arriving_airport
ORDER BY total_passengers DESC;
-- Analysis to find out which flights depart or arrive in the capitals only
SELECT leaving_airport, arriving_airport, SUM(passengers) AS total_passengers
FROM flight_data
WHERE Capital_of_leaving_city = 'Capital' OR Capital_of_Arriving_city = 'Capital'
GROUP BY leaving_airport, arriving_airport
ORDER BY total_passengers DESC;
-- Analysis of demand for Arizona flights
SELECT year, quarter, SUM(passengers) AS total_passengers
FROM flight_data
WHERE leaving_state = 'Arizona'
GROUP BY year, quarter
ORDER BY year, quarter;
-- Analysis of trips between 2020 and 2021
SELECT `leaving_airport`, `Arriving_airport`, COUNT(*) AS num_flights
FROM flight_data
WHERE `year` BETWEEN 2020 AND 2021
GROUP BY `leaving_airport`, `arriving_airport`
ORDER BY num_flights DESC;
-- Analysis of trips in 2021 only
SELECT `leaving_airport`, `arriving_airport`, COUNT(*) AS num_flights
FROM flight_data
WHERE `year` = 2021
GROUP BY `leaving_airport`, `arriving_airport`
ORDER BY num_flights DESC;
-- Analysis of flights between two capitals only
SELECT `leaving_airport`, `arriving_airport`, COUNT(*) AS num_flights
FROM flight_data
WHERE `capital_of_leaving_city` = 'Capital_city' AND `capital_of_arriving_city` = 'Capital_city'
GROUP BY `leaving_airport`, `arriving_airport`
ORDER BY num_flights DESC;