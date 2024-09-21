-- Identify Members with Overdue Books
--  query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.


select member_id ,member_name,issued_book,issued_date,  current_date -issued_date as overdue from members 
left join issued_status using(member_id)
left join return_status using (issued_id)
where current_date -issued_date>30 and issued_id not in (select issued_id from return_status)


