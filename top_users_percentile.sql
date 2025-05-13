-- Identify frequent users
CREATE TABLE IF NOT EXISTS top_users_percentile AS

SELECT
    UserID,
    COUNT(UserName) AS TotalUserNameOccurrences,
    CASE 
        WHEN COUNT(UserName) >= 3 THEN 1
        ELSE 0
    END AS Top20Percentile
FROM cleaned_checkins
GROUP BY UserID
ORDER BY TotalUserNameOccurrences DESC, UserID;
