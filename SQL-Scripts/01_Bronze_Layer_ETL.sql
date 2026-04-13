/*
===============================================================================
Project: Cyclistic Bike-Share Analysis 2025
Description: This script initializes the database, schema, and bronze-layer table. 
             It includes a stored procedure to perform bulk ETL (Extract, 
             Load, Transform) from 12 monthly CSV files into SQL Server.
Author: [Malak esam]
Date: 2026-04-13
===============================================================================
*/

USE master;
GO

-------------------------------------------------------------------------------
-- 1. Database Initialization
-------------------------------------------------------------------------------

-- Drop database if it exists to ensure a clean environment
IF DB_ID('CyclisticProject') IS NOT NULL
BEGIN
    ALTER DATABASE CyclisticProject
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE CyclisticProject;
END
GO

-- Create and initialize the project database
CREATE DATABASE CyclisticProject;
GO

USE CyclisticProject;
GO

-- Create a dedicated schema for better data organization
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Cyclistic')
BEGIN
    EXEC('CREATE SCHEMA Cyclistic');
END
GO

-------------------------------------------------------------------------------
-- 2. Table Definition (Bronze Layer)
-------------------------------------------------------------------------------

-- Drop Bronze table if it exists before recreation
IF OBJECT_ID('Cyclistic.Bronze_All_Trips_2025', 'U') IS NOT NULL
    DROP TABLE Cyclistic.Bronze_All_Trips_2025;
GO

-- Create the staging table for raw data import
CREATE TABLE Cyclistic.Bronze_All_Trips_2025 (
    ride_id            NVARCHAR(100),
    rideable_type      NVARCHAR(100),
    started_at         NVARCHAR(100),
    ended_at           NVARCHAR(100),
    start_station_name NVARCHAR(255),
    start_station_id   NVARCHAR(100),
    end_station_name   NVARCHAR(255),
    end_station_id     NVARCHAR(100),
    start_lat          NVARCHAR(100),
    start_lng          NVARCHAR(100),
    end_lat            NVARCHAR(100),
    end_lng            NVARCHAR(100),
    member_casual      NVARCHAR(100)
);
GO

-------------------------------------------------------------------------------
-- 3. ETL Stored Procedure
-------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE Cyclistic.load_bronze_data
AS
/*
    Summary: 
    Truncates the bronze table and performs BULK INSERT for 12 monthly datasets.
*/
BEGIN
    BEGIN TRY
        -- Clear existing data to avoid duplicates
        TRUNCATE TABLE Cyclistic.Bronze_All_Trips_2025;

        -- Local File Paths & Bulk Insert Operations
        
        -- January
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202501-divvy-tripdata\202501-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> January Data Loaded';

        -- February
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202502-divvy-tripdata\202502-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> February Data Loaded';

        -- March
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202503-divvy-tripdata\202503-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> March Data Loaded';

        -- April
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202504-divvy-tripdata\202504-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> April Data Loaded';

        -- May
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202505-divvy-tripdata\202505-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> May Data Loaded';

        -- June
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202506-divvy-tripdata\202506-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> June Data Loaded';

        -- July
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202507-divvy-tripdata\202507-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> July Data Loaded';

        -- August
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202508-divvy-tripdata\202508-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> August Data Loaded';

        -- September
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202509-divvy-tripdata\202509-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> September Data Loaded';

        -- October
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202510-divvy-tripdata\202510-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> October Data Loaded';

        -- November
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202511-divvy-tripdata\202511-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> November Data Loaded';

        -- December
        BULK INSERT Cyclistic.Bronze_All_Trips_2025
        FROM 'D:\data_analysis_projects\Projects\CaseSudy1\dataset\202512-divvy-tripdata\202512-divvy-tripdata.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
        PRINT '>> December Data Loaded';

        PRINT '---------------------------------------------------------';
        PRINT 'SUCCESS: Full annual dataset loaded into Bronze layer.';
        PRINT '---------------------------------------------------------';

    END TRY
    BEGIN CATCH
        PRINT 'CRITICAL ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------------------------------------------------------------------------
-- 4. Execution & Validation
-------------------------------------------------------------------------------

-- Execute the load procedure
EXEC Cyclistic.load_bronze_data;
GO

-- Verify the total row count to ensure data integrity
SELECT 
    COUNT(*) AS [Total Rows Loaded],
    MIN(started_at) AS [Data Starts From],
    MAX(started_at) AS [Data Ends At]
FROM Cyclistic.Bronze_All_Trips_2025;
GO
