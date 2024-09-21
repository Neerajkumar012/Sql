 -- Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
 

select 
	member_name,
	count(*) as issue,
	sum((current_date - issued_date) * 0.5 ) as fine
	from members 
	
left join issued_status using(member_id)
left join return_status using (issued_id)
where current_date -issued_date>30 and issued_id not in (select issued_id from return_status)
group by member_name
