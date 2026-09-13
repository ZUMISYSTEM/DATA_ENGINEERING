-- Step 2: Loading data from CSV files into the DW-Mart star schema tables
-- Run this 2nd after Step 1
-- Note: Update the GCS bucket path with your actual bucket name.quit

SELECT '=== Loading company_dim Table ===' AS 'loading data';

-- Load dimension tables first (no FK dependencies)
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true,
    HEADER=true);

SELECT '=== Skills Dimension Sample ===' AS 'loading data';

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=true,
    HEADER=true)
WHERE skills IS NOT NULL;

SELECT '=== Job Postings Fact Sample ===' AS 'loading data';

-- Load fact table second (FK references company_dim - must load after dimensions)
INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location,
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance,
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT
    job_id, company_id, job_title_short, job_title, job_location,
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance,
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=true,
    HEADER=true);

SELECT '=== Skills Job Dim Sample ===' AS 'loading data';

-- Load bridge table last (FKs reference skills_dim and job_postings_fact)
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=true,
    HEADER=true);

-- Verify data was loaded correctly
SELECT 'Company Dimension' AS table_name, COUNT(*) as record_count FROM company_dim
UNION ALL
SELECT 'Skills Dimension', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Bridge', COUNT(*) FROM skills_job_dim;

SELECT '=== Company Dimension Sample ===' AS 'loading data';
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS 'loading data';
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS 'loading data';
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills Job Bridge Sample ===' AS 'loading data';
SELECT * FROM skills_job_dim LIMIT 5;

