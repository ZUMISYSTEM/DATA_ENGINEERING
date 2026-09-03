/*
Question 1 — Skill Demand
What are the most in-demand skills for Data Analysts, Data Engineers, and Data Scientists in Canada?
Objective:
- Identify the top 5 skills employers request most.
- how do skills requirement differ for each of the three data roles.
- Focus on skills in Canada.
*/

WITH skill_demand AS (
    SELECT
        jpf.job_title_short,
        sd.skills AS skill,
        COUNT(DISTINCT jpf.job_id) AS job_count,
        ROW_NUMBER() OVER (
            PARTITION BY jpf.job_title_short
            ORDER BY COUNT(DISTINCT jpf.job_id) DESC
        ) AS skill_rank
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE LOWER(TRIM(jpf.job_country)) = 'canada'
        AND jpf.job_title_short IN (
            'Data Analyst', 'Data Engineer', 'Data Scientist'
        )
    GROUP BY jpf.job_title_short, sd.skills
)
SELECT job_title_short, skill, job_count, skill_rank
FROM skill_demand
WHERE skill_rank <= 5
ORDER BY job_title_short, skill_rank;

/*
### Result

The results show clear differences in skill demand across the three roles in Canada:

* **Data Analyst:** SQL is the most demanded skill (2,529 postings), followed by Python and Excel. Visualization tools such as Tableau and Power BI are also highly relevant.
* **Data Engineer:** SQL (9,345) and Python (8,967) dominate, followed by cloud and big-data technologies such as Azure, AWS, and Spark.
* **Data Scientist:** Python leads (2,900), followed by SQL (2,514) and R (1,184). Cloud skills such as AWS and Azure also appear in the top five.

**Key insight:**
SQL and Python are common across all three roles, while each role has specialized requirements. Data Analysts emphasize **analytics and visualization**, Data Engineers emphasize **cloud and big-data technologies**, and Data Scientists emphasize **programming and statistical tools**.

─────────────────┬──────────┬───────────┬────────────┐
│ job_title_short │  skill   │ job_count │ skill_rank │
│     varchar     │ varchar  │   int64   │   int64    │
├─────────────────┼──────────┼───────────┼────────────┤
│ Data Analyst    │ sql      │      2529 │          1 │
│ Data Analyst    │ python   │      1714 │          2 │
│ Data Analyst    │ excel    │      1519 │          3 │
│ Data Analyst    │ tableau  │      1253 │          4 │
│ Data Analyst    │ power bi │      1069 │          5 │
│ Data Engineer   │ sql      │      9345 │          1 │
│ Data Engineer   │ python   │      8967 │          2 │
│ Data Engineer   │ azure    │      5327 │          3 │
│ Data Engineer   │ aws      │      5037 │          4 │
│ Data Engineer   │ spark    │      4454 │          5 │
│ Data Scientist  │ python   │      2900 │          1 │
│ Data Scientist  │ sql      │      2514 │          2 │
│ Data Scientist  │ r        │      1184 │          3 │
│ Data Scientist  │ aws      │       980 │          4 │
│ Data Scientist  │ azure    │       945 │          5 │
└─────────────────┴──────────┴───────────┴────────────┘
  15 rows                                   4 columns
*/