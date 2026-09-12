-- Craating a list in SQL
SELECT [1, 1, 1, 2];

-- Using a function to the list values into rows
SELECT UNNEST([1, 1, 1, 2]);

SELECT UNNEST([1, 1, 3]);

-- UNION: returns distinct rows
SELECT UNNEST([1, 1, 1, 2])
UNION
SELECT UNNEST([1, 1, 3]);

--  UNION ALL: returns all rows
SELECT UNNEST([1, 1, 1, 2])
UNION ALL
SELECT UNNEST([1, 1, 3]);

-- INTERSECT: returns rows that are common to both sets. Duplicates are removed
SELECT UNNEST([1, 1, 1, 2])
INTERSECT
SELECT UNNEST([1, 1, 3]);

-- INTERSECT ALL: returns all rows that are common to both sets. Duplicates preserved
SELECT UNNEST([1, 1, 1, 2])
INTERSECT ALL
SELECT UNNEST([1, 1, 3]);

-- Except: returns rows that are in the first set but not the second set. Duplicates are removed
SELECT UNNEST([1, 1, 1, 2])
EXCEPT
SELECT UNNEST([1, 1, 3]);

-- Except All: returns all rows that are in the first set but not the second set. Duplicates remove one for one.
SELECT UNNEST([1, 1, 1, 2])
EXCEPT ALL
SELECT UNNEST([1, 1, 3]);

--  Final Example
CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2023;

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024;

-- Which unique job postings appeared in either 2023 or 2024?
SELECT COUNT(*) FROM jobs_2023
UNION
SELECT COUNT(*) FROM jobs_2024;

SELECT
    'jobs_2023' AS table_name,
    COUNT(*) AS row_count
 FROM jobs_2023
UNION
SELECT
    'jobs_2024' AS table_name,
    COUNT(*)
FROM jobs_2024;

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

-- Which job postings appeared across both years, counting duplicates?
SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared in 2023 but not in 2024?
SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

-- Which job postings from 2023 remain after subtracting natch 2024 postings, one-for-one?
SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared in both 2023 and 2024?
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

-- Which job postings appeared in both 2023 and 2024, counting duplicates or preserving duplicates counts?
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;