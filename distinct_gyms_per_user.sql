-- SQL to count gyms per user
CREATE TABLE IF NOT EXISTS distinct_gyms_per_user AS

SELECT
    UserID,
    COUNT(DISTINCT GymID) AS DistinctGymsVisited
FROM cleaned_checkins
GROUP BY UserID
ORDER BY DistinctGymsVisited DESC, UserID; 