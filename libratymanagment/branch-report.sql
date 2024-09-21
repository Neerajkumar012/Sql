
-- Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

select branch.branch_id ,branch.manager_id,
	count(issued_status.issued_id)as issued,
	count(return_status.return_id)as returned,
	sum(books.rental_price)as revenue
from branch
left join employees using (branch_id)
left join issued_status on issued_status.issued_emp_id=employees.emp_id
left join return_status  using(issued_id) 
left join books using(isbn)
group by branch.branch_id
order by revenue desc