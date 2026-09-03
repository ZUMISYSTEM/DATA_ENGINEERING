/*
Question 2 — Salary
Which skills are associated with the highest salaries for Data Analysts, Data Engineers, and Data Scientists in Canada?
Objective:
Determine whether certain skills are associated with greater compensation.

Why this query

MEDIAN(salary_year_avg) calculates the typical salary associated with each skill.
salary_year_avg IS NOT NULL removes postings without salary information.
PARTITION BY job_title_short ranks skills separately for each role.
salary_rank <= 5 keeps only the top five skills per role.
job_count shows how many salary-reported postings support each result.

Using the median salary is preferable to the average because unusually high or low salaries have less influence on the result.
*/

WITH skill_salary AS (
    SELECT
        jpf.job_title_short,
        sd.skills,
        ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
        COUNT(*) AS job_count
    FROM job_postings_fact AS jpf
    JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_country = 'Canada'
      AND jpf.job_title_short IN (
          'Data Analyst',
          'Data Engineer',
          'Data Scientist'
      )
      AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        jpf.job_title_short,
        sd.skills
    HAVING COUNT(*) >= 10  -- Filter out rare skills here before ranking
),

ranked_skills AS (
    SELECT
        job_title_short,
        skills,
        median_salary,
        job_count,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY median_salary DESC
        ) AS salary_rank
    FROM skill_salary
)

SELECT
    job_title_short,
    skills,
    median_salary,
    job_count,
    salary_rank
FROM ranked_skills
WHERE salary_rank <= 5
ORDER BY
    job_title_short,
    salary_rank;

/*
### Results

The results show that the skills associated with the highest median salaries vary considerably across the three data roles in Canada.

* **Data Analysts:** Spark has the highest median salary at **$108,416**, followed by Databricks at **$105,507**. This suggests that analysts with big-data and cloud-platform skills may command higher salaries than those relying primarily on traditional analytical tools.

* **Data Engineers:** PostgreSQL leads with a median salary of **$136,250**, followed by Excel at **$133,000**. Redshift stands out because its $125,000 median salary is supported by **45 postings**, giving it a larger sample than the other top-ranked skills.

* **Data Scientists:** Git, TensorFlow, Jira, and PyTorch all have a median salary of **$246,000**. TensorFlow and PyTorch indicate that machine-learning skills are associated with particularly high-paying Data Scientist positions.

### Key insight

**Data Scientists show the highest skill-associated salaries**, particularly for machine-learning technologies. Data Engineers follow, while Data Analysts have comparatively lower median salaries.

However, the results should be interpreted cautiously. Several skills have only **10–15 salary-reported postings**, and the identical **$246,000** median for four Data Scientist skills likely indicates that the same high-paying job postings list multiple skills. Therefore, these figures show **association with salary, not that an individual skill causes the higher salary**.

┌─────────────────┬────────────┬───────────────┬───────────┬─────────────┐
│ job_title_short │   skills   │ median_salary │ job_count │ salary_rank │
│     varchar     │  varchar   │    double     │   int64   │    int64    │
├─────────────────┼────────────┼───────────────┼───────────┼─────────────┤
│ Data Analyst    │ spark      │      108416.0 │        11 │           1 │
│ Data Analyst    │ databricks │      105507.0 │        10 │           2 │
│ Data Analyst    │ looker     │       97300.0 │        12 │           3 │
│ Data Analyst    │ sas        │       85963.0 │        12 │           4 │
│ Data Analyst    │ excel      │       75000.0 │        29 │           5 │
│ Data Engineer   │ postgresql │      136250.0 │        12 │           1 │
│ Data Engineer   │ excel      │      133000.0 │        19 │           2 │
│ Data Engineer   │ looker     │      125500.0 │        15 │           3 │
│ Data Engineer   │ redshift   │      125000.0 │        45 │           4 │
│ Data Engineer   │ confluence │      125000.0 │        13 │           5 │
│ Data Scientist  │ git        │      246000.0 │        32 │           1 │
│ Data Scientist  │ tensorflow │      246000.0 │        44 │           2 │
│ Data Scientist  │ jira       │      246000.0 │        25 │           3 │
│ Data Scientist  │ pytorch    │      246000.0 │        37 │           4 │
│ Data Scientist  │ flow       │      180000.0 │        11 │           5 │
└─────────────────┴────────────┴───────────────┴───────────┴─────────────┘
  15 rows                                                      5 columns
*/