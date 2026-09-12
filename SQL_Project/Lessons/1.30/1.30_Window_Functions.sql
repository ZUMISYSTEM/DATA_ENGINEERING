-- Count Rows - Aggregation Only
SELECT
    COUNT(*) AS total_postings
FROM job_postings_fact;

-- Count Rows - Window Function
SELECT
    Job_id
FROM job_postings_fact;

-- Using Window Functions
SELECT
    Job_id,
    COUNT(*) OVER() AS total_postings
FROM job_postings_fact;

-- Partition By (Group By): Find average salary by job title
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER() AS avg_salary_hour
FROM job_postings_fact
LIMIT 10;

-- Validating the results
SELECT
    AVG(salary_hour_avg) OVER() AS avg_salary_hour
FROM job_postings_fact
LIMIT 10;

-- Group By (Partition By): Find average salary by job title
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
    ) AS avg_salary_hour
FROM job_postings_fact;

SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
    ) AS avg_salary_hour
FROM job_postings_fact
ORDER BY
    RANDOM()
LIMIT 10;

-- Adding 2nd Partition By: Find average salary by job title and company
SELECT
    Job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    ) AS avg_salary_hour
FROM job_postings_fact
ORDER BY
    RANDOM()
LIMIT 10;

-- filtering where salary hour is Not NULL
SELECT
    Job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    ) AS avg_salary_hour
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM()
LIMIT 10;

-- ORDER BY: Ranking Hourly Salaries
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
-- ORDER BY
--     salary_hour_avg DESC -- Good prectise to always use ORDER BY
LIMIT 10;

-- PARTITION BY AND ORDER BY: Running Average Hourly Salary
SELECT
   job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;

-- Filtering where job title is Data Engineer
SELECT
   job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;

-- PARTITION BY AND ORDER BY: Ranking by job_title_short
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    salary_hour_avg DESC
LIMIT 10;

-- To get the highest salary hour odrder by salary_hour_avg DESC first
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;

-- R RANK Functions - RANK()  VS DENSE_RANK()
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 10;

-- Let increase the limit from the results there is repitition of the ranks
-- The Rank jumps from 9 to 139
    Job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 140;

-- Using DENSE_RANK() instead of RANK() to avoid the jump
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 140;

-- ROW_NUMBER() Function: Providing a new job_id column
SELECT
    *,
    ROW_NUMBER() OVER(
        ORDER BY job_posted_date
     ) AS row_number
FROM
    job_postings_fact
ORDER BY
    job_posted_date
Limit 20;

-- Using ROW_NUMBER() instead of RANK() to avoid the jump or repetition
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    ROW_NUMBER() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 140;

-- Sorting the above results
SELECT
    Job_id,
    job_title_short,
    salary_hour_avg,
    ROW_NUMBER() OVER(
        ORDER BY salary_hour_avg DESC
     ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    rank_hourly_salary
LIMIT 140;

-- LAG() Function: Time Based Comparison of Companies yearly salary
SELECT
    Job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT 60;

-- we to see the change in salary over time
SELECT
    Job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change,
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT 60;

-- LEAD() Function: Time Based Comparison of Companies yearly salary
SELECT
    Job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change,
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT 60;
