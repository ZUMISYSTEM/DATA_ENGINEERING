/*
Question 1: Top hiring companies and their median salary

Business question: Which companies post the most data related roles jobs in Canada and what do they pay on average?

Objective:
- Identify the companies with the most Data job postings in Canada and compare their advertised salaries.

SQL Concepts Shown:
- Join to dimension tables
- Aggregate salary and company name
- COUNT/MEDIAN
- HAVING
- GROUP BY
- ORDER BY
- LIMIT
*/

SELECT
    cd.name AS company_name,
    COUNT(DISTINCT jpf.job_id) AS job_count,
    COUNT(jpf.salary_year_avg) AS salary_reported_count,
    ROUND(MEDIAN(jpf.salary_year_avg), 2) AS median_salary
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
-- WHERE jpf.job_title_short = 'Data Scientist'
--    AND jpf.job_country = 'Canada'
WHERE jpf.job_country = 'Canada' AND jpf.salary_year_avg IS NOT NULL
GROUP BY cd.name
HAVING COUNT(DISTINCT jpf.job_id) > 10
ORDER BY job_count DESC
LIMIT 10;

/*
### Result
The table below shows the company name, the number of job postings, the count of postings that reported a salary, and the median salary for those postings.

- **Veeva** has the most postings (63) with a median of $190,000.
- **Genentech** pays the highest median ($246,000) on 24 postings.
- **Workday** ($185,000), **Stripe** ($152,000), **Snowflake** ($150,000) and **Citigroup** ($125,000) sit in the mid-to-upper range, each with 11 postings.
- **Scotiabank** (18 postings) and **RBC** (12) have medians around $114K and $90K.
- **Kano** has the lowest median ($71,500) on 17 postings.

**Key takeaways**
- **Wide** pay range: medians run from $71.5K (Kano) to $246K (Genentech).
- **Volume ≠ pay:** Veeva posts the most (63, $190K median); Genentech pays the most on just 24.
- **Tech and biotech lead:** Genentech, Veeva, Workday, Stripe and Snowflake are all at $150K or more.
- **Banks sit lower:** Scotiabank, RBC and Citigroup range from $90K to $125K.
- **Caveat:** most companies have only 11-24 postings, so medians are sensitive to role mix.

**Caution:**
Results should be interpreted cautiously, as they derive from a small sample of Canadian job postings (January 2023 – June 2025) and may not generalize beyond this context.

┌────────────────┬───────────┬───────────────────────┬───────────────┐
│  company_name  │ job_count │ salary_reported_count │ median_salary │
│    varchar     │   int64   │         int64         │    double     │
├────────────────┼───────────┼───────────────────────┼───────────────┤
│ Veeva          │        63 │                    63 │      190000.0 │
│ Genentech      │        24 │                    24 │      246000.0 │
│ Scotiabank     │        18 │                    18 │      114252.5 │
│ Kano           │        17 │                    17 │       71500.0 │
│ RBC            │        12 │                    12 │       90000.0 │
│ Citigroup, Inc │        11 │                    11 │      125000.0 │
│ Stripe         │        11 │                    11 │      152000.0 │
│ Workday        │        11 │                    11 │      185000.0 │
│ Snowflake      │        11 │                    11 │      150000.0 │
└────────────────┴───────────┴───────────────────────┴───────────────┘

**Conclusion:**
Medians range from $71K (Kano) to $246K (Genentech), with tech and biotech paying the most. Most companies have fewer than 25 postings, so medians are based on small samples.
*/
