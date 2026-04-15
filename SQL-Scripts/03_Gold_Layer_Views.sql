/* ===============================================================================
PROJECT: CYCLISTIC BIKE-SHARE ANALYSIS (GOLD LAYER)
DESCRIPTION: Final aggregated queries for analysis and visualization.
=============================================================================== */

-- ----------------------------------------------------------------------------
-- STEP 1: GENERAL USAGE SUMMARY (Percentage of Total Rides)
-- ----------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW v_User_Proportions AS
WITH casual_number AS (
    SELECT count(*) as c_number
    FROM cyclistic.Silver_Trips_2025
    WHERE member_casual like 'Casual'
),
member_number AS (
    SELECT count(*) as m_number
    FROM cyclistic.Silver_Trips_2025
    WHERE member_casual like 'Member'
)
SELECT 
    (m_number * 100.0 / (m_number + c_number)) as member_percentage,
    (c_number * 100.0 / (m_number + c_number)) as casual_percentage
FROM casual_number
JOIN member_number ON 1=1;
GO

-- ----------------------------------------------------------------------------
-- STEP 2: TRIP DURATION ANALYSIS (Avg, Max, Min, and Median)
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW v_Trip_Duration_Metrics AS
SELECT DISTINCT
    member_casual,
    AVG(ride_length_min) OVER(PARTITION BY member_casual) AS avg_ride_length,
    MAX(ride_length_min) OVER(PARTITION BY member_casual) AS max_ride_length,
    MIN(ride_length_min) OVER(PARTITION BY member_casual) AS min_ride_length,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ride_length_min) 
        OVER(PARTITION BY member_casual) AS median_ride_length
FROM cyclistic.Silver_Trips_2025;
GO

-- ----------------------------------------------------------------------------
-- STEP 3: TIME-BASED TRENDS (Monthly, Weekly, and Hourly)
-- ----------------------------------------------------------------------------

-- A) Seasonality: Total rides per Month
CREATE OR ALTER VIEW v_Monthly_Trends AS
SELECT 
    DATENAME(MONTH, started_at) AS month_name, 
    member_casual,
    COUNT(*) AS total_rides_per_month 
FROM Cyclistic.Silver_Trips_2025 
GROUP BY 
    DATENAME(MONTH, started_at), 
    MONTH(started_at),
    member_casual;
GO

-- B) Weekly: Total rides per Day of Week
CREATE OR ALTER VIEW v_Weekly_Trends AS
SELECT 
    DATENAME(WEEKDAY, started_at) AS day_name,
    member_casual,
    COUNT(*) AS total_rides_per_day
FROM Cyclistic.Silver_Trips_2025 
GROUP BY 
    DATENAME(WEEKDAY, started_at), 
    DATEPART(WEEKDAY, started_at),
    member_casual;
GO

-- C) Hourly: Total rides per Hour (Rush Hour)
CREATE OR ALTER VIEW v_Hourly_Trends AS
SELECT 
    DATEPART(HOUR, started_at) AS ride_hour,
    member_casual,
    COUNT(*) AS total_rides
FROM cyclistic.Silver_Trips_2025
GROUP BY 
    DATEPART(HOUR, started_at), 
    member_casual;
GO

-- ----------------------------------------------------------------------------
-- STEP 4: POPULAR STATIONS ANALYSIS (Top 10 Excluding Remote)
-- ----------------------------------------------------------------------------

-- Note: Combined into one view for cleaner export
CREATE OR ALTER VIEW v_Top_Stations_Summary AS
SELECT TOP 100 PERCENT * FROM (
    -- Top 10 Start Stations for Casual
    SELECT TOP 10 'Start' as Type, 'Casual' as User, start_station_name as Station, count(ride_id) as Count
    FROM cyclistic.Silver_Trips_2025
    WHERE member_casual = 'Casual' AND start_station_name NOT LIKE '%Remote%'
    GROUP BY start_station_name ORDER BY count(ride_id) DESC
) AS C_Start
UNION ALL
SELECT TOP 100 PERCENT * FROM (
    -- Top 10 Start Stations for Member
    SELECT TOP 10 'Start' as Type, 'Member' as User, start_station_name as Station, count(ride_id) as Count
    FROM cyclistic.Silver_Trips_2025
    WHERE member_casual = 'Member' AND start_station_name NOT LIKE '%Remote%'
    GROUP BY start_station_name ORDER BY count(ride_id) DESC
) AS M_Start;
GO

-- ----------------------------------------------------------------------------
-- STEP 5: BIKE PREFERENCE (Classic vs Electric)
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW v_Bike_Preferences AS
SELECT 
    rideable_type, 
    member_casual, 
    COUNT(ride_id) AS number_of_bike_users
FROM cyclistic.Silver_Trips_2025
WHERE rideable_type IN ('Classic bike', 'Electric bike')
GROUP BY rideable_type, member_casual;
GO

