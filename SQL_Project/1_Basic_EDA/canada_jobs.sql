-- Export Canadian job postings to CSV
COPY (
    SELECT
        jpf.*,
        sjd.skill_id,
        sd.skills
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_country = 'Canada'
      AND jpf.job_posted_date >= DATE '2023-01-01'
      AND jpf.job_posted_date < DATE '2025-06-03'
) TO 'data_jobs_canada_2024.csv' (FORMAT CSV, HEADER TRUE, DELIMITER ',');


COPY (
    SELECT
        jpf.*,
        sjd.skill_id,
        sd.skills
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_country = 'Canada'
      AND jpf.job_posted_date >= DATE '2023-01-01'
      AND jpf.job_posted_date < DATE '2025-06-03'
) TO 'data_inner_canada_2023-5.csv' (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY (
    SELECT
        jpf.*,
        sjd.skill_id,
        sd.skills
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_country = 'Canada'
      AND jpf.job_posted_date >= DATE '2023-01-01'
      AND jpf.job_posted_date < DATE '2025-06-03'
      AND jpf.job_title_short = 'Data Analyst'
) TO canada_left_join_job.csv' (FORMAT CSV, HEADER TRUE, DELIMITER ',');