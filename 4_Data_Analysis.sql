-- ANALYSIS PHASE: Answering Cyclistic Business Questions using SQL
-- Based on cleaned data in `tripdata_final` table created in the data cleaning phase

-- Question 1: How do annual members and casual riders use Cyclistic bikes differently?
-- Breakdown by average ride length, ride counts, and usage patterns by weekday and ride type

-- 1A. Compare average ride length (in minutes) by user type
SELECT 
    member_casual,
    AVG(ride_length_min) AS average_ride_duration_min
FROM tripdata_final_2023
GROUP BY member_casual;

-- 1B. Compare total number of rides by user type
SELECT 
    member_casual,
    COUNT(*) AS total_rides
FROM tripdata_final_2023
GROUP BY member_casual;

-- 1C. Compare number of rides by day of week and user type
SELECT 
    member_casual,
    day_of_week,
    COUNT(*) AS total_rides
FROM tripdata_final_2023
GROUP BY member_casual, day_of_week
ORDER BY 
    member_casual,
    CASE 
        WHEN day_of_week = 'Sunday' THEN 1
        WHEN day_of_week = 'Monday' THEN 2
        WHEN day_of_week = 'Tuesday' THEN 3
        WHEN day_of_week = 'Wednesday' THEN 4
        WHEN day_of_week = 'Thursday' THEN 5
        WHEN day_of_week = 'Friday' THEN 6
        WHEN day_of_week = 'Saturday' THEN 7
    END;

-- 1D. Compare average ride duration by day of week and user type
SELECT 
    member_casual,
    day_of_week,
    AVG(ride_length_min) AS avg_ride_length
FROM tripdata_final_2023
GROUP BY member_casual, day_of_week
ORDER BY 
    member_casual,
    CASE 
        WHEN day_of_week = 'Sunday' THEN 1
        WHEN day_of_week = 'Monday' THEN 2
        WHEN day_of_week = 'Tuesday' THEN 3
        WHEN day_of_week = 'Wednesday' THEN 4
        WHEN day_of_week = 'Thursday' THEN 5
        WHEN day_of_week = 'Friday' THEN 6
        WHEN day_of_week = 'Saturday' THEN 7
    END;

-- 1E. Ride Time of Day Patterns (Hourly Usage)
SELECT 
    member_casual,
    DATEPART(HOUR, started_at) AS start_hour,
    COUNT(*) AS ride_count
FROM tripdata_final_2023
GROUP BY 
    member_casual, DATEPART(HOUR, started_at)
ORDER BY 
    member_casual, start_hour;

-- 1F. Bike Type Preferences By User Type
SELECT 
    member_casual,
    rideable_type,
    COUNT(*) AS ride_count
FROM tripdata_final_2023
GROUP BY member_casual, rideable_type
ORDER BY member_casual, ride_count DESC;


-- Question 2: Why would casual riders buy Cyclistic annual memberships?
-- Analyze differences in ride behavior that can suggest marketing opportunities

-- 2A. Analyze peak usage days for casual riders
SELECT 
    day_of_week,
    COUNT(*) AS casual_ride_count
FROM tripdata_final_2023
WHERE member_casual = 'casual'
GROUP BY day_of_week
ORDER BY 
    CASE 
        WHEN day_of_week = 'Sunday' THEN 1
        WHEN day_of_week = 'Monday' THEN 2
        WHEN day_of_week = 'Tuesday' THEN 3
        WHEN day_of_week = 'Wednesday' THEN 4
        WHEN day_of_week = 'Thursday' THEN 5
        WHEN day_of_week = 'Friday' THEN 6
        WHEN day_of_week = 'Saturday' THEN 7
    END;

-- 2B. Compare weekend vs weekday usage for casual riders
SELECT 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS ride_day_type,
    COUNT(*) AS casual_ride_count
FROM tripdata_final_2023
WHERE member_casual = 'casual'
GROUP BY 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END;

-- 2C. Identify average ride length for casuals on weekends vs weekdays
SELECT 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS ride_day_type,
    AVG(ride_length_min) AS avg_ride_length
FROM tripdata_final_2023
WHERE member_casual = 'casual'
GROUP BY 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END;

-- 2D. Long Ride Routes By Casual Users
SELECT 
    start_station_name,
    end_station_name,
    ride_length_min
FROM tripdata_final_2023
WHERE 
    member_casual = 'casual'
    AND ride_length_min > 60
ORDER BY ride_length_min DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- Question 3: How can Cyclistic use digital media to influence casual riders to become members?
-- While SQL alone can’t answer marketing strategies, we can highlight user behavior to inform campaigns

-- 3A. Identify top 10 most popular end stations for casual riders
SELECT 
    end_station_name,
    COUNT(*) AS ride_count
FROM 
    tripdata_final_2023
WHERE 
    member_casual = 'casual'
    AND end_station_name IS NOT NULL
    AND end_station_name <> ''
GROUP BY 
    end_station_name
ORDER BY 
    ride_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 3B. Identify top 10 most popular start stations for casual riders
SELECT 
    start_station_name,
    COUNT(*) AS ride_count
FROM 
    tripdata_final_2023
WHERE 
    member_casual = 'casual'
    AND start_station_name IS NOT NULL
    AND start_station_name <> ''
GROUP BY 
    start_station_name
ORDER BY 
    ride_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 3C. Identify time trends: which days casuals ride the most
SELECT 
    day_of_week,
    COUNT(*) AS casual_ride_count
FROM tripdata_final_2023
WHERE member_casual = 'casual'
GROUP BY day_of_week
ORDER BY casual_ride_count DESC;

-- 3D. Trip Start-End Station Pairs For Casual (Top Routes)
SELECT 
    start_station_name,
    end_station_name,
    COUNT(*) AS route_count
FROM tripdata_final_2023
WHERE 
    member_casual = 'casual'
    AND start_station_name IS NOT NULL
	AND start_station_name <> ''
    AND end_station_name IS NOT NULL
	AND end_station_name <> ''
GROUP BY start_station_name, end_station_name
ORDER BY route_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
