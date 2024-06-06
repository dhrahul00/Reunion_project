--to interchange start time and end time where start time is greater than end time 
UPDATE timeseries
SET start_time = end_time,
    end_time = start_time
WHERE start_time > end_time;

WITH OrderedTasks AS (
    SELECT
        timeseries.namid,
        timeseries.start_time,
        timeseries.end_time,
        timeseries.activities,
        LAG(end_time) OVER (PARTITION BY timeseries.namid ORDER BY start_time) AS prev_end_time
    FROM
        timeseries
),
GroupedTasks AS (
    SELECT
        OrderedTasks.namid,
        OrderedTasks.start_time,
        OrderedTasks.end_time,
        OrderedTasks.activities,
        CASE 
			WHEN prev_end_time IS NULL OR OrderedTasks.start_time > prev_end_time THEN 1 
			ELSE 0 
		END AS group_id
    FROM
        OrderedTasks
),
periods_with_numbers AS (
    SELECT 
        GroupedTasks.namid,
        GroupedTasks.start_time,
        GroupedTasks.end_time,
        GroupedTasks.activities,
        SUM(group_id) OVER (PARTITION BY GroupedTasks.namid ORDER BY GroupedTasks.start_time) AS period_number
    FROM GroupedTasks
),

aggregated_activities AS (
    SELECT 
       	periods_with_numbers.namid, 
    	MIN(periods_with_numbers.start_time) AS period_start, 
        MAX(periods_with_numbers.end_time) AS period_end, 
        STRING_AGG(periods_with_numbers.activities, ', ' ORDER BY periods_with_numbers.start_time) AS activities
    FROM periods_with_numbers
    GROUP BY periods_with_numbers.namid, period_number
)

SELECT *
FROM aggregated_activities
ORDER BY period_start,namid;


