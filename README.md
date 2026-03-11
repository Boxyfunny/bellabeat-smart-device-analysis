# Bellabeat Case Study

## Project Overview
This project analyzes Fitbit smart device data to identify behavior patterns that can help inform Bellabeat's marketing strategy. The goal was to understand how consumers use non-Bellabeat smart devices and translate those findings into practical business recommendations for Bellabeat.

## Business Task
Analyze smart device usage data to answer three questions:
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

## Tools Used
- **Google Sheets** for early inspection and basic cleanup
- **BigQuery / SQL** for cleaning, transformation, and analysis
- **Tableau** for dashboard creation and visualization
- **Word / DOCX** for final report writing

## Data Source
The project uses the **FitBit Fitness Tracker Data** dataset from Kaggle (Mobius). The dataset contains fitness tracker information from 30 users and includes daily activity, sleep, and hourly activity records.

Core tables used:
- `dailyActivity_merged`
- `sleepDay`
- `hourlySteps`
- `hourlyCalories`
- `hourlyIntensities`

## Data Cleaning Summary
Several raw tables were uploaded into BigQuery as strings because of formatting problems during import. SQL was then used to clean and standardize the data.

Main processing steps:
- Converted `Id` fields to numeric values using `SAFE_CAST`
- Parsed date and datetime fields using `SAFE.PARSE_DATETIME`
- Converted steps, calories, and activity intensity columns into numeric data types
- Removed header rows that were accidentally imported as data
- Created cleaned tables for sleep and hourly activity datasets

## Key Findings
### 1. Device usage was mostly consistent
About 24 users recorded activity for around 30 to 31 days, showing strong engagement. A few users recorded far fewer days, with one user recording only 4 days.

### 2. Users were mostly sedentary
Average sedentary minutes were much higher than very active minutes. Sedentary time dominated daily activity patterns.

### 3. Users moved mainly between 7:00 and 21:00
Hourly step data showed activity rising in the morning and continuing through the evening, suggesting movement tied to work routines, commuting, or evening exercise.

### 4. Average sleep was slightly below recommended levels
Users averaged about 6.99 hours of sleep, which is slightly below the commonly recommended 7 to 9 hours.

### 5. No strong activity-sleep relationship was immediately clear
The available data did not show a strong obvious relationship between steps and sleep duration in the initial analysis.

## Business Recommendations
1. **Promote daily movement goals**  
   Bellabeat can encourage users to move more by highlighting step targets, reminders, and activity nudges.

2. **Emphasize sleep features**  
   Bellabeat can market sleep tracking and recovery insights as a way to help users improve rest quality and duration.

3. **Use engagement timing strategically**  
   Since activity tends to happen between morning and evening hours, Bellabeat can time app notifications and wellness prompts to align with peak activity windows.

## Tableau Dashboard
Suggested dashboard components:
- Average Daily Steps KPI
- Average Sleep Duration KPI
- Steps by Weekday
- Weekday vs Weekend Activity
- Activity by Hour
- Activity Intensity Breakdown
- Device Usage Consistency

## Files Included
- `bellabeat_queries.sql` — SQL queries used for cleaning and analysis
- `bellabeat_case_study_report.docx` — written project report
- `README.md` — project summary and explanation
