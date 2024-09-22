 /*Top skills based on salary
 -Focous on role with specified salary,regardless of location
 -Look at average salary associated with each skill for Data Analyst
 -To see how different skill impact the salary
 */
 select 
 	skills_dim.skill,
	 round((avg(job_postings_fact.salary_year_avg)) ,0)as avg_salary
from 
	job_postings_fact
inner join 
	skills_job_dim using (job_id)
inner join 
	skills_dim using (skill_id)
where 
	job_title_short='Data Analyst'
	and 
	job_postings_fact.salary_year_avg notnull
group by 
	skills_dim.skill
order by 
	avg_salary desc
limit 10;