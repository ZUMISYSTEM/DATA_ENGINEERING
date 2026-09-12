-- .read SQL_Project/Lessons/1.21_DDL_DML_Pt.sql

-- =====================================================
-- Setup: jobs_mart database + staging schema (DuckDB)
-- =====================================================

-- Run from the CLI to create/open the database file:
--   duckdb jobs_mart.duckdb
-- (we're not using that path here — see CREATE DATABASE below instead)

-- Switch to a different database before dropping the current one
USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart; -- drop the database and crete from scratch

CREATE DATABASE IF NOT EXISTS jobs_mart; -- create a database smart.

-- Confirm it exists
SHOW DATABASES;

SELECT *
FROM information_schema.schemata; -- show all tables in the database

/*
the default schema is main and cannot be deleted
- create a schema staging
- add jobs_mart.staging to the search path to avoid creating the schema in a different database
- since our initial login is through data_jobs, we do not want to create the new schema under data_jobs
*/

-- Switch context so subsequent statements target jobs_mart, not the default
USE jobs_mart;

-- Create a staging schema inside jobs_mart (not main, not another database)
CREATE SCHEMA IF NOT EXISTS staging;

-- DROP SCHEMA IF EXISTS staging; -- drop the staging schema

-- Confirm schema creation
SHOW SCHEMAS;

-- Create a staging table
CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id   INTEGER PRIMARY KEY,
    role_name VARCHAR
);


-- Verify the table landed in the right catalog/schema
SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

-- Cleanup: remove a table that was mistakenly created in main
-- (leftover from an earlier run, before you scoped everything to staging)
DROP TABLE IF EXISTS main.preferred_roles;

-- DROP TABLE IF EXISTS staging.preferred_roles;
-- DROP TABLE  IF EXISTS main.preferred_roles;

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Sotware Engineer');

SELECT *
FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 or role_id = 2;

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM staging.priority_roles;