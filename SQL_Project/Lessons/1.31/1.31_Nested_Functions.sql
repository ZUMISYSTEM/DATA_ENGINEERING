-- 1. Array Intro
SELECT [1,2,3];

SELECT ['python','sql','r'] AS skills_array;


WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
)
--SELECT ARRAY_AGG(skill) AS skills_array
SELECT LIST(skill) AS skills_array
FROM skills;


WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    skills
FROM skills_array;

-- indexing
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;

-- ORDER BY: to preserve the alphabetical order of the skills
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;

-- 2. Struct Intro
SELECT {skill: 'python', type: 'programming'} AS skill_struct;

SELECT
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s;


WITH skill_struct AS (
    SELECT
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;

-- Putting this table into a struct
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r' , 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;

-- 3. Array of Structs
SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'},
    {skill: 'r', type: 'programming'}
] AS skills_array_of_structs;

-- Putting this table into an array of structs i.e together in one row
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r' , 'programming'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    )
FROM skill_table;

-- Indexing the array of structs

-- 1. Indexing the array of structs base on the skill and type together
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r' , 'programming'
), skills_array_of_structs AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) array_structs
    FROM skill_table
)
SELECT
    array_structs[1],
    array_structs[2],
    array_structs[3]
FROM skills_array_of_structs;

-- Indexing skill snd type separately for each struct
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r' , 'programming'
), skills_array_of_structs AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) array_structs
    FROM skill_table
)
SELECT
    array_structs[1].skill,
    array_structs[1].type,
    array_structs[2].skill,
    array_structs[2].type,
    array_structs[3].skill,
    array_structs[3].type
FROM skills_array_of_structs;


-- Using the CTE to get the skills array of structs
-- SELECT
--     skills_array_of_structs[1].skill,
--     skills_array_of_structs[1].type,
--     skills_array_of_structs[2].skill,
--     skills_array_of_structs[2].type,
--     skills_array_of_structs[3].skill,
--     skills_array_of_structs[3].type
-- FROM skills_array_of_structs;

-- MAP
-- Map keys must be unique

SELECT MAP {
    'skill' : 'python',
    'type' : 'programming'
} AS skill_struct;

-- indexing the map
WITH skill_map AS (
    SELECT MAP {
        'skill' : 'python',
        'type' : 'programming'
    } AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM skill_map;

-- JSON
SELECT
    '{"skill": "python", "type": "programming"}'::JSON AS skill_json;

-- TO_JSON
SELECT
    TO_JSON('{"skill": "python", "type": "programming"}') AS skill_json;

WITH raw_skill_json AS (
    SELECT
        '{"skill": "python", "type": "programming"}'::JSON AS skill_json
)
SELECT
    skill_json
FROM raw_skill_json;

-- Converting JSON to a struct
WITH raw_skill_json AS (
SELECT
    '{"skill": "python", "type": "programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;

-- JSON to array of structs
WITH raw_json AS (
    SELECT
        '[
            {"skill": "python", "type": "programming"},
            {"skill": "sql", "type": "query_language"},
            {"skill": "r", "type": "programming"}
        ]'::JSON AS skills_json
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := json_extract_string(e.value, '$.skill'),
            type := json_extract_string(e.value, '$.type')
        )
        ORDER BY json_extract_string(skills_json, '$.skill')
    ) AS skills
FROM raw_json, json_each(skills_json) AS e;

-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

-- Build a skills array for each job posting i.e making the skills table into an array of structs

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills)
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;

-- Creating a TEMP table to store the skills array
CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;

SELECT * FROM job_skills_array LIMIT 10;

-- From the perspective of a Data Analyst, analyse the median salary per skill

-- Demonstrating what we want to achieve base on the 2 examples below
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    skills
FROM skills_array;

-- Unnest the skills array: making the skills vertical

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' AS skill
    UNION ALL
    SELECT 'r' AS skill
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    UNNEST(skills)
FROM skills_array;

-- This section is answer to the question asked above
-- From the perspective of a Data Analyst, analyse the median salary per skill
-- Breaking the skills into individual rows

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM
    job_skills_array
LIMIT 10;

-- analyse the median salary per skill
WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;

-- Array of Structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, and skills in one table

SELECT
    *
FROM skills_dim
LIMIT 20;

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyse the median salary per type of skill

-- Unnesting into one column of skill_type and skill_name
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type) AS skill_type,
FROM
    job_skills_array_struct;

-- Unnesting the skills_type and skill_name into separate columns
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type AS skill_type,
    UNNEST(skills_type).skill_name AS skill_name
FROM
    job_skills_array_struct;

-- Analyse the median salary per type of skill
WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name AS skill_name
    FROM
        job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;