drop table if exists branch;
create table branch (
branch_id varchar(10 )primary key ,
manager_id varchar(10),
branch_add varchar(45),
contact_no varchar(10)
);

drop table if exists employee;
create table employee(
emp_id varchar(10) primary key,
emp_name varchar(25),
emp_position varchar(15),
salary int,
branch_id varchar(25),
foreign key (branch_id) references branch(branch_id)
);

drop table if exists books ;
create table books(
isbn varchar(20) primary key ,
book_title varchar(75),
category varchar(10),
rental_price float,
status varchar(5),
author varchar(35),
publisher varchar(55)
);
drop table if exists member;
create table members(
member_id varchar(20) primary key,
member_name varchar(25),
member_address varchar(75),
reg_date date
);
drop table if exists issue_status;
create table issued_status(
issued_id varchar(10) primary key,
issued_member varchar(10),
issued_book varchar(75),
issued_date date,
issued_book_isbn varchar(25),
issued_emp_id varchar(75) ,
foreign key (issued_emp_id) REFERENCES employee,
foreign key (issued_member) references members(member_id),
foreign key (issued_book_isbn) references books(isbn)
);

drop table if exists return_status;
create table return_status(
return_id varchar(10) primary key,
issued_id varchar(10),
returned_book_name varchar(75),
return_date date,
return_book_ispn varchar(20),
foreign key (return_book_ispn) references books(isbn),
foreign key (issued_id) references issued_status(issued_id)
);
-- branch ,employee ,isbn ,member
-- select * from employee