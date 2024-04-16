
/*highest paying skills and in demand skill */

WITH average_Salary as (
    SELECT 
        skills_dim.skill_id,skills_dim.skills,
        ROUND(avg(salary_year_avg),0) as Avg_salary
    FROM job_postings_fact 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE salary_year_avg IS NOT NULL AND job_title_short ='Data Analyst' and job_work_from_home=TRUE
    GROUP BY skills_dim.skill_id
),skills_demand as(
    SELECT 
        skills_dim.skill_id,
        count(skills_job_dim.job_id) as demand
    FROM job_postings_fact 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id= job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
    WHERE 
        job_title_short='Data Analyst' and job_work_from_home=TRUE
    GROUP BY skills_dim.skill_id 
)

SELECT
   average_Salary.skill_id,skills,Avg_salary,demand
    FROM skills_demand 
    INNER JOIN average_Salary ON skills_demand.skill_id =average_Salary.skill_id
    WHERE demand > 50
    ORDER BY Avg_salary DESC
    LIMIT 100

    /*or short query  for the same */

SELECT
   skills_dim.skills,
    skills_dim.skill_id ,
   ROUND(AVG(salary_year_avg),0)as Avg_salary,
   count(job_postings_fact.job_id) as demand
    FROM job_postings_fact 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id    
    WHERE salary_year_avg IS NOT NULL and job_title_short='Data Analyst'
    GROUP BY skills_dim.skill_id
    ORDER BY Avg_salary DESC
    LIMIT 100
