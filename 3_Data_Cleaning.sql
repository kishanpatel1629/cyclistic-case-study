-- =====================================================
-- Step 3: Create the final clean table
-- Run after 2_Data_Exploration.sql
-- =====================================================

-- Keep only rides that:
--   have a start and end station name
--   have a valid rider type (member or casual)
--   lasted more than 0 minutes and no more than 24 hours (1,440 minutes)

DROP TABLE IF EXISTS tripdata_final_2023;

SELECT *
INTO tripdata_final_2023
FROM tripdata_all_2023
WHERE ride_length_min > 0
  AND ride_length_min <= 1440
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND member_casual IN ('member', 'casual');

-- Compare row counts before and after cleaning
SELECT
    (SELECT COUNT(*) FROM tripdata_all_2023)   AS rows_before_cleaning,
    (SELECT COUNT(*) FROM tripdata_final_2023) AS rows_after_cleaning;
