CREATE TABLE IF NOT EXISTS cleaned_checkins AS

WITH cleaned_data AS (

    SELECT DISTINCT
        CAST(TRIM("Index") AS NUMERIC) AS "Index",
        TRIM("Type") AS "Type",
        TRIM("RecordStatus") AS "RecordStatus",
        DATE(TRIM("CheckinDate")) AS "CheckinDate",
        CAST(TRIM("CohortDay") AS INTEGER) AS "CohortDay",
        LOWER(TRIM("Industry")) AS "Industry",
        TRIM("CheckinSource") AS "CheckinSource",
        DATETIME(TRIM("CheckinTime")) AS "CheckinTime",
       
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


SELECT 
    "Index",
    "Type",
    "RecordStatus",
    "CheckinDate",
    "CohortDay",

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
