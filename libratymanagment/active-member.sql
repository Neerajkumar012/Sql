-- Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
with active_member as(select 
		member_id,
		issued_id,
		issued_emp_id,
		issued_date,
		current_date,
		current_date-issued_date  as gap
from issued_status 
where issued_date>=current_date- INTERVAL '2 month'
)
select * from members 
where member_id in(select member_id from active_member)


