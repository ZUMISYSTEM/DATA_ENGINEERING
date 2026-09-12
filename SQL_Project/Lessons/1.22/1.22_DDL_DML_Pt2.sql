-- .read SQL_Project/Lessons/1.22_DDL_DML_Pt2.sql
-- ===============================================================
-- CTAS - CREATE TABLE AS SELECT
--===============================================================

/*
CTAS is a feature of DuckDB that allows you to create a table from a query.

The syntax is:

CREATE TABLE [IF NOT EXISTS] table_name AS SELECT query;

The query can be any SELECT statement, including a subquery.

DuckDB will create a new table with the same name as the CTAS statement.
*/

-- Creating table job_postings_flat AS a CTAS from job_postings_fact and company_dim

CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT *
FROM staging.job_postings_flat
LIMIT 10;

SELECT COUNT(*)
FROM staging.job_postings_flat;


-- ==============================
-- CREATE VIEW: virtual table
-- ================================

CREATE OR REPLACE VIEW staging.job_postings_flat_view AS
SELECT
    jpf.*
FROM staging.job_postings_flat AS jpf
JOIN staging.priority_roles AS pr
    ON jpf.job_title_short = pr.role_name -- we can't use job_id because it doesn't match with role_id
WHERE pr.priority_lvl = 1;

SELECT COUNT(*)
FROM staging.job_postings_flat_view;

SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM staging.job_postings_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;

-- ==============================
-- CREATE TEMP TABLE: temporary table
-- ================================

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.job_postings_flat_view
WHERE job_title_short = 'Senior Data Engineer';

SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp
GROUP BY job_title_short
ORDER BY job_count DESC;

-- =========================================
-- DELETE: remove data from a table
-- TRUNCATE: remove all data from a table
-- DROP : remove a table
-- =========================================

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.job_postings_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.job_postings_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

-- TRUNCATE
TRUNCATE TABLE staging.job_postings_flat;
SELECT COUNT(*) FROM staging.job_postings_flat;

SELECT * FROM staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_posted_date >= '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.job_postings_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;