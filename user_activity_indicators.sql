-- User activity indicators
CREATE TABLE IF NOT EXISTS user_activity_indicators AS

WITH 
checkins_week1 AS (
    SELECT 
        UserID,
        COUNT(*) AS CheckinCountWeek1
    FROM cleaned_checkins
    WHERE CohortWeek = 1
    GROUP BY UserID
),

checkin_sources AS (
    SELECT 
        UserID,
        COUNT(DISTINCT CheckinSource) AS DistinctSources
    FROM cleaned_checkins
    GROUP BY UserID
),

user_checkins AS (
    SELECT
        UserID,
        CheckinTime,
        ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY CheckinTime) AS CheckinRank
    FROM cleaned_checkins
),

checkin_differences AS (
    SELECT
        current.UserID,
        (julianday(current.CheckinTime) - julianday(previous.CheckinTime)) AS DaysBetweenCheckins
    FROM user_checkins current
    JOIN user_checkins previous
        ON current.UserID = previous.UserID
        AND current.CheckinRank = previous.CheckinRank + 1
    WHERE (julianday(current.CheckinTime) - julianday(previous.CheckinTime)) BETWEEN 1 AND 100
),

avg_between_checkins AS (
    SELECT
        UserID,
        AVG(DaysBetweenCheckins) AS AvgDaysBetweenCheckins
    FROM checkin_differences
    GROUP BY UserID
),

active_weeks AS (
    SELECT
        UserID,
        COUNT(DISTINCT CohortWeek) AS DistinctWeeks
    FROM cleaned_checkins
    GROUP BY UserID
)

SELECT DISTINCT
    u.UserID,
    CASE 
        WHEN IFNULL(cw1.CheckinCountWeek1, 0) >= 2 THEN 'TRUE'
        ELSE 'FALSE'
    END AS Check_ins_2,
    
    CASE 
        WHEN IFNULL(cs.DistinctSources, 0) > 1 THEN 'TRUE'
        ELSE 'FALSE'
    END AS CheckinSource_1,
    
    CASE 
        WHEN abc.AvgDaysBetweenCheckins IS NULL THEN 'FALSE'
        WHEN abc.AvgDaysBetweenCheckins <= 9 THEN 'TRUE'
        ELSE 'FALSE'
    END AS AvgBetweenCheckin_1,
    
    CASE 
        WHEN IFNULL(aw.DistinctWeeks, 0) > 1 THEN 'TRUE'
        ELSE 'FALSE'
    END AS WeekActive_1
FROM 
    (SELECT DISTINCT UserID FROM cleaned_checkins) u
LEFT JOIN checkins_week1 cw1 ON u.UserID = cw1.UserID
LEFT JOIN checkin_sources cs ON u.UserID = cs.UserID
LEFT JOIN avg_between_checkins abc ON u.UserID = abc.UserID
LEFT JOIN active_weeks aw ON u.UserID = aw.UserID
ORDER BY u.UserID; 