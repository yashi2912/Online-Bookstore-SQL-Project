-- table1 - books--
drop table if exists books;
create table if not exists books
(
Book_ID	serial primary key,
Title varchar(100),
Author varchar(100),
Genre	varchar(50),
Published_Year int,
Price	numeric(10, 2),
Stock int
);

--table2 - customers--
drop table if exists customers;
create table if not exists customers
(
Customer_ID serial primary key,
Name	varchar(100),
Email varchar(100),
Phone	varchar(15),
City	varchar(50),
Country varchar(150)
);

--table3 - orders--
drop table if exists orders;
create table if not exists orders
(
Order_ID serial primary key, 	
Customer_ID int references customers(customer_id),
Book_ID	int references books(book_id),
Order_Date date,
Quantity	int,
Total_Amount numeric(10, 2)
);


select * from books;
select * from customers;
select * from orders;


--1) retrive all books in the 'Fiction' genre.

SELECT * FROM books
WHERE genre='Fiction';


--2) Find books published after the year 1950.

SELECT * FROM books
WHERE published_year>1950;

--3) List all customers from the Canada.

SELECT * FROM customers
WHERE COUNTRY='Canada';

--4) Show orders placed in November 2023.

SELECT * FROM orders
WHERE order_date between '2023-11-01' and '2023-11-30';

--5) Retrieve the total stock of books available.

SELECT SUM(stock)  as Total_stock from books;

--6) Find the details of the most expensive book.

SELECT * from books
order by price desc  limit 1;

--7) Show all customers who ordered more than 1 quantity of a book.

SELECT * FROM orders
where quantity>1;

--8) Retrieve all orders where the total amount exceeds $20.

SELECT * FROM orders
where total_amount>20;

--9) List all genres available in the books table.

SELECT distinct genre from books;

--10) Find the book with lowest stock.

SELECT * FROM books
order by stock asc limit 1;

--11) Calculate the total revenue generated from all orders.

SELECT SUM(total_amount) as Revenue FROM ORDERS; 



--ADVANCED QUESTIONS---

--1) Retrieve the total number of books sold for each genre.

SELECT * from orders;

SELECT b.genre, sum(o.quantity) as total_books_sold
from orders o 
join Books b on o.book_id=b.book_id
group by b.genre;

--2) Find the average price of books in the "Fantasy" genre.

Select avg(price) as average_price 
from books
where genre='Fantasy';


--3) List customers who have placed at least 2 orders

select customer_id, count(order_id) as order_count
from orders
group by customer_id
having count(order_id) >=2;


--4) Find the most frequently ordered book.

select book_id, count(order_id) as order_count
from orders
group by book_id
order by order_count desc limit 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre.

select * from books
where genre='Fantasy'
order by price desc limit 3;

--6) Retrieve the total quantity of books sold by each author.

select b.author, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id=b.book_id
group by b.author;

--7) List the cities where customers who spent over $30 are located.

select distinct c.city, total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>30;

--8) Find the customer who spent the most on orders .

select c.customer_id, c.name, sum(o.total_amount) as Total_Spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by Total_spent desc limit 1;


--9) Calculate the stock remaining after fulfiling all orders.

select b.book_id, b.title, b.stock, coalesce(sum(quantity),0) as order_quantity, 
b.stock - coalesce(sum(quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;

