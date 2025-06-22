-- ==============================
-- Cyclistic Data Exploration SQL
-- ==============================

-- 1. Check number of NULLs in each column
SELECT 
  COUNT(*) - COUNT(ride_id) AS null_ride_id,
  COUNT(*) - COUNT(rideable_type) AS null_rideable_type,
  COUNT(*) - COUNT(started_at) AS null_started_at,
  COUNT(*) - COUNT(ended_at) AS null_ended_at,
  COUNT(*) - COUNT(start_station_name) AS null_start_station_name,
  COUNT(*) - COUNT(start_station_id) AS null_start_station_id,
  COUNT(*) - COUNT(end_station_name) AS null_end_station_name,
  COUNT(*) - COUNT(end_station_id) AS null_end_station_id,
  COUNT(*) - COUNT(start_lat) AS null_start_lat,
  COUNT(*) - COUNT(start_lng) AS null_start_lng,
  COUNT(*) - COUNT(end_lat) AS null_end_lat,
  COUNT(*) - COUNT(end_lng) AS null_end_lng,
  COUNT(*) - COUNT(member_casual) AS null_member_casual
FROM tripdata_all_2023;

-- 2. Check consistency in ride_id length
SELECT LEN(ride_id) AS ride_id_length, COUNT(*) AS count
FROM tripdata_all_2023
GROUP BY LEN(ride_id);

-- 3. Explore distinct rideable types
SELECT rideable_type, COUNT(*) AS count
FROM tripdata_all_2023
GROUP BY rideable_type;

-- 4. Identify time-based outliers (short/long rides)
SELECT ride_id, started_at, ended_at, ride_length_min
FROM tripdata_all_2023
WHERE ride_length_min <= 1 OR ride_length_min >= 1440;

-- 5. Explore null and frequent station names
SELECT start_station_name, COUNT(*) AS count
FROM tripdata_all_2023
GROUP BY start_station_name
ORDER BY count DESC;

SELECT end_station_name, COUNT(*) AS count
FROM tripdata_all_2023
GROUP BY end_station_name
ORDER BY count DESC;

-- 6. Check for NULL station IDs
SELECT *
FROM tripdata_all_2023
WHERE start_station_id IS NULL OR end_station_id IS NULL;

-- 7. Validate latitude/longitude data presence
SELECT *
FROM tripdata_all_2023
WHERE start_lat IS NULL OR start_lng IS NULL OR end_lat IS NULL OR end_lng IS NULL;

-- 8. Explore member types and their distribution
SELECT member_casual, COUNT(*) AS count
FROM tripdata_all_2023
GROUP BY member_casual;
