-- Average check-in frequency
CREATE TABLE IF NOT EXISTS avg_checkin_frequency AS

WITH user_checkins AS (
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
)

SELECT
    UserID,
    AVG(DaysBetweenCheckins) AS AverageCheckInFrequency,
    COUNT(*) AS TotalConsecutiveCheckins
FROM checkin_differences
GROUP BY UserID
HAVING COUNT(*) >= 2
ORDER BY UserID; 