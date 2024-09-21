-- Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

select employees.emp_id,emp_name,branch_id,count(*) as issues
from issued_status
left join employees on 
	employees.emp_id = issued_status.issued_emp_id
group by employees.emp_id
order by issues desc








