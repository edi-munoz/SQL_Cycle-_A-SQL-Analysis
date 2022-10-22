ALTER TABLE 2021_all_trips
ADD ride_duration TIME(0);

UPDATE IGNORE 2021_all_trips
SET ride_duration = TIMEDIFF(ended_at, started_at)
;

DELETE FROM 2021_all_trips
WHERE ride_duration < '00:00:00' OR
	ride_duration = '00:00:00' OR
    ride_duration > '24:00:00'
    ;

ALTER TABLE 2021_all_trips
ADD day_of_week VARCHAR(50),
ADD `month` VARCHAR(50),
ADD `day` INT;

UPDATE 2021_all_trips
SET day_of_week = DAYNAME(started_at),
`month` = MONTHNAME(started_at),
`day` = DAYOFMONTH(started_at);

DELETE FROM 2021_all_trips
WHERE start_station_name LIKE '%Temp%';

DELETE FROM 2021_all_trips
WHERE start_station_id = 'Hubbard Bike-checking (LBS-WH-TEST)'; /*'Throop/Hastings Mobile Station' 'DIVVY CASSETTE REPAIR MOBILE STATION' AND start_station_id = 'DIVVY 001' AND start_station_id = 'Hubbard Bike-checking (LBS-WH-TEST)';*/

SELECT start_station_name, COUNT(DISTINCT start_station_id) `count`
FROM 2021_all_trips
GROUP BY start_station_name
ORDER BY COUNT(DISTINCT start_station_id) DESC;

UPDATE 2021_all_trips
SET start_station_id = 20102
WHERE start_station_name = 'Loomis St & 89th St';

SELECT start_station_name
FROM 2021_all_trips
WHERE start_station_id = '20215';

UPDATE 2021_all_trips
SET start_station_name = 'Hegewisch Metra Station'
WHERE start_station_name IS NULL 
AND start_station_id = '20215';

UPDATE 2021_all_trips
SET start_station_name = LOWER(start_station_name)
WHERE start_station_name = 'DIVVY CASSETTE REPAIR MOBILE STATION';

ALTER TABLE 2021_all_trips
ADD ride_distance FLOAT;

UPDATE IGNORE 2021_all_trips
SET ride_distance = St_Distance_Sphere(
	point(start_lng, start_lat),
    point(end_lng, end_lat)
) * .000621371192
;

SELECT end_station_name, end_station_id
FROM 2021_all_trips
WHERE end_station_id = 'TA1309000049'
GROUP BY end_station_name;

UPDATE 2021_all_trips
SET end_station_name = 'DuSable Lake Shore Dr & Belmont Ave'
WHERE end_station_name = 'Lake Shore Dr & Belmont Ave'
;

CREATE TABLE 2021_trips_analyzed
AS
SELECT * 
FROM 2021_all_trips;    

ALTER TABLE 2021_trips_analyzed
  DROP COLUMN start_lng;   
  
UPDATE IGNORE 2021_trips_analyzed
SET ride_distance = ROUND(ride_distance,2);

DELETE FROM 2021_trips_analyzed
WHERE ride_distance = '0' OR
	  ride_distance < '0.00';
      
SELECT COUNT(*)
FROM 2021_trips_analyzed;