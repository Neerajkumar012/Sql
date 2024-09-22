# Library Management System using SQL Project 

## Project Overview

**Project Title**: Library Management System 
**Database**: `library_db`

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Project Structure

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```
## Advanced SQL Operations

**Task : Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
-- Identify Members with Overdue Books

select
  member_id ,
  member_name,
  issued_book,
  issued_date,
  current_date -issued_date as overdue
from members 
left join issued_status using(member_id)
left join return_status using (issued_id)
where current_date -issued_date>30 and issued_id not in (select issued_id from return_status);

```


**Task : Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

 -- Update Book Status on Return

create or replace procedure addreturnstatus(c_return_id varchar(10),c_issued_id varchar(10),c_book_quality varchar(15))
language plpgsql
as $$
declare v_isbn varchar (50);
v_book_title varchar (80);

begin
-- insert into return_status when enter into return table
	insert into return_status(return_id,issued_id,return_date,book_quality)
	values(c_return_id,c_issued_id, current_date,c_book_quality);
-- query to insert into book table base on return row inserted

	select isbn,issued_book
        into v_isbn,v_book_title
	from issued_status
	where issued_id =c_issued_id;

	update books
	set status ='yes'
	where isbn =v_isbn;

	raise notice 'thank you for returning the book: %',v_book_title;

end;
$$

-- calling the function
call addreturnstatus('RS138','IS135','Good');


select * from books where isbn='978-0-307-58837-1';
select * from return_status where issued_id='IS135';
select * from return_status;

```




**Task : Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

-- Branch Performance Report

select
  branch.branch_id,
  branch.manager_id,
	count(issued_status.issued_id)as issued,
	count(return_status.return_id)as returned,
	sum(books.rental_price)as revenue
from branch

left join employees using (branch_id)
left join issued_status on
   issued_status.issued_emp_id=employees.emp_id
left join return_status  using(issued_id) 
left join books using(isbn)

group by branch.branch_id
order by revenue desc;

```

**Task : CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql
-- Create a Table of Active Members

with active_member as(
  select 
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
where member_id in(select member_id from active_member);

```


**Task : Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
-- Find Employees with the Most Book Issues Processed

select
  employees.emp_id,
  emp_name,
  branch_id,
  count(*) as issues
from issued_status
left join employees on 
	employees.emp_id = issued_status.issued_emp_id
group by employees.emp_id
order by issues desc;

```

**Task : Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql
-- Create a stored procedure to manage the status of books in a library system. 

create or replace procedure issuance(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), v_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
language plpgsql
as $$
declare
v_avail varchar(5);
begin
	-- //lookup if avialabel
	select status into v_avail
	from books 
	where isbn=v_isbn;

	if v_avail='yes' then
		-- update the issued table and give the book 
		insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		values(p_issued_id, p_issued_member_id, CURRENT_DATE, v_isbn, p_issued_emp_id);
		
		-- update the book as 'no' unavailable
		update books 
		set status ='no'
		where isbn=v_isbn;
		raise notice 'your book is available in library and can be issued,book by isbn %' ,v_isbn;
	else 	
		raise notice 'your requested book is not available currently please try later';
	end if;
end;
$$ 	


CALL issuance('IS155', 'C108', '978-0-553-29698-2', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-553-29698-2'
-- select * from issued_status
		
```



**Task : Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

```sql
create table member_fine as
select 
	member_name,
	count(*) as issue,
	sum((current_date - issued_date) * 0.5 ) as fine
	from members 
	
left join issued_status using(member_id)
left join return_status using (issued_id)
where
   current_date -issued_date>30
    and
    issued_id not in (select issued_id from return_status)
group by member_name
order by fine desc;

    ```



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

Thank you for your interest in this project!
