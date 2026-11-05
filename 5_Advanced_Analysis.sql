-- =====================================================
-- Step 5: Deeper analysis with CTEs, JOINs and window functions
-- Uses the clean table tripdata_final_2023 from 3_Data_Cleaning.sql
-- =====================================================


-- 5A. Share of all rides taken by each user type
-- SUM(...) OVER () adds up the counts of every group, so each row can be
-- divided by the grand total without a second query

SELECT
    member_casual,
    COUNT(*) AS total_rides,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct_of_all_rides
FROM tripdata_final_2023
GROUP BY member_casual;


-- 5B. Share of each user type's rides that happen on each day of the week
-- PARTITION BY member_casual gives a separate total for casual riders and members

WITH rides_by_day AS (
    SELECT
        member_casual,
        day_of_week,
        COUNT(*) AS ride_count
    FROM tripdata_final_2023
    GROUP BY member_casual, day_of_week
)
SELECT
    member_casual,
    day_of_week,
    ride_count,
    CAST(100.0 * ride_count / SUM(ride_count) OVER (PARTITION BY member_casual) AS DECIMAL(5,2)) AS pct_of_user_type_rides
FROM rides_by_day
ORDER BY member_casual, ride_count DESC;


-- 5C. Top 5 start stations for each user type
-- ROW_NUMBER restarts at 1 for each user type, so one query returns both top 5 lists

WITH station_counts AS (
    SELECT
        member_casual,
        start_station_name,
        COUNT(*) AS ride_count
    FROM tripdata_final_2023
    GROUP BY member_casual, start_station_name
),
ranked_stations AS (
    SELECT
        member_casual,
        start_station_name,
        ride_count,
        ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY ride_count DESC) AS station_rank
    FROM station_counts
)
SELECT
    member_casual,
    station_rank,
    start_station_name,
    ride_count
FROM ranked_stations
WHERE station_rank <= 5
ORDER BY member_casual, station_rank;


-- 5D. Busiest start hour for each user type
-- RANK gives tied hours the same rank, so a tie for first place would show both hours

WITH rides_by_hour AS (
    SELECT
        member_casual,
        DATEPART(HOUR, started_at) AS start_hour,
        COUNT(*) AS ride_count
    FROM tripdata_final_2023
    GROUP BY member_casual, DATEPART(HOUR, started_at)
)
SELECT
    member_casual,
    start_hour,
    ride_count
FROM (
    SELECT
        member_casual,
        start_hour,
        ride_count,
        RANK() OVER (PARTITION BY member_casual ORDER BY ride_count DESC) AS hour_rank
    FROM rides_by_hour
) AS ranked_hours
WHERE hour_rank = 1;


-- 5E. Stations where casual riders make up the largest share of rides
-- Two CTEs count casual and member rides per start station, then a JOIN puts
-- them side by side. Stations with a high casual share are good places for
-- membership campaigns. Stations with fewer than 1,000 total rides are left out
-- so small stations do not distort the percentages.

WITH casual_rides AS (
    SELECT start_station_name, COUNT(*) AS casual_count
    FROM tripdata_final_2023
    WHERE member_casual = 'casual'
    GROUP BY start_station_name
),
member_rides AS (
    SELECT start_station_name, COUNT(*) AS member_count
    FROM tripdata_final_2023
    WHERE member_casual = 'member'
    GROUP BY start_station_name
)
SELECT
    c.start_station_name,
    c.casual_count,
    m.member_count,
    c.casual_count + m.member_count AS total_count,
    CAST(100.0 * c.casual_count / (c.casual_count + m.member_count) AS DECIMAL(5,2)) AS casual_pct
FROM casual_rides AS c
INNER JOIN member_rides AS m
    ON c.start_station_name = m.start_station_name
WHERE c.casual_count + m.member_count >= 1000
ORDER BY casual_pct DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- 5F. Monthly rides by user type with change from the previous month
-- LAG looks back one row (the previous month) within each user type

WITH monthly_rides AS (
    SELECT
        member_casual,
        MONTH(started_at) AS ride_month,
        COUNT(*) AS ride_count
    FROM tripdata_final_2023
    GROUP BY member_casual, MONTH(started_at)
)
SELECT
    member_casual,
    ride_month,
    ride_count,
    ride_count - LAG(ride_count) OVER (PARTITION BY member_casual ORDER BY ride_month) AS change_from_prev_month
FROM monthly_rides
ORDER BY member_casual, ride_month;
