/*
Question 3: What are the top three most-requested skills for Data Scientist roles in Canada?

Business question: What are the top three most-requested skills  Employer asks for in Data Scientist roles in Canada?

Objective:
- Identify the top three most-requested skills for Data Scientist roles in Canada.

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
    COUNT(DISTINCT jpf.job_id) AS job_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Scientist'
    AND jpf.job_country = 'Canada'
GROUP BY sd.skills
ORDER BY job_count DESC
LIMIT 10;

/*
### Result
The results show the top 10 most-requested skills for Data Scientist roles in Canada: python, sql, and r.

- **Python is the most requested skill,** appearing in 2,900 job postings.
- **SQL ranks second** with 2,514 postings, confirming that database querying remains essential.
- **R ranks third** with 1,184 postings, but its demand is less than half that of Python.
- **AWS and Azure show strong cloud demand,** with 980 and 945 postings, respectively.
- **Spark and Databricks** indicate demand for big-data processing and scalable analytics.
- **Tableau, Power BI and Excel** remain relevant for visualization, reporting and communicating results.


**Key takeaways**
Python and SQL form the strongest core skill combination. Candidates can strengthen their profile by adding a cloud platform, big-data technology and visualization tool.

┌────────────┬───────────┐
│   skill    │ job_count │
│  varchar   │   int64   │
├────────────┼───────────┤
│ python     │      2900 │
│ sql        │      2514 │
│ r          │      1184 │
│ aws        │       980 │
│ azure      │       945 │
│ spark      │       828 │
│ tableau    │       661 │
│ power bi   │       560 │
│ excel      │       510 │
│ databricks │       486 │
└────────────┴───────────┘
  10 rows      2 columns

*/