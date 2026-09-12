SELECT LENGTH('Hello World!');
SELECT CHAR_LENGTH('Hello World!');

SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('SQL');

-- Case Conversion
SELECT LOWER('SQL');
SELECT UPPER('sql');

-- Substring/Extraction
SELECT LEFT('SQL', 2);
SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL' FROM 2 FOR 2);
SELECT SUBSTRING('SQL', 2, 2);

SELECT SUBSTRING('SQL', 2, 1);

-- Concatenation
SELECT 'SQL' || 'Server';
SELECT CONCAT('SQL', 'Server');

SELECT CONCAT('SQL', '-', 'Server');

SELECT 'SQL' || '-' || 'Server';

-- Trimming: Removes leading and trailing spaces
SELECT ('  SQL  ');
SELECT TRIM('  SQL  ');

-- Replacing
SELECT REPLACE('SQL', 'SQL', 'MySQL');

SELECT REPLACE('SQL', 'Q', '_');

--REGEXP
SELECT REGEXP_REPLACE('email@example.com', '[^@]+', '<email>');

SELECT REGEXP_REPLACE('email@example.com', '^.*(@)', '\1');

SELECT REGEXP_REPLACE('email@example.com', '[^@]+', '\1');

-- Final Example: Text Function
-- Cleanup This using Text Functions
WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)
SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;

-- NULLIF
SELECT NULLIF('SQL', 'SQL');
SELECT NULLIF('SQL', 'Server');
SELECT NULLIF(10, 10);
SELECT NULLIF(10, 20);
SELECT NULLIF(5+5, 10);
SELECT NULLIF(5+5, 5+5);

-- Use cases for NULLIF
SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;

-- From the above query, showing how NULLIF can be used to filter out NULL values
SELECT
    NULLIF(salary_year_avg, 0),
    NULLIF(salary_hour_avg, 0)
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;

SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;

-- COALESCE
SELECT COALESCE('SQL', 'Server');
SELECT COALESCE(0, 1, 2);

SELECT COALESCE(NULL, 1, 2);
SELECT COALESCE(1, NULL, 2);
SELECT COALESCE(NULL, NULL, 2);

--Use cases for COALESCE
SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS standardized_salary
FROM
    job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;

-- Final Example: Simplify with COALESCE
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;



