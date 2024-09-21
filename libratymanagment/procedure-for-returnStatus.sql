 -- Update Book Status on Return
 -- a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
DROP procedure IF EXISTS addreturnstatus;

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

	select isbn,issued_book into v_isbn,v_book_title
	from issued_status
	where issued_id =c_issued_id;

	update books
	set status ='yes'
	where isbn =v_isbn;
	
	raise notice 'thank you for returning the book: %',v_book_title;
end;
$$

-- calling the function
call addreturnstatus('RS138','IS135','Good')


select * from books where isbn='978-0-307-58837-1'
select * from return_status where issued_id='IS135'
select * from return_status 