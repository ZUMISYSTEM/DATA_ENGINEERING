/* FULL OUTER JOIN: returns all rows from the left table, and the matched rows from the right table. Most commonly used */
SELECT
    jpf.*,
    cd.*
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    jpf.job_id,
    cd.name AS company_name,
    jpf.job_title_short
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN
    company_dim AS cd
    ON jpf.company_id = cd.company_id;

/* RIGHT JOIN: returns all rows from the right table, and the matched rows from the left table. less commonly used */
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_country
FROM
    job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

/* INNER JOIN: returns only the rows that have matching values in both tables. originally default join type in SQL.
 Most commonly used for filtering*/
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_country
FROM
    job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

/* FULL JOIN (FULL OUTER JOIN): returns all rows from both tables, and the matched rows from the other table.
Great for checking data completeness */
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_country
FROM
    job_postings_fact AS jpf
FULL JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_country
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;
/* CROSS JOIN: returns all combinations of rows from both tables.*/
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_country
FROM
    job_postings_fact AS jpf
CROSS JOIN company_dim AS cd;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id
FROM job_postings_fact AS jpf
FULL OUTER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
FULL OUTER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
FULL OUTER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
FULL OUTER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
FULL OUTER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
FULL OUTER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
FULL OUTER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

/*
1. Warm-up: INNER JOIN
List the job_title_short, job_location, and company name for every posting where job_country = 'India'.
Tables: job_postings_fact + company_dim
*/

SELECT
    jpf.job_title_short,
    jpf.job_country,
    cd.name AS company_name
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'India';


/*
2. LEFT JOIN — find the gaps
List every company in company_dim along with the number of job postings linked to it, including companies that have zero postings. Order by posting count descending.
Tables: company_dim + job_postings_fact
Hint: think about which table goes on the "preserve all rows" side, and where COUNT() needs a non-null column.
*/

SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS postings_count
FROM company_dim AS cd
LEFT JOIN job_postings_fact AS jpf
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
ORDER BY postings_count DESC
LIMIT 10;

/*
3. Bridge table join (three tables)
List job_title_short and the associated skills for all postings where job_title_short = 'Data Analyst'. Each row should show one job–skill pair.
Tables: job_postings_fact + skills_job_dim + skills_dim
Hint: skills_job_dim has no descriptive info of its own — it exists purely to connect the other two.
*/

SELECT
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst';


/*
4. Aggregation across the bridge
Find the top 10 most in-demand skills (by number of postings requiring them) for
job_title_short = 'Data Engineer'. Return skills, type, and the posting count.
Tables: all four
Hint: you'll join through the bridge table twice conceptually — once to filter by job title,
once to get the skill name — but it's really just one chain of joins plus a GROUP BY.
*/

SELECT
    sd.skills,
    sd.type,
    COUNT(sjd.skill_id) AS postings_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
GROUP BY sd.skills, sd.type
ORDER BY postings_count DESC
LIMIT 10;

/*
5. Challenge: multi-table join + aggregation + filtering
For each skill, calculate the average salary_year_avg across postings that require it,
but only include skills that appear in at least 20 postings with a non-null salary.
Also include the type of each skill. Sort by average salary descending.
Tables: all four
Hint: you'll need GROUP BY, AVG(), COUNT(), and a HAVING clause — and be careful about
where you filter salary_year_avg IS NOT NULL (WHERE vs. it affecting the COUNT in HAVING).
*/

SELECT
    sd.skills,
    sd.type,
    AVG(jpf.salary_year_avg) AS avg_salary_year_avg,
    COUNT(*) AS postings_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.salary_year_avg IS NOT NULL
GROUP BY ALL
HAVING COUNT(*) >= 20
ORDER BY avg_salary_year_avg DESC
LIMIT 10;

