-- Create a table with the retention results
CREATE TABLE IF NOT EXISTS retention_by_cohort AS

-- Count distinct users per cohort week and cohort month
WITH cohort_data AS (
    SELECT
        StartDate,
        CohortWeek,
        COUNT(DISTINCT UserID) AS DistinctUsers
    FROM cleaned_checkins
    WHERE 
        StartDate IN ('2023-09-01', '2023-10-01')
        AND CohortWeek BETWEEN 1 AND 5 
    GROUP BY StartDate, CohortWeek
),

-- Calculate total users per cohort month
cohort_totals AS (
    SELECT 
        StartDate,
        SUM(DistinctUsers) AS TotalUsers
    FROM cohort_data
    GROUP BY StartDate
)

-- Calculate retention rates
SELECT 
    c.StartDate AS CohortMonth,
    c.CohortWeek,
    c.DistinctUsers AS WeeklyUsers,
    t.TotalUsers AS MonthlyTotalUsers,
    -- Calculate retention rate as percentage
    ROUND((CAST(c.DistinctUsers AS REAL) / CAST(t.TotalUsers AS REAL)) * 100, 2) AS RetentionRate
FROM cohort_data c
JOIN cohort_totals t ON c.StartDate = t.StartDate
ORDER BY c.StartDate, c.CohortWeek; 