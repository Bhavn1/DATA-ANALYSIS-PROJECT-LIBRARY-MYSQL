drop database if exists Library;
 create database Library;
 use Library;

CREATE TABLE PUBLISHER(
publisher_Name varchar(100) primary key,
publisher_Address varchar(100),
publisher_Phone varchar(100));

select*from PUBLISHER;
select count(*) from PUBLISHER;

CREATE TABLE Borrower(
Borrower_cardNo int primary key,
Borrower_Name varchar(100),
Borrower_address varchar(100),
Borrower_Phone varchar (100)); 

select*from Borrower;

CREATE TABLE Books(
Book_Id INT primary key auto_increment,
Title VARCHAR(100),
Book_publishername varchar(100),
foreign key (Book_publisherName) references PUBLISHER (publisher_Name));

select*from Books;

CREATE TABLE BOOK_AUTHORS(
book_authors_bookID INT,
FOREIGN KEY (book_authors_bookID)references Books (Book_Id), 
book_authors_authorname varchar (100));

select*from Book_AUTHORS;

create table Library_Branch(
library_branch_BranchId int primary key auto_increment,
library_branch_BranchName varchar (80),
library_branch_BranchAddress varchar (80));

select*from library_branch;

create table COPIES(
book_copies_bookid int,
foreign key (book_copies_bookid)references Books (Book_Id),
book_copies_branchid int,
foreign key (book_copies_branchid)references Library_Branch (library_branch_BranchId),
book_copies_no_of_copies int);

select*from COPIES;

select count(*) from COPIES;

drop table Book_Loans;

create table Book_Loans(
book_loans_loansId int primary key AUTO_INCREMENT,
book_loans_BookID int  NOT NULL,
foreign key (book_loans_BookID)references Books (Book_Id),
book_loans_BranchID int ,
foreign key (book_loans_BranchID)references Library_Branch(library_branch_BranchId),
book_loans_CardNo int,
foreign key (book_loans_CardNo)references Borrower (Borrower_cardNo),
book_loans_DateOut date,
book_loans_DueDate date);

select *from Book_loans;

use library;


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select library_branch_BranchName, book_copies_no_of_copies as no_of_copies
FROM ((Books NATURAL JOIN COPIES ) NATURAL JOIN Library_Branch ) 
WHERE Title='The Lost Tribe' AND library_branch_BranchName='Sharpstown';

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select library_branch_BranchName, book_copies_no_of_copies as no_of_copies
FROM ((Books NATURAL JOIN COPIES ) NATURAL JOIN Library_Branch ) 
WHERE Title='The Lost Tribe'; 

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
SELECT Borrower_Name
FROM Borrower
where Borrower_cardNo not in (select book_loans_cardno from book_loans);


-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select title, Borrower_Name, Borrower_Address, bl.book_loans_DueDate, lb.library_branch_BranchName
from Books 
join Book_Loans as bl
on Book_Id = bl.book_loans_loansId
join Borrower as b
on bl.book_loans_CardNo = b.Borrower_cardNo
join Library_Branch as lb
on library_branch_BranchID = book_loans_BranchID
where (book_loans_DueDate = '2018-03-02' and library_branch_BranchName = 'Sharpstown');


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName, count(*) as total_no_of_books
from Library_Branch as lb
join Book_Loans as bl
on library_branch_BranchID = book_loans_BranchID
group by lb.library_branch_BranchName;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT Borrower_cardNo, Borrower_Name, Borrower_address, COUNT(*)
FROM Borrower B, Book_Loans bl
WHERE Borrower_cardNo = book_loans_CardNo
GROUP BY Borrower_cardNo
HAVING COUNT(*) > 5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT Title,book_copies_no_of_copies as no_of_copies
FROM ( ( (BOOK_AUTHORS NATURAL JOIN Books) NATURAL JOIN COPIES)
NATURAL JOIN Library_Branch)
WHERE book_authors_authorname = 'Stephen King' and library_branch_BranchName = 'Central';

