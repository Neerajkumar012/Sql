/*top paying jobs for my role
-top 10 paying jobs for Data Analyst
-that are available for remote work
-show company name which offer such roles
-and only show rows with specify salary ,remove any nulls
*/
select 
	job_id,
	job_title,
	job_title_short,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
	company_dim.name as company_name
from 
	job_postings_fact 
left join
	company_dim using (company_id)
where 
	job_title_short='Data Analyst' 
	and 
	salary_year_avg  notnull 
	and
	job_location = 'Anywhere'
order by 
	salary_year_avg desc
limit 10;