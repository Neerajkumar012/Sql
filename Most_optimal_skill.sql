/*Most optimal skill to learn(^is it high demand and high paying?)
-Concern on remote jobs with specified salary
-Skill with high demand and associated with high paying job
-To target skill that offer job security(high demand) and financial benefits(high paying)
*/


select 
	skills_dim.skill_id,
	skills_dim.skill,
	count(*) as skill_demand,
	round(avg(job_postings_fact.salary_year_avg),0) as avg_salary
from 
	job_postings_fact
inner join 
	skills_job_dim using (job_id)
inner join 
	skills_dim using (skill_id)
where 
	job_title_short='Data Analyst'
	and
	salary_year_avg notnull
	and 
	job_location ='Anywhere'
group by 
	skills_dim.skill_id
having 
	count(*)>10
order by
	avg_salary desc,
	skill_demand desc
limit 25;
