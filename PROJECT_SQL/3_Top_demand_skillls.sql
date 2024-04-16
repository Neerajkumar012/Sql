SELECT skills,
    count(skills_job_dim.job_id) as demand
FROM job_postings_fact 
INNER JOIN skills_job_dim ON skills_job_dim.job_id= job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE 
    job_title_short='Data Analyst' and job_work_from_home=TRUE
GROUP BY skills 
ORDER BY demand DESC
LIMIT 10
