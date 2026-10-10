/*
Question 2: Monthly posting volume trend

Business question: Is demand for data roles increasing or decreasing over time in Canada?

Objective:
- Examine how the Canadian job posting changes from month to month.

SQL Concepts Shown:
- Aggregate monthly posting volume
- COUNT/SUM
- GROUP BY
- ORDER BY
- LIMIT
*/

SELECT
    DATE_TRUNC('month', job_posted_date) AS posting_month,
    COUNT(DISTINCT job_id) AS job_count
FROM job_postings_fact
WHERE job_country = 'Canada'
GROUP BY posting_month
ORDER BY posting_month;

/*
### Result
- The monthly job postings trend shows a **decline from 2023 into 2024,** reaching its lowest levels in **late 2024.**
- However, there is a **strong rebound in 2025,** with postings peaking at **3,367 in February 2025,** indicating a significant recovery in hiring demand.
- **Overall, 2025 records the highest job posting** activity in the dataset.

**Key takeaways**
Job postings were relatively stable in 2023, declined throughout 2024, and surged sharply in early 2025, signaling a strong recovery in the job market.

┌─────────────────────┬───────────┐
│    posting_month    │ job_count │
│      timestamp      │   int64   │
├─────────────────────┼───────────┤
│ 2023-01-01 00:00:00 │      2255 │
│ 2023-02-01 00:00:00 │      1245 │
│ 2023-03-01 00:00:00 │      1345 │
│ 2023-04-01 00:00:00 │      1466 │
│ 2023-05-01 00:00:00 │      1192 │
│ 2023-06-01 00:00:00 │      1249 │
│ 2023-07-01 00:00:00 │      1357 │
│ 2023-08-01 00:00:00 │      1267 │
│ 2023-09-01 00:00:00 │      1059 │
│ 2023-10-01 00:00:00 │      1237 │
│ 2023-11-01 00:00:00 │      1093 │
│ 2023-12-01 00:00:00 │      1277 │
│ 2024-01-01 00:00:00 │      1586 │
│ 2024-02-01 00:00:00 │      1804 │
│ 2024-03-01 00:00:00 │      1082 │
│ 2024-04-01 00:00:00 │       751 │
│ 2024-05-01 00:00:00 │       766 │
│ 2024-06-01 00:00:00 │       697 │
│ 2024-07-01 00:00:00 │       966 │
│ 2024-08-01 00:00:00 │      1120 │
│ 2024-09-01 00:00:00 │       778 │
│ 2024-10-01 00:00:00 │       622 │
│ 2024-11-01 00:00:00 │       510 │
│ 2024-12-01 00:00:00 │       642 │
│ 2025-01-01 00:00:00 │      2886 │
│ 2025-02-01 00:00:00 │      3367 │
│ 2025-03-01 00:00:00 │      3249 │
│ 2025-04-01 00:00:00 │      2374 │
│ 2025-05-01 00:00:00 │      2382 │
│ 2025-06-01 00:00:00 │      2172 │
└─────────────────────┴───────────┘
  30 rows               2 columns

*/

-- Advanced Analysis: Apply LAG() to measure month-over-month growth rates in job postings.

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', job_posted_date) AS posting_month,
        COUNT(*) AS num_postings
    FROM job_postings_fact
    WHERE job_country = 'Canada'
    GROUP BY DATE_TRUNC('month', job_posted_date)
)
SELECT
    posting_month,
    num_postings,
    LAG(num_postings) OVER (ORDER BY posting_month) AS prev_month_postings,
    ROUND(
        100.0 * (num_postings - LAG(num_postings) OVER (ORDER BY posting_month))
        / NULLIF(LAG(num_postings) OVER (ORDER BY posting_month), 0),
        1
    ) AS pct_change
FROM monthly
ORDER BY posting_month;

/*
### Result

The data shows substantial month-to-month volatility in job postings.
- **2023:** Postings fell sharply from 2,255 in January to 1,245 in February **(−44.8%).** The remainder of the year was relatively stable, generally ranging from about 1,000 to 1,500 postings per month.
- **2024:** Posting activity increased early in the year, reaching 1,804 in February, before declining significantly. March and April fell by **40.0% and 30.6%,** respectively. The year ended with only 642 postings in December.
- **2025:** January recorded a dramatic increase to 2,886 postings **(+349.5%),** followed by a peak of 3,367 in February. Postings then gradually declined to 2,172 by June but remained higher than most months in 2023 and 2024.

**Key takeaways**
The job market was weak in 2024 but rebounded strongly in early 2025.
However, the unusually large January 2025 increase should be investigated because it could reflect a genuine hiring recovery, seasonal hiring, or a change in data collection.

Thus, postings in the first half of 2025 increased by approximately 145.7% compared with the first half of 2024.

────────────────────┬──────────────┬─────────────────────┬────────────┐
│    posting_month    │ num_postings │ prev_month_postings │ pct_change │
│      timestamp      │    int64     │        int64        │   double   │
├─────────────────────┼──────────────┼─────────────────────┼────────────┤
│ 2023-01-01 00:00:00 │         2255 │                NULL │       NULL │
│ 2023-02-01 00:00:00 │         1245 │                2255 │      -44.8 │
│ 2023-03-01 00:00:00 │         1345 │                1245 │        8.0 │
│ 2023-04-01 00:00:00 │         1466 │                1345 │        9.0 │
│ 2023-05-01 00:00:00 │         1192 │                1466 │      -18.7 │
│ 2023-06-01 00:00:00 │         1249 │                1192 │        4.8 │
│ 2023-07-01 00:00:00 │         1357 │                1249 │        8.6 │
│ 2023-08-01 00:00:00 │         1267 │                1357 │       -6.6 │
│ 2023-09-01 00:00:00 │         1059 │                1267 │      -16.4 │
│ 2023-10-01 00:00:00 │         1237 │                1059 │       16.8 │
│ 2023-11-01 00:00:00 │         1093 │                1237 │      -11.6 │
│ 2023-12-01 00:00:00 │         1277 │                1093 │       16.8 │
│ 2024-01-01 00:00:00 │         1586 │                1277 │       24.2 │
│ 2024-02-01 00:00:00 │         1804 │                1586 │       13.7 │
│ 2024-03-01 00:00:00 │         1082 │                1804 │      -40.0 │
│ 2024-04-01 00:00:00 │          751 │                1082 │      -30.6 │
│ 2024-05-01 00:00:00 │          766 │                 751 │        2.0 │
│ 2024-06-01 00:00:00 │          697 │                 766 │       -9.0 │
│ 2024-07-01 00:00:00 │          966 │                 697 │       38.6 │
│ 2024-08-01 00:00:00 │         1120 │                 966 │       15.9 │
│ 2024-09-01 00:00:00 │          778 │                1120 │      -30.5 │
│ 2024-10-01 00:00:00 │          622 │                 778 │      -20.1 │
│ 2024-11-01 00:00:00 │          510 │                 622 │      -18.0 │
│ 2024-12-01 00:00:00 │          642 │                 510 │       25.9 │
│ 2025-01-01 00:00:00 │         2886 │                 642 │      349.5 │
│ 2025-02-01 00:00:00 │         3367 │                2886 │       16.7 │
│ 2025-03-01 00:00:00 │         3249 │                3367 │       -3.5 │
│ 2025-04-01 00:00:00 │         2374 │                3249 │      -26.9 │
│ 2025-05-01 00:00:00 │         2382 │                2374 │        0.3 │
│ 2025-06-01 00:00:00 │         2172 │                2382 │       -8.8 │
└─────────────────────┴──────────────┴─────────────────────┴────────────┘
  30 rows                                                     4 columns
*/