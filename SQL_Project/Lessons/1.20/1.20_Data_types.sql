SELECT
    *
FROM information_schema.columns;

-- view of selected columns from table_name job_postings_fact to view data types
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact; -- This command is not universally supported by all databases


-- describe can be used on top of a query to get the data type of each column
DESCRIBE
SELECT
    job_title_short,
    salary_year_avg
FROM
    job_postings_fact;

-- Casting operator can be used to convert data types to other types in a query
SELECT CAST(123 AS VARCHAR);

SELECT CAST('123DEF' AS INTEGER); -- This will return an error

SELECT CAST('123' AS INTEGER); -- This will return 123 as an integer

SELECT
    job_id, -- "more" unique identifier
    job_work_from_home, -- from boolean to numeric
    job_posted_date, -- from timestamp to date only
    salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
LIMIT 10;

-- Using CAST function to convert data types
-- See Duckdb documentation for more information
SELECT
    job_id, -- "more" unique identifier
    CAST(job_work_from_home AS INTEGER) AS job_work_from_home, -- from boolean to numeric
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

/*
Combining job_id and company_id to create a unique identifier
Firt convert both job_id and company_id to string
Then concatenate them together
*/
SELECT
    CAST(job_id AS VARCHAR), -- "more" unique identifier
    CAST(company_id AS VARCHAR) AS company_id, -- unique identifier
    CAST(job_work_from_home AS INTEGER) AS job_work_from_home, -- from boolean to numeric
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- concatenate job_id and company_id
SELECT
    CAST(job_id AS VARCHAR) || CAST(company_id AS VARCHAR) AS job_id_company_id, -- "more" unique identifier
    CAST(job_work_from_home AS INTEGER) AS job_work_from_home, -- from boolean to numeric
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- put hyphen between job_id and company_id
SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR) AS job_id_company_id, -- "more" unique identifier
    CAST(job_work_from_home AS INTEGER) AS job_work_from_home, -- from boolean to numeric
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

/*
Instead of using CAST function,  DuckDB uses the double colon :: operator to convert data types
*/
SELECT
    job_id::VARCHAR || '-' || company_id::VARCHAR AS unique_id, -- "more" unique identifier
    job_work_from_home::INT AS job_work_from_home, -- from boolean to numeric
    job_posted_date::DATE AS job_posted_date, -- from timestamp to date only
    salary_year_avg::DECIMAL(10,0) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


-- Using the CONCAT function to concatenate strings
SELECT
    CONCAT(job_id, '-', company_id) AS unique_id, -- "more" unique identifier
    job_work_from_home AS job_work_from_home, -- from boolean to numeric
    job_posted_date AS job_posted_date, -- from timestamp to date only
    salary_year_avg AS salary_year_avg -- from double to no decimal places