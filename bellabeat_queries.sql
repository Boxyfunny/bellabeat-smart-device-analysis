-- Bellabeat Case Study SQL Queries
-- Project/Dataset used: fitbeatdata.fitbit_data
-- Notes:
-- 1. Some tables were uploaded as strings and then cleaned in BigQuery.
-- 2. Replace table names if your uploaded names differ slightly.

-- =====================================================
-- 1) CLEANING QUERIES
-- =====================================================

-- sleepDay cleaned
CREATE OR REPLACE TABLE `fitbeatdata.fitbit_data.sleepDay_cleaned` AS
SELECT
  SAFE_CAST(Id AS INT64) AS Id,
  SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', SleepDay) AS SleepDay,
  SAFE_CAST(TotalSleepRecords AS INT64) AS TotalSleepRecords,
  SAFE_CAST(TotalMinutesAsleep AS INT64) AS TotalMinutesAsleep,
  SAFE_CAST(TotalTimeInBed AS INT64) AS TotalTimeInBed
FROM `fitbeatdata.fitbit_data.sleepDay`
WHERE SleepDay != 'SleepDay';

-- hourlySteps cleaned
CREATE OR REPLACE TABLE `fitbeatdata.fitbit_data.hourlySteps_cleaned` AS
SELECT
  SAFE_CAST(Id AS INT64) AS Id,
  SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour,
  SAFE_CAST(StepTotal AS INT64) AS StepTotal
FROM `fitbeatdata.fitbit_data.hourlySteps`
WHERE ActivityHour != 'ActivityHour';

-- hourlyCalories cleaned
CREATE OR REPLACE TABLE `fitbeatdata.fitbit_data.hourlyCalories_cleaned` AS
SELECT
  SAFE_CAST(Id AS INT64) AS Id,
  SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour,
  SAFE_CAST(Calories AS FLOAT64) AS Calories
FROM `fitbeatdata.fitbit_data.hourlyCalories`
WHERE ActivityHour != 'ActivityHour';

-- hourlyIntensities cleaned
CREATE OR REPLACE TABLE `fitbeatdata.fitbit_data.hourlyIntensities_cleaned` AS
SELECT
  SAFE_CAST(Id AS INT64) AS Id,
  SAFE.PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour,
  SAFE_CAST(TotalIntensity AS INT64) AS TotalIntensity,
  SAFE_CAST(AverageIntensity AS FLOAT64) AS AverageIntensity
FROM `fitbeatdata.fitbit_data.hourlyIntensities`
WHERE ActivityHour != 'ActivityHour';

-- Optional: remove an accidentally created table if needed
DROP TABLE IF EXISTS `fitbeatdata.fitbit_data.dailyActivity_cleaned`;

-- =====================================================
-- 2) EXPLORATION / VALIDATION QUERIES
-- =====================================================

-- Distinct users in daily activity
SELECT COUNT(DISTINCT Id) AS distinct_users
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Total rows in daily activity
SELECT COUNT(*) AS total_rows
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Date range in daily activity
SELECT MIN(ActivityDate) AS min_date, MAX(ActivityDate) AS max_date
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Days recorded per user (device usage consistency)
SELECT
  Id,
  COUNT(ActivityDate) AS days_recorded
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`
GROUP BY Id
ORDER BY days_recorded DESC;

-- Average daily steps by user
SELECT
  Id,
  AVG(TotalSteps) AS avg_daily_steps
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`
GROUP BY Id
ORDER BY avg_daily_steps DESC;

-- Average activity minutes by intensity type
SELECT
  AVG(VeryActiveMinutes) AS avg_very_active,
  AVG(FairlyActiveMinutes) AS avg_fairly_active,
  AVG(LightlyActiveMinutes) AS avg_lightly_active,
  AVG(SedentaryMinutes) AS avg_sedentary
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Average sleep hours
SELECT
  AVG(TotalMinutesAsleep) / 60 AS avg_sleep_hours
FROM `fitbeatdata.fitbit_data.sleepDay_cleaned`;

-- Average sleep vs time in bed
SELECT
  AVG(TotalMinutesAsleep) AS avg_sleep_minutes,
  AVG(TotalTimeInBed) AS avg_time_in_bed_minutes
FROM `fitbeatdata.fitbit_data.sleepDay_cleaned`;

-- Daily activity and sleep relationship (basic join)
SELECT
  AVG(a.TotalSteps) AS avg_steps,
  AVG(s.TotalMinutesAsleep) AS avg_sleep_minutes
FROM `fitbeatdata.fitbit_data.dailyActivity_merged` a
JOIN `fitbeatdata.fitbit_data.sleepDay_cleaned` s
  ON a.Id = s.Id
 AND a.ActivityDate = DATE(s.SleepDay);

-- =====================================================
-- 3) TABLEAU EXPORT / VISUALIZATION QUERIES
-- =====================================================

-- Average daily steps KPI
SELECT
  AVG(TotalSteps) AS avg_daily_steps
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Steps by weekday
SELECT
  FORMAT_DATE('%A', ActivityDate) AS weekday,
  AVG(TotalSteps) AS avg_steps
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`
GROUP BY weekday
ORDER BY avg_steps DESC;

-- Weekday vs weekend activity
SELECT
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM ActivityDate) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  AVG(TotalSteps) AS avg_steps
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`
GROUP BY day_type
ORDER BY avg_steps DESC;

-- Activity intensity breakdown
SELECT
  AVG(SedentaryMinutes) AS sedentary,
  AVG(LightlyActiveMinutes) AS lightly_active,
  AVG(FairlyActiveMinutes) AS fairly_active,
  AVG(VeryActiveMinutes) AS very_active
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`;

-- Activity by hour
SELECT
  EXTRACT(HOUR FROM ActivityHour) AS hour,
  AVG(StepTotal) AS avg_steps
FROM `fitbeatdata.fitbit_data.hourlySteps_cleaned`
GROUP BY hour
ORDER BY hour;

-- Sleep duration KPI
SELECT
  AVG(TotalMinutesAsleep) / 60 AS avg_sleep_hours
FROM `fitbeatdata.fitbit_data.sleepDay_cleaned`;

-- Sleep efficiency / time in bed comparison
SELECT
  AVG(TotalMinutesAsleep) AS avg_sleep,
  AVG(TotalTimeInBed) AS avg_time_in_bed
FROM `fitbeatdata.fitbit_data.sleepDay_cleaned`;

-- Device usage consistency for charting
SELECT
  Id,
  COUNT(ActivityDate) AS days_used
FROM `fitbeatdata.fitbit_data.dailyActivity_merged`
GROUP BY Id
ORDER BY days_used DESC;
