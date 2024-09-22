/* What skills are require for the top paying data analyst jobs?
-add specific skills require for the jobs filtered in previous query using CTE
-it provide a detailed look on what skills are required for top jobs postings for data analyst
 */


with top_paying_jobs as 
(
select 
	job_id,
	job_title,
	salary_year_avg
from 
	job_postings_fact
left join 
	company_dim  using (company_id)
where 
	job_title_short ='Data Analyst'
	and
	job_location ='Anywhere'
	and 
	salary_year_avg notnull
order by 
	salary_year_avg desc
limit
	10
)

select 
	top_paying_jobs.*,
	skills_dim.skill
from 
	skills_job_dim
inner join 
	top_paying_jobs using (job_id)
inner join 
	skills_dim using (skill_id)
order by 
	salary_year_avg desc
limit 10;