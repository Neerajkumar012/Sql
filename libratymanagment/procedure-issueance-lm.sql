-- Stored Procedure Objective: 
-- Create a stored procedure to manage the status of books in a library system. 
-- Description: Write a stored procedure that updates the status of a book in the library based on its
-- issuance. The procedure should function as follows: The stored procedure should take the book_id as
-- an input parameter. The procedure should first check if the book is available (status = 'yes').
-- If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
-- If the book is not available (status = 'no'), the procedure should return an error message
-- indicating that the book is currently not available.

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
		