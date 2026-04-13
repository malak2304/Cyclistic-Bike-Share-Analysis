/*
===============================================================================
Project: Cyclistic Bike-Share Analysis 2025
Layer: Silver Layer (Data Cleaning & Transformation)
Description: 
    This script transforms raw data from the Bronze layer into a cleaned 
    Silver layer. Key operations include:
    - Data type casting (Strings to DateTime/Float).
    - Handling NULL values in station names.
    - Cleaning text anomalies (Double quotes, extra spaces).
    - Standardizing casing and removing temporary station markers.
    - Filtering out logical errors (Trips < 1 min, out-of-year data).
    - Validating geographic integrity.
===============================================================================
*/

USE CyclisticProject;
GO

-------------------------------------------------------------------------------
-- 1. Table Reconstruction
-------------------------------------------------------------------------------

-- Drop existing Silver table to ensure a fresh transformation
IF OBJECT_ID('Cyclistic.Silver_Trips_2025', 'U') IS NOT NULL
    DROP TABLE Cyclistic.Silver_Trips_2025;
GO

-- Create Silver table with optimized data types and calculated columns
CREATE TABLE Cyclistic.Silver_Trips_2025 (
    ride_id            NVARCHAR(50),
    rideable_type      NVARCHAR(50),
    started_at         DATETIME2,
    ended_at           DATETIME2,
    -- Computed Columns for Analysis
    ride_length_min    AS (DATEDIFF(SECOND, started_at, ended_at) / 60.0), 
    day_of_week        AS (DATENAME(WEEKDAY, started_at)), 
    start_station_name NVARCHAR(255),
    end_station_name   NVARCHAR(255),
    member_casual      NVARCHAR(50),
    start_lat          FLOAT,  
    start_lng          FLOAT,   
    end_lat            FLOAT,   
    end_lng            FLOAT    
);
GO

-------------------------------------------------------------------------------
-- 2. Data Migration & Initial Cleaning (Bronze to Silver)
-------------------------------------------------------------------------------

INSERT INTO Cyclistic.Silver_Trips_2025 
    (ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, start_lng, end_lat, end_lng)
SELECT 
    REPLACE(LTRIM(RTRIM(ride_id)), '"', ''), -- Remove double quotes and trim
    REPLACE(rideable_type, '"', ''),
    TRY_CAST(REPLACE(started_at, '"', '') AS DATETIME2),
    TRY_CAST(REPLACE(ended_at, '"', '') AS DATETIME2),
    REPLACE(start_station_name, '"', ''),
    REPLACE(end_station_name, '"', ''),
    REPLACE(member_casual, '"', ''),
    TRY_CAST(REPLACE(start_lat, '"', '') AS FLOAT), 
    TRY_CAST(REPLACE(start_lng, '"', '') AS FLOAT),
    TRY_CAST(REPLACE(end_lat, '"', '') AS FLOAT), 
    TRY_CAST(REPLACE(end_lng, '"', '') AS FLOAT)
FROM Cyclistic.Bronze_All_Trips_2025
WHERE started_at IS NOT NULL 
  AND started_at NOT LIKE '%started_at%'; -- Exclude header rows if present
GO

-------------------------------------------------------------------------------
-- 3. Data Refinement & Integrity Checks
-------------------------------------------------------------------------------

-- A. Handle Null Values
-- Strategy: Replace missing station names with 'Remote' for electric bike analysis
UPDATE Cyclistic.Silver_Trips_2025
SET start_station_name = ISNULL(start_station_name, 'Remote'),
    end_station_name   = ISNULL(end_station_name, 'Remote')
WHERE start_station_name IS NULL OR end_station_name IS NULL;

-- B. Text Standardization (Trimming & Formatting)
UPDATE Cyclistic.Silver_Trips_2025
SET 
    ride_id            = TRIM(ride_id),
    rideable_type      = TRIM(rideable_type),
    start_station_name = TRIM(start_station_name),
    end_station_name   = TRIM(end_station_name),
    member_casual      = TRIM(member_casual);

-- Remove Temp/Technical markers from station names
UPDATE Cyclistic.Silver_Trips_2025
SET start_station_name = REPLACE(REPLACE(start_station_name, '(Temp)', ''), '(*)', ''),
    end_station_name   = REPLACE(REPLACE(end_station_name, '(Temp)', ''), '(*)', '')
WHERE start_station_name LIKE '%(Temp)%' OR start_station_name LIKE '%(*)%';

-- Apply Proper Case (Title Case) for consistent reporting
UPDATE Cyclistic.Silver_Trips_2025
SET 
    rideable_type = UPPER(LEFT(REPLACE(rideable_type, '_', ' '), 1)) + 
                    LOWER(SUBSTRING(REPLACE(rideable_type, '_', ' '), 2, LEN(rideable_type))),

    start_station_name = UPPER(LEFT(start_station_name, 1)) + 
                         LOWER(SUBSTRING(start_station_name, 2, LEN(start_station_name))),

    end_station_name   = UPPER(LEFT(end_station_name, 1)) + 
                         LOWER(SUBSTRING(end_station_name, 2, LEN(end_station_name))),

    member_casual      = UPPER(LEFT(member_casual, 1)) + 
                         LOWER(SUBSTRING(member_casual, 2, LEN(member_casual)));

-------------------------------------------------------------------------------
-- 4. Logical Filtering (Removing Anomalies)
-------------------------------------------------------------------------------

-- Remove records outside of the target year (2025)
DELETE FROM Cyclistic.Silver_Trips_2025
WHERE YEAR(started_at) <> 2025 OR YEAR(ended_at) <> 2025;

-- Remove trips with illogical timestamps (End before Start)
DELETE FROM Cyclistic.Silver_Trips_2025
WHERE started_at >= ended_at;

-- Remove "Ghost Trips" (Duration < 1 minute)
-- These are usually system tests or accidental docks
DELETE FROM Cyclistic.Silver_Trips_2025
WHERE ride_length_min < 1;

-------------------------------------------------------------------------------
-- 5. Final Validation Summary
-------------------------------------------------------------------------------

-- Audit: Duplicate Check
SELECT ride_id, COUNT(*) AS Duplicate_Count
FROM Cyclistic.Silver_Trips_2025
GROUP BY ride_id
HAVING COUNT(*) > 1;

-- Audit: Geographical Bounds (Chicago Area)
SELECT 
    COUNT(*) AS Outside_Chicago_Count
FROM Cyclistic.Silver_Trips_2025
WHERE (start_lat NOT BETWEEN 41.0 AND 43.0) 
   OR (start_lng NOT BETWEEN -88.5 AND -87.0);

-- Audit: Final Row Count
SELECT 
    COUNT(*) AS Cleaned_Row_Count,
    (SELECT COUNT(*) FROM Cyclistic.Bronze_All_Trips_2025) AS Raw_Row_Count,
    (SELECT COUNT(*) FROM Cyclistic.Bronze_All_Trips_2025) - COUNT(*) AS Rows_Removed
FROM Cyclistic.Silver_Trips_2025;
GO

-- Preview cleaned data
SELECT TOP 50 * FROM Cyclistic.Silver_Trips_2025 ORDER BY started_at;
