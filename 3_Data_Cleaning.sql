-- Create Final Clean Table

SELECT *
INTO tripdata_final_2023
FROM tripdata_all_2023
WHERE ride_length_min > 0
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND member_casual IN ('member', 'casual')
  AND ride_length_min <= 1440;

-- Add Ride Length and Day of Week

ALTER TABLE tripdata_all_2023
	ADD ride_length_min INT,
    day_of_week VARCHAR(20);


-- Update values

UPDATE tripdata_all_2023
SET
    ride_length_min = DATEDIFF(MINUTE, started_at, ended_at),
    day_of_week = DATENAME(WEEKDAY, started_at);
