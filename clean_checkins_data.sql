-- SQL script to clean and transform check-in data from CSV
-- This script performs the following operations:
-- 1. Removes duplicate rows
-- 2. Applies TRIM() to remove leading/trailing spaces in text fields
-- 3. Standardizes case formatting (lowercase for text fields)
-- 4. Ensures correct data types for dates, numbers, etc.
-- 5. Excludes the original CohortWeek column and creates a new one calculated as:
--    (julianday(CheckinTime) - julianday(StartDate))/7 + 1
-- 6. Corrects StartDate values of 2023-09-02 to 2023-09-01

-- Create table for cleaned data
CREATE TABLE IF NOT EXISTS cleaned_checkins AS

WITH cleaned_data AS (
    -- First select all data with TRIM applied and proper case conversion
    -- Also convert date fields to the correct format and fix dates
    SELECT DISTINCT
        CAST(TRIM("Index") AS NUMERIC) AS "Index",
        TRIM("Type") AS "Type",
        TRIM("RecordStatus") AS "RecordStatus",
        DATE(TRIM("CheckinDate")) AS "CheckinDate",
        CAST(TRIM("CohortDay") AS INTEGER) AS "CohortDay",
        -- CohortWeek will be recalculated, so we don't include it here
        LOWER(TRIM("Industry")) AS "Industry",
        TRIM("CheckinSource") AS "CheckinSource",
        DATETIME(TRIM("CheckinTime")) AS "CheckinTime",
        -- Fix StartDate: if it's 2023-09-02, change to 2023-09-01
        CASE 
            WHEN DATE(TRIM("StartDate")) = '2023-09-02' THEN '2023-09-01' 
            ELSE DATE(TRIM("StartDate"))
        END AS "StartDate",
        CASE 
            WHEN TRIM("EndDate") = '' THEN NULL 
            ELSE DATE(TRIM("EndDate")) 
        END AS "EndDate",
        CAST(TRIM("UserID") AS INTEGER) AS "UserID",
        TRIM("UserName") AS "UserName",
        CAST(TRIM("CompanyID") AS INTEGER) AS "CompanyID",
        TRIM("CompanyName") AS "CompanyName",
        CAST(TRIM("GymID") AS INTEGER) AS "GymID",
        TRIM("GymName") AS "GymName"
    FROM checkins
)

-- Now add the new CohortWeek column based on the requested formula
SELECT 
    "Index",
    "Type",
    "RecordStatus",
    "CheckinDate",
    "CohortDay",
    -- Calculate new CohortWeek: difference in weeks between CheckinTime and StartDate + 1
    -- SQLite uses julianday() function instead of DATEDIFF
    CAST((julianday("CheckinTime") - julianday("StartDate"))/7 + 1 AS INTEGER) AS "CohortWeek",
    "Industry",
    "CheckinSource",
    "CheckinTime",
    "StartDate",
    "EndDate",
    "UserID",
    "UserName",
    "CompanyID",
    "CompanyName",
    "GymID",
    "GymName"
FROM cleaned_data; 