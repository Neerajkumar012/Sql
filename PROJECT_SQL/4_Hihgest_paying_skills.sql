
/*highest paying skills */

SELECT skills, 
    round(avg(salary_year_avg),0) as average_Salary
 FROM job_postings_fact 
 INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg IS NOT NULL AND job_title_short ='Data Analyst'
GROUP BY skills
ORDER BY average_Salary DESC
LIMIT 20
