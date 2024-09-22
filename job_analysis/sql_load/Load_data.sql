-- insert data into table 
copy company_dim
	from 'D:\Sql\job_analysis\Data\company_dim.csv' delimiter ',' csv header;
copy job_postings_fact
	from 'D:\Sql\job_analysis\Data\job_postings_fact.csv' delimiter ',' csv header;
copy skills_dim
	from 'D:\Sql\job_analysis\Data\skills_dim.csv' delimiter ',' csv header;
copy skills_job_dim
	from 'D:\Sql\job_analysis\Data\skills_job_dim.csv' delimiter ',' csv header;

-- checking if data is loaded 
select * from job_postings_fact 
left join skills_job_dim using (job_id)
left join company_dim using (company_id)
left join skills_dim using (skill_id)
limit 5