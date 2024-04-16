/*Q--
what are the top paying data analyst jobs?
-identify the top 10 paying jobs ,that are available for the remote work
-focous jobs with specific salary (remove null)
-why?highlight the top paying opportunities for data analyst,offering insite into employee prospective*/
SELECT job_id,company_dim.company_id,
name,
job_posted_date,
job_location,
job_title_short,
salary_year_avg

FROM job_postings_fact 
LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id 
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL AND job_location='Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10; 