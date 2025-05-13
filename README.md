# Check-in Analysis

This collection of SQL scripts analyzes check-in data to extract insights about user behavior.

## Scripts Overview

### 1. Clean Checkins Data
- Cleans and normalizes raw check-in data
- Removes duplicates and standardizes formats
- Table: `cleaned_checkins`

### 2. Distinct Gyms Per User
- Counts how many different gyms each user visited
- Table: `distinct_gyms_per_user`

### 3. Average Check-in Frequency
- Calculates average days between consecutive check-ins
- Only includes users with 2+ check-in intervals
- Table: `avg_checkin_frequency`

### 4. User Activity Indicators
- Creates Boolean flags for user activity patterns:
  - 2+ check-ins in first week
  - Multiple check-in sources used
  - Average days between check-ins ≤ 9
  - Active across multiple weeks
- Table: `user_activity_indicators`

### 5. Top Users (Percentile)
- Identifies frequent users (3+ occurrences)
- Uses simple flag: 1 = frequent user, 0 = not frequent
- Table: `top_users_percentile`

### 6. Retention by Cohort
- Calculates user retention rates by cohort month
- Shows distinct users per week and retention percentages
- Only includes Sep and Oct 2023 cohorts, weeks 1-5
- Table: `retention_by_cohort`
