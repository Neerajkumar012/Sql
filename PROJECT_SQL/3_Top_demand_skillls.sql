WITH In_Demand_skills AS(SELECT skill_id,count(*) as jobs
FROM skills_job_dim 
INNER JOIN job_postings_fact ON skills_job_dim.job_id= job_postings_fact.job_id
WHERE job_title_short='Data Analyst' and job_work_from_home=TRUE
GROUP BY skill_id 
ORDER BY jobs DESC
LIMIT 10
)

 SELECT skills_dim.skill_id,skills,jobs
 FROM In_Demand_skills
 INNER JOIN skills_dim ON In_Demand_skills.skill_id =skills_dim.skill_id
