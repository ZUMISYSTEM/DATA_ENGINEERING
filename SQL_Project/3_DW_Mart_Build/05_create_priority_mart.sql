-- .read 05_create_priority_mart.sql
-- Step 5: Mart - Create priority roles mart table
-- Run this 5th after Step 4

-- Drop existing priority roles mart schema if it exists (for idempotency)
DROP SCHEMA IF EXISTS priority_mart CASCADE; -- CASCADE: Drop the schema if thera are tables in it

-- Create the priority roles mart schema
CREATE SCHEMA priority_mart;

SELECT '=== Priority Roles Mart Sample ===' AS 'Loading data';
-- Step 2: Create dimension tables
CREATE TABLE priority_mart.priority_roles (
    role_id    INTEGER PRIMARY KEY,
    role_name  VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES
(1, 'Data Engineer', 2),
(2, 'Senior Data Engineer', 1),
(3, 'Software Engineer', 3);

-- Verify mart was created
SELECT * FROM priority_mart.priority_roles;

-- Step 3: Create fact table - priority_jobs_snapshot
SELECT '=== Loading priority_jobs_snapshot for Priority Roles Mart ===' AS 'loading data';
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (
    job_id           INTEGER PRIMARY KEY,
    job_title_short  VARCHAR,
    company_name     VARCHAR,
    job_posted_date  TIMESTAMP,
    salary_year_avg  DOUBLE,
    priority_lvl     INTEGER,
    updated_at       TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;