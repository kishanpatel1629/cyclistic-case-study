-- =====================================================
-- Step 1: Create monthly tables, load the CSV files and
-- combine all 12 months into one table (tripdata_all_2023)
-- Tool: SQL Server (T-SQL) in SSMS
-- =====================================================

-- 1A. Create one table per month of 2023 (same columns as the Divvy CSV files)

CREATE TABLE tripdata_202301 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202302 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202303 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202304 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202305 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202306 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202307 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202308 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202309 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202310 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202311 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202312 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(500),
    start_station_id VARCHAR(50),
    end_station_name NVARCHAR(500),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);


-- 1B. Load each monthly CSV file into its table.
-- In SSMS this can be done with the Import Flat File wizard
-- (right click the database > Tasks > Import Flat File),
-- or with BULK INSERT as in the example below.
-- Change the file path to where the CSV files are saved, then repeat for each month.

/*
BULK INSERT tripdata_202301
FROM 'C:\cyclistic\202301-divvy-tripdata.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
*/


-- 1C. Combine all 12 months into one table with UNION ALL
-- UNION ALL keeps every row (UNION would remove duplicates and run slower)

DROP TABLE IF EXISTS tripdata_all_2023;

SELECT *
INTO tripdata_all_2023
FROM (
    SELECT * FROM tripdata_202301 UNION ALL
    SELECT * FROM tripdata_202302 UNION ALL
    SELECT * FROM tripdata_202303 UNION ALL
    SELECT * FROM tripdata_202304 UNION ALL
    SELECT * FROM tripdata_202305 UNION ALL
    SELECT * FROM tripdata_202306 UNION ALL
    SELECT * FROM tripdata_202307 UNION ALL
    SELECT * FROM tripdata_202308 UNION ALL
    SELECT * FROM tripdata_202309 UNION ALL
    SELECT * FROM tripdata_202310 UNION ALL
    SELECT * FROM tripdata_202311 UNION ALL
    SELECT * FROM tripdata_202312
) AS all_months;


-- 1D. Check the combined row count
SELECT COUNT(*) AS total_rides_2023
FROM tripdata_all_2023;
