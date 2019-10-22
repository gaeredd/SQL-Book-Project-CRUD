/* use MIST353ClassRedd; "to ensure your using the correct database" */

-- constraints CRUD create, retreive ,Update ,Delete--

--check for object statements--
/* check constraint ChKprice (BookPrice) between (0.00 and 999.99)*/


/*if (OBJECT_ID('LibraryBook') is not null)--syntax must be before drop book & library table--
	drop table LibraryBook;*/
	

	use MIST353ClassRedd;

if (OBJECT_ID('BookCopy') is not null)
drop table BookCopy;--

if (OBJECT_ID('Book') is not null)--
	drop table book;

if (OBJECT_ID('Library') is not null)
drop table Library;--
	

create table Book

(
 ISBN char(13),
 BookTitle varchar(200), not null
 BookPrice decimal(6,2), not null
 BookFormat varchar(30),
constraint pkBook primary key(ISBN), --this sents the pk to ISBN and give the constraint a name--
constraint chPrice
 check(BookPrice >=0.00
  and BookPrice <=999.99),
constraint chkBookFormat
	check(BookFormat in ('Hardcover','Paperback','E-Book'))
 

 --alter table Book --
	--drop constraint pkBook( this will drop the pk set above but its more difficult if sql sever sets it own pk--

);

create table Library
(
LibraryID int identity(1,1),--1,1 means it starts at one and increments by 1-- --No primarykey next to LibraryID is because I want to control the contstraint instead of sql sever generating a pk

LibraryAddress varchar(100),
LibraryName varchar(100),
constraint pkLibrary primary key(LibraryID)

);


Create table BookCopy
(
BookNumber int identity (1,1),
LibraryID int, 
ISBN char(13), 
BookCondition varchar(30),
constraint pkBookCopy
	primary key (BookNumber),
constraint fkBookCopyToBook
	foreign key(ISBN) references Book(ISBN),
constraint fkBookCopyToLibrary
	foreign key(LibraryID) references Library(LibraryID),
constraint chkBookCopycheck check
	(BookCondition in ( 'Good', 'Damaged', 'Lost'))
	

);

--3 rows of Library data--
	insert into Library (LibraryName, LibraryAddress, LibraryID)
	values
	('downtown','100 newton ave',1),
	('evansdale','200 price st',2),
	('health science','100 van horeis rd',3),
	('engineering','355 university ave st',4);


--5 rows of book--
	insert into Book (ISBN, BookPrice, BookTitle)
	values
	('1234567894561','14.99','Outsider'),
	('1326457485478','18.99','Harry Potter'),
    ('1234567890523','27.99','Harry Potter'),
	('1626457485478','18.99','Harry Potter'),
	('1902334857685','17.99','Data Science');


--10 rows of Book copy--

insert into BookCopy(ISBN, BookCondition) values
(1234567890523,'Good'),
(1234567894561,'Damaged'),
(1234567890523,'Lost'),
(1326457485478,'Good'),
(1234567890523,'Good'),
(1626457485478,'Lost'),
(1902334857685,'Damaged'),
(1234567890523,'Good'),
(1234567890523,'Good'),
(1626457485478,'Lost');

--question 3--

--(select Count(*) as 'copies'--
--from BookCopy--
--where LibraryID = '1')  (select ISBN from Book as B--
--where B.BookTitle = 'Harry Potter');--

--question 3b--
--(select *,count(1) as Quantity from BookCopy where ISBN = char(13)),--
--and (select ISBN from Book as B where B.BookTitle = 'Harry Potter');--




/*insert into LibraryBook ( ISBN, LibraryID)
values
('1234567890523', 1),
('1326457485478', 2);*/ -- there is a error with this because it violates the frkey constraint that say you must reference a book in LibraryBook



-- constraint chkPrice
--check BookPrice between 0.00 and 999.99--
	--check BookPrice>=0.00 and BookPrice <=999.99

--show all tables in libraryBook--




/*SELECT Count(LibraryBook)
FROM ISBN
WHERE condition*/


/*SELECT COUNT BookTitle  FROM Book 
WHERE BookTitle = ('Harry Potter');*/



/*SELECT BookTitle from Book
UNION ALL
SELECT  LibraryID from LibraryBook*/ 



--Sub Query approach to finding all WVU copies of Harry Potter--
select count (*) as 'Number of Copies'
from BookCopy
where ISBN IN

(select ISBN 
from Book as B 
where B.BookTitle = 'Harry Potter');



-- Method to display all copies of Harry Potter in the wvu library--

select count(*) as 'Number of copies'
from BookCopy as BC
	inner join Book as B
	on BC.ISBN = B.ISBN
where B.BookTitle = 'Harry Potter'; 

--------------------------------------------------------------------------------
	 --How many copies there are of each book--
/*SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;
*/



--Questions drived from this query-- 
/*select B.ISBN, B.BookTitle, L.LibraryName --count(BC.ISBN) as 'Number of Copies'
from BookCopy as BC
	right join Book as B
		on BC.ISBN = B.ISBN
	right join Library as L
		on BC.LibraryID = L.LibraryID
group by B.ISBN;
*/


--Attempt at --Resolving to 'Number of Copies'--
select B.ISBN, B.BookTitle, B.BookFormat, L.LibraryName
--count(BC.ISBN) as 'Number of Copies'
from BookCopy as BC
	left join Book as B
		on BC.ISBN = B.ISBN
	left join Library as L
	 on Bc.LibraryID = L.LibraryID
	 
	 
	 	 
--Resolution to 'Number of Copies' general format--
*SELECT  B.ISBN, B.BookTitle, L.LibraryName, BC.ISBN, count (BC.ISBN) as 'Number of copies'
FROM BookCopy as BC
	Left Join Book as B
		ON B.ISBN = BC.ISBN
	Left JOIN Library as L 
	 on L.LibraryID = BC.LibraryID
Group BY B.ISBN;


--Resolution to 'Number of Copies'--
select B.ISBN, B.BookTitle, B.BookFormat --LibraryName count(BC.ISBN) as 'Number of Copies'
from BookCopy as BC
 inner join Book as B 
  on BC.ISBN = B.ISBN
  inner join Library as L 
  on BC.LibraryID = L.LibraryID;

  --Remember to get every row from book and its number of copies--
  select B.ISBN, Book.BookTitle, B.BookFormat
	from BookCopy as BC
		inner join Book as B
		 on BC.ISBN = B.ISBN
		inner join Library as L;
		

   select B.ISBN, B.BookTitle, B.BookFormat
	from Book as B
		Left join BookCopy as BC
		 on B.ISBN = BC.ISBN
		Left join Library as L 
			on BC.LibraryID = L.LibraryID;

-- Gives all the libraries who orders dont match a Book --

select B.ISBN, B.BookTitle, B.BookFormat, L.LibraryName
--count(BC.ISBN) as 'Number of Copies'
from Book as B
	left join BookCopy as BC
		on B.ISBN = BC.ISBN
	left join Library as L
		on BC.LibraryID = L.LibraryAddress;

		--Agregation with columns
select B.ISBN, B.BookTitle, B.BookFormat, --L.LibraryName,
	count (BC.ISBN) as 'Number of copies'
from Book as B 
	Left join BookCopy as BC
	on B.ISBN = BC.ISBN
	--left join Library as L
	--on BC.LibraryID = L.LibraryID
group by B.ISBN, B.BookTitle, BookFormat, --L.LibraryName

----------------------------------------------------------------------------------------------------------------------
-- sub querys is a better option--


/*
declare @test bigint; -- when decalring a varaible you must @test otherwise sql will look for a table or column--
set @test = 12321456441646; int & bigint are only used for mathamatical equations
*/


Create table LibraryBook
(
LibraryID int, 
ISBN char(13), 
constraint pkLibraryBook
	primary key (LibraryID, ISBN),
constraint fkLibraryBookToBook
	foreign key(ISBN) references Book(ISBN),
constraint fkLibraryBookToLibrary
	foreign key(LibraryID) references Library(LibraryID)


	insert into Library (LibraryName, LibraryAddress)
	values
	('downtown','100 newton ave'),
	('evansdale','200 price st');

	insert into Book (ISBN, BookPrice, BookTitle)
	values
	('1234567894561','14.99','Outsider')
	('1326457485478','18.99','Zeus');

);
 

