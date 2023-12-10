USE SampleSales

------/////////////////----

----FULL  OUTER JOIN ----
--Write a query that returns stock and order information together for all products.
--(Top 20)
--Expected columns: Product_id,store_id, quantity,order_id, list_price

SELECT TOP 20			A.product_id AS Stock, A.store_id, B.quantity, B.list_price,B.order_id, B.product_id AS order_Productid
FROM					product.stock A

FULL OUTER JOIN			sale.order_item B ON A.product_id = B.product_id

ORDER BY				A.product_id, B.order_id;


----///////-----

--CROSS JOIN---
-- In SQL the Cross Join is used to combine each row of the first table with
--each row of the second table. It is also known as the Cartesian join
--since it returns the Cartesian product of the sets of rows from the joined
--tables.

/*
Syntax:
SELECT			columns
FROM			table_A
CROSS JOIN		table_B

*/

--Query Time:
--Write a query that returns all brand X category possibities.
--Expected columns: brand_id, brand_name,  category_id, category_name

SELECT * FROM product.brand

SELECT  * FROM product.category


SELECT				*
FROM				product.brand A
CROSS JOIN			product.category B
ORDER BY			A.brand_id, B.category_id


----SELF JOIN---
--SELF JOIN  is a join of  a table to itself. Joining a table to itself means
--that each row of the table is combined with itself and the other rows of the
--table.
--A SELF JOIN can be defined as a combination of two copies of the same table.

SELECT * FROM sale.staff

--Query Time
--Write a query that returns the staff with their managers.
--Expected columns:staff first name, staff last name, manager name.

SELECT			STF.first_name, STF.last_name, MNG.first_name
FROM			sale.staff STF
JOIN			sale.staff MNG ON STF.manager_id = MNG.staff_id;

--To find person who has no manager above them we can use LEFT JOIN:

SELECT			STF.first_name AS staff_first, STF.last_name AS staff_last, MNG.first_name AS manager_name
FROM			sale.staff STF
LEFT JOIN		sale.staff MNG ON STF.manager_id = MNG.staff_id;

--Query Time:
--Write a query that returns the 1st and 2nd degree managers of all staff
--Expected columns: staff name, first manager name, second manager name

SELECT			STF.first_name AS StaffFirstName, MGR.first_name AS ManagerFirst, MGR1.first_name AS ManagersManager
FROM			sale.staff STF
JOIN			sale.staff MGR ON STF.manager_id = MGR.staff_id
JOIN			sale.staff MGR1 ON MGR.manager_id =MGR1.staff_id
ORDER BY		3,2

--------///////////--------

--ADVANCED GROUPING OPERATIONS
	--HAVING CLAUSE
	--GROUPING SETS
	--ROLLUP
	--CUBE
	--PIVOT


SELECT				category_name, COUNT(product_id) AS cnt_product
FROM				product.product A, product.category B
WHERE				A.category_id = B.category_id	
GROUP BY			category_name

--Whenever we use aggragete function we have to use GROUP BY clause.

SELECT * FROM	product.product

SELECT * FROM	product.category	

--How many : COUNT   (how many of a particular item has been  ordered)
--How much: SUM		 (whats the total sales for last year?)
--The average:AVG	 (whats the average amount of sales per customer?)
--the least, lowest: MIN		
--the heighest, the most popular: MAX	(what is our most or least popular item?)


--HAVING CLAUSE
--HAVING clause is not nothing but filtering of aggregated clause.

--GROUP BY
--The GROUP BY clause groups rows into summary rows or groups.
--The HAVING clause filters groups on a specified condition.
--You have to use the HAVING clause with the GROUP BY. 
--Otherwise, you will get an error.

/*
Syntax:
SELECT			column_1,  aggragete_function(column_2)
FROM			table_name
GROUP BY		column_1
HAVING			search_condition;

*/


The logic of how SQL works:
FROM ==> WHERE ==> GROUP BY ==> HAVING ==> SELECT ==> ORDER BY

SELECT				brand_name, AVG(list_price) AS avg_list_price
FROM				product.product A, product.brand B
WHERE				A.brand_id = B.brand_id
AND					A.model_year > 2016
GROUP BY		
					brand_name	
HAVING				AVG(list_price) > 1000
ORDER BY
					AVG(list_price) ASC;

--Using WHERE, the fields to be grouped over the filtered rows 
--are determined and a new field is created with the aggregate 
--operation.

--WHERE is taken into account at an earlier stage of a query 
--execution, filtering the rows read from the tables.

--And then HAVING is used if you want to filter the newly created
--field within the same query.


--Example: 
Sunglass 10, 20, 30

SELECT how many sales of sunglasses where amount > 10

SELECT		product, COUNT(orders)
FROM		table
WHERE		product = "sunglass"			--first filter
GROUP BY	product
HAVING		amount >10						--filter aggragete,group


--Query Time:
--Write a query that checks if any product id is repeated in more than one
--row in the products table.
--Expected columns: product_id, num_of_rows

SELECT				product_id, COUNT(product_id) AS number_of_rows
FROM				product.product 
GROUP BY			product_id
HAVING				COUNT(product_id) > 1



--List all products that have been ordered in more than 100 orders

SELECT			O.product_id, P.product_name, COUNT(O.product_id) AS number_of_order
FROM			sale.order_item O
JOIN			product.product P ON O.product_id =P.product_id
GROUP BY		O.product_id, P.product_name
HAVING			COUNT(O.product_id) > 100
ORDER By		3 DESC;

SELECT * FROM sale.order_item

--Query Time:
--Write a query that returns category ids with a maximum list price
--above 4000 or a minimum list price below 500.
--Expected Output: category_id, max_price, min_price

SELECT			B.category_id, MAX(A.list_price) AS max_price, MIN(A.list_price) AS min_price
FROM			product.product A
JOIN			product.category B ON A.category_id = B.category_id
GROUP BY		B.category_id
HAVING			MAX(A.list_price) > 4000 OR MIN(A.list_price) < 500;

--Query Time: 
--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.
--Expected output: brand_name, avg_list_price

SELECT			B.brand_name, AVG(A.list_price) AS avg_list_price
FROM			product.product A
JOIN			product.brand B ON A.brand_id = B.brand_id
GROUP By		B.brand_name
ORDER BY		avg_list_price DESC;


SELECT			B.brand_name, ROUND(AVG(A.list_price),2) AS avg_list_price
FROM			product.product A
JOIN			product.brand B ON A.brand_id = B.brand_id
GROUP By		B.brand_name
ORDER BY		avg_list_price DESC;

--2nd way of writing the same query above;

SELECT			B.brand_name, ROUND(AVG(A.list_price),2) AS avg_list_price
FROM			product.product A, product.brand B
WHERE			A.brand_id = B.brand_id
GROUP By		B.brand_name
ORDER BY		avg_list_price DESC;



SELECT			brand_name, LEN(brand_name)
FROM			product.brand;

SELECT			brand_name, MAX(LEN(brand_name))
FROM			product.brand
GROUP BY		brand_name
ORDER BY		2 DESC;

----------------------------------

---Query Time:
--Write a query that returns BRANDS with an 
--average product price of more than  1000.
--Expected columms: brand_name, avg_list_price

SELECT			B.brand_name, AVG(A.list_price) AS avg_list_price
FROM			product.product A
JOIN			product.brand B ON A.brand_id = B.brand_id
GROUP BY		B.brand_name
HAVING			AVG(list_price) > 1000
ORDER BY		avg_list_price DESC;

--Query Time
--Write a query that returns the net price paid by the customer 
--for each order. (Don't neglect discounts and quantities).
--Expected Output: order_id, net_price

SELECT			*	
FROM			sale.order_item;

SELECT			order_id, quantity * list_price *(1-discount) AS net_price
FROM			sale.order_item;

SELECT			order_id, SUM(quantity * list_price *(1-discount)) AS net_price
FROM			sale.order_item
GROUP BY		order_id
---------------------------------
--Create a  table out of result set

----------//////////////////////////-------
----------GROUPING SETS-------

--SELECT			<Columns2>
--INTO			<New Table Name>
--FROM			<Table Names>
--WHERE			<condition>

-----------------------------------

SELECT			order_id, SUM(quantity * list_price *(1-discount)) AS net_price
INTO			testsession2
FROM			sale.order_item
GROUP BY		order_id

SELECT * FROM testsession2;

SELECT			order_id, SUM(quantity * list_price *(1-discount)) AS net_price
INTO			#testsession2
FROM			sale.order_item
GROUP BY		order_id

--# creates a temporary table, whenever we close the session it's gone.
