/*
Question 4: Which skills are in demand and high paying?

Business question: What skills to prioritize in learning and hiring for Data Scientist roles in Canada?

Objective:
Identify Data Scientist skills that appear frequently in Canadian job postings and are associated with high median salaries.

SQL Concepts Shown:
- Join 3 tables
- Aggregate skill and job posting count
- COUNT/SUM
- GROUP BY
- ORDER BY
- LIMIT
*/

SELECT
    sd.skills AS skill,
    COUNT(DISTINCT jpf.job_id) AS demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg), 2) AS median_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Scientist'
    AND jpf.job_country = 'Canada'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(DISTINCT jpf.job_id) >= 10
ORDER BY demand_count DESC, median_salary DESC
LIMIT 10;

/*
### Result

This analysis identifies the Data Scientist skills that provide the strongest combination of employer demand and median advertised salary in Canada.

- **Python is the most in-demand skill,** appearing in 87 salary-reported postings, with a median salary of **127,317.**
- **SQL offers the strongest balance of demand and compensation,** with 70 postings and a higher median salary of **142,850.**
- **TensorFlow and PyTorch are highly paid specialized skills,** each associated with a median salary of **246,000.**
- **R and Tableau** have moderate demand and the same median salary of **156,803.50.**
- **AWS** appears in 31 postings, with a median salary of **126,500.**
- **Git and Jira** are also associated with the highest median salary of **246,000,** but this result is likely influenced by repeated high-paying Genentech postings.
- **Spark** rounds out the top ten with 23 postings and a median salary of **125,000.**

**Key takeaways**
SQL provides the strongest general combination of demand and salary, while TensorFlow and PyTorch show greater salary potential for specialized machine-learning roles. However, repeated postings should be addressed before drawing final conclusions about the skills associated with the 246,000 median salary.

┌────────────┬──────────────┬───────────────┐
│   skill    │ demand_count │ median_salary │
│  varchar   │    int64     │    double     │
├────────────┼──────────────┼───────────────┤
│ python     │           87 │      127317.0 │
│ sql        │           70 │      142850.0 │
│ tensorflow │           44 │      246000.0 │
│ pytorch    │           37 │      246000.0 │
│ r          │           34 │      156803.5 │
│ git        │           32 │      246000.0 │
│ aws        │           31 │      126500.0 │
│ tableau    │           30 │      156803.5 │
│ jira       │           25 │      246000.0 │
│ spark      │           23 │      125000.0 │
└────────────┴──────────────┴───────────────┘
  10 rows                         3 columns
*/

-- Investigate the high median salary for duplicate of the job posting?
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_posted_date,
    jpf.salary_year_avg
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_title_short = 'Data Scientist'
    AND jpf.job_country = 'Canada' AND jpf.salary_year_avg = 246000
    AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC;

/*

**Repeated Posting Consideration**
Although the 24 records have different job IDs and posting dates, they share the same company, job title, location, salary and posting time. This strongly suggests that Genentech repeatedly advertised the same Principal Data Scientist position between July and September 2024.
These records were therefore classified as probable repeated postings rather than independent vacancies. Including all of them may inflate company hiring activity, skill-demand counts and median salary estimates associated with the 246,000 salary.

┌─────────┬─────────────────┬──────────────┬───────────────────────────────────┬─────────────────────┬─────────────────┐
│ job_id  │ job_title_short │ company_name │           job_location            │   job_posted_date   │ salary_year_avg │
│  int32  │     varchar     │   varchar    │              varchar              │      timestamp      │     double      │
├─────────┼─────────────────┼──────────────┼───────────────────────────────────┼─────────────────────┼─────────────────┤
│ 1203549 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-09-23 11:06:14 │        246000.0 │
│ 1172193 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-27 11:06:14 │        246000.0 │
│ 1165654 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-22 11:06:14 │        246000.0 │
│ 1163945 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-21 11:06:14 │        246000.0 │
│ 1162153 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-20 11:06:14 │        246000.0 │
│ 1156979 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-16 11:06:14 │        246000.0 │
│ 1155137 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-15 11:06:14 │        246000.0 │
│ 1153277 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-14 11:06:14 │        246000.0 │
│ 1151389 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-13 11:06:14 │        246000.0 │
│ 1149593 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-12 11:06:14 │        246000.0 │
│ 1145868 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-09 11:06:14 │        246000.0 │
│ 1143893 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-08 11:06:14 │        246000.0 │
│ 1141917 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-07 11:06:14 │        246000.0 │
│ 1139895 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-06 11:06:14 │        246000.0 │
│ 1138010 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-05 11:06:14 │        246000.0 │
│ 1134016 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-02 11:06:14 │        246000.0 │
│ 1131900 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-08-01 11:06:14 │        246000.0 │
│ 1129703 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-31 11:06:14 │        246000.0 │
│ 1127416 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-30 11:06:14 │        246000.0 │
│ 1125357 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-29 11:06:14 │        246000.0 │
│ 1121193 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-26 11:06:14 │        246000.0 │
│ 1118886 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-25 11:06:14 │        246000.0 │
│ 1116495 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-24 11:06:14 │        246000.0 │
│ 1114103 │ Data Scientist  │ Genentech    │ Newfoundland and Labrador, Canada │ 2024-07-23 11:06:14 │        246000.0 │
└─────────┴─────────────────┴──────────────┴───────────────────────────────────┴─────────────────────┴─────────────────┘
  24 rows                                                                                                    6 columns
*/




