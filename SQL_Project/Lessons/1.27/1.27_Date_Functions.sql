-- Selecting date from job_postings_fact table
SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

-- casting job_posted_date to different date types. the date type was stored as UTC
SELECT
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestamptz -- convert it to local time zone using UTC
FROM job_postings_fact
LIMIT 10;


--DATE_TRUNCing year from job_posted_date
SELECT
    job_posted_date,
   DATE_TRUNC(YEAR FROM job_posted_date) AS job_posted_year,
   DATE_TRUNC(`month` FROM job_posted_date) AS job_posted_`month`,
   DATE_TRUNC(DAY FROM job_posted_date) AS job_posted_day
FROM job_postings_fact
LIMIT 10;

-- Aggregating on a `month`ly basis
SELECT
   DATE_TRUNC(YEAR FROM job_posted_date) AS job_posted_year,
   DATE_TRUNC(`month` FROM job_posted_date) AS job_posted_`month`,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
   DATE_TRUNC(YEAR FROM job_posted_date),
   DATE_TRUNC(`month` FROM job_posted_date) -- DuckDB allows to use alias in GROUP BY
ORDER BY
    job_posted_year,
    job_posted_`month`;

--  Date_Trunc - Rounding the date to the nearest unit
SELECT
    job_posted_date,
    DATE_TRUNC('`month`', job_posted_date) AS job_posted_`month`
FROM job_postings_fact
LIMIT 10;

SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter', job_posted_date) AS truncated_quarter,
    DATE_TRUNC('`month`', job_posted_date) AS truncated_`month`,
    DATE_TRUNC('week', job_posted_date) AS truncated_week,
    DATE_TRUNC('day', job_posted_date) AS truncated_day,
    DATE_TRUNC('hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;


SELECT
   DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
   DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;

-- Extracting year 2024
SELECT
   DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE
    job_title_short = 'Data Engineer' AND
    EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
   DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;

-- Using the DATE_TRUNC instead of EXTRACT but easier to use Extract
SELECT
   DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE
    job_title_short = 'Data Engineer' AND
    DATE_TRUNC('year', job_posted_date) = '2024-01-01'
GROUP BY
   DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;

-- Timestamps with Time zone:
SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AS timestamptz; -- we cast because the time is a string

SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'EST' AS timestamptz;

-- Timestamps without Time zone:
-- No time zone specified in our job_postings_fact table. it was stored as UTC
SELECT
    job_posted_date
FROM job_postings_fact
LIMIT 10;

-- To add time zone and convert it to UTC firts then  to local time we can use AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS job_posted_date_est
FROM job_postings_fact
LIMIT 10;

-- filtering
SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS job_posted_date_est
FROM job_postings_fact
WHERE
    job_location LIKE '%Toronto%';

-- What time are jobs being posted in Toronto?
SELECT
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE
    job_location LIKE '%Toronto%'
GROUP BY
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY
    job_posted_hour;