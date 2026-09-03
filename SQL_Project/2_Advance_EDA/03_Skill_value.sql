/*
Question 3 — Skill Value
Which skills are associated with the highest salaries for these three data roles in Canada?
Objective:
- Identify skills that are both market-relevant and financially valuable.

Why this query?

The purpose of this query is to find skills that are strong in both demand and salary.

A skill may be highly demanded but not highly paid. Another skill may pay very well but appear in only a small number of jobs. This query tries to balance both factors.
*/


WITH skill_stats AS (
    SELECT
        jpf.job_title_short,
        sd.skills,
        COUNT(*) AS demand_count,
        ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary
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
    HAVING COUNT(*) >= 10
),

ranked_skills AS (
    SELECT
        job_title_short,
        skills,
        demand_count,
        median_salary,

        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY demand_count DESC
        ) AS demand_rank,

        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY median_salary DESC
        ) AS salary_rank

    FROM skill_stats
),

combined_skills AS (
    SELECT
        job_title_short,
        skills,
        demand_count,
        median_salary,
        demand_rank,
        salary_rank,
        demand_rank + salary_rank AS combined_rank
    FROM ranked_skills
),

top_skills AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY combined_rank, demand_count DESC
        ) AS overall_rank
    FROM combined_skills
)

SELECT
    job_title_short,
    skills,
    demand_count,
    median_salary,
    demand_rank,
    salary_rank,
    combined_rank,
    overall_rank
FROM top_skills
WHERE overall_rank <= 5
ORDER BY
    job_title_short,
    overall_rank;

/*
### Results
### Interpretation

The results identify the **top five skills that provide the strongest balance between demand and median salary** for each data role in Canada.

* **Data Analyst:** **SQL ranks first**, driven by the highest demand (72 postings) and a solid median salary of **$73,671**. Python and Tableau follow. Overall, core analytics and visualization skills provide the strongest balance.

* **Data Engineer:** **Snowflake ranks first**, with 67 postings and a **$125,000 median salary**. Java, AWS, Airflow, and Redshift complete the top five, highlighting the value of **cloud, data warehousing, and data pipeline technologies**.

* **Data Scientist:** **TensorFlow ranks first**, combining relatively high demand with the highest median salary of **$246,000**. PyTorch follows closely, showing the strong value associated with **machine-learning frameworks**.

### Key insight

The optimal skill set differs substantially by career path:

**Data Analyst → SQL and analytics tools**
**Data Engineer → Cloud and data infrastructure tools**
**Data Scientist → Machine-learning frameworks**

Importantly, the `overall_rank` represents a **balance between demand and salary**, not salary alone. A lower `combined_rank` means a skill performs well across both measures.


┌─────────────────┬────────────┬──────────────┬───────────────┬─────────────┬─────────────┬───────────────┬──────────────┐
│ job_title_short │   skills   │ demand_count │ median_salary │ demand_rank │ salary_rank │ combined_rank │ overall_rank │
│     varchar     │  varchar   │    int64     │    double     │    int64    │    int64    │     int64     │    int64     │
├─────────────────┼────────────┼──────────────┼───────────────┼─────────────┼─────────────┼───────────────┼──────────────┤
│ Data Analyst    │ sql        │           72 │       73671.0 │           1 │           6 │             7 │            1 │
│ Data Analyst    │ python     │           54 │       71500.0 │           2 │           8 │            10 │            2 │
│ Data Analyst    │ tableau    │           46 │       73671.0 │           3 │           7 │            10 │            3 │
│ Data Analyst    │ excel      │           29 │       75000.0 │           6 │           5 │            11 │            4 │
│ Data Analyst    │ power bi   │           39 │       71500.0 │           4 │           9 │            13 │            5 │
│ Data Engineer   │ snowflake  │           67 │      125000.0 │           6 │           6 │            12 │            1 │
│ Data Engineer   │ java       │           62 │      125000.0 │           7 │           7 │            14 │            2 │
│ Data Engineer   │ aws        │          122 │      125000.0 │           3 │          13 │            16 │            3 │
│ Data Engineer   │ airflow    │           55 │      125000.0 │           9 │           8 │            17 │            4 │
│ Data Engineer   │ redshift   │           45 │      125000.0 │          11 │           9 │            20 │            5 │
│ Data Scientist  │ tensorflow │           44 │      246000.0 │           3 │           1 │             4 │            1 │
│ Data Scientist  │ pytorch    │           37 │      246000.0 │           4 │           2 │             6 │            2 │
│ Data Scientist  │ git        │           32 │      246000.0 │           6 │           3 │             9 │            3 │
│ Data Scientist  │ r          │           34 │      156804.0 │           5 │           8 │            13 │            4 │
│ Data Scientist  │ jira       │           25 │      246000.0 │           9 │           4 │            13 │            5 │
└─────────────────┴────────────┴──────────────┴───────────────┴─────────────┴─────────────┴───────────────┴──────────────┘
  15 rows                                                                                                      8 columns
*/