/*
Find the top 10 companies for postings jobs
They must have > 3000 postings
*/
SELECT
  cd.name AS company_name,
  COUNT(jpf.*) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
  ON jpf.company_id = cd.company_id
GROUP BY cd.name

/*
Find the top 10 companies for postings jobs
They must have > 3000 postings
Limit this to only the US jobs
*/
SELECT
  cd.name AS company_name,
  COUNT(jpf.*) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
  ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name

/*
Find the top 10 companies for postings jobs
They must have > 3000 postings
Limit this to only the US jobs
*/
SELECT
  cd.name AS company_name,
  COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
  ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name

/*
Find the top 10 companies for postings jobs
They must have > 3000 postings
Limit this to only the US jobs
*/
SELECT
  cd.name AS company_name,
  COUNT(jpf.*) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
  ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'Canada'
GROUP BY cd.name