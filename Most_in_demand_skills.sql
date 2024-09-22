/*Most in demand skill for data analyst ?
-identify top 5 skills in-demand for data analyst
-to see most valuable skill to learn
*/

select 
	skills_dim.skill,
	count(*) as jobs
from 
	skills_job_dim
inner join 
	skills_dim using (skill_id)
inner join 
	job_postings_fact using (job_id)
where 
	job_title_short='Data Analyst'
group by 
	skills_dim.skill_id
order by 
	jobs desc
limit 5;
