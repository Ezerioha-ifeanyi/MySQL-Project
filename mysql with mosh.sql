-- SELECT CLAUSE EXERCISE

-- Return all the products
-- name
-- unit price
-- new price (unit price * 1.1)

SELECT 
	name, 
    unit_price, 
    unit_price * 1.1 AS new_price 
FROM products;


-- WHERE CLAUSE EXERCISE
-- Get the orders placed in the year 2019

USE sql_store;

SELECT * FROM orders
WHERE YEAR(order_date) = '2019';


-- From the order_items table, get the items
-- for order #6
-- where the total price is greater than 30

SELECT * 
FROM order_items
WHERE order_id = 6 
AND (quantity * unit_price) > 30;


-- IN statement exercise
-- Return products with
--    quantity in stock equal to 49, 38, 72

USE sql_inventory;

SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- BETWEEN exercise
-- Return customers born
--    between 1/1/1990 and 1/1/2000

USE sql_store;

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990/1/1' AND '2000/1/1';

-- LIKE exercise
-- Get the customers whose
--     addresses contain TRAIL or AVENUE

SELECT *
FROM customers 
WHERE address LIKE '%AVENUE%' OR address LIKE 
'%TRAIL%' ;


--    phone number end with 9
SELECT *
FROM customers 
WHERE phone LIKE '%9';

-- REGEXP exercise

-- Get the customers whose

--    first names are ELKA or AMBUR

SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';


--    last names end with EY or ON

SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$';


--    last names start with MY or contains SE

SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';


--    last names contains B followed by R or U

SELECT *
FROM customers
WHERE last_name REGEXP 'B[RU]';


-- IS NULL exercise

-- Get the orders that are not shipped 

SELECT *
FROM orders
WHERE shipped_date IS NULL;


-- ORDER BY Exercise
SELECT *
FROM order_items
WHERE order_id = 2
ORDER BY (quantity * unit_price) DESC;



-- LIMIT exercise
-- Get the top 3 loyal customers (i.e customers with more points)
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- Inner Joins Exercise
SELECT order_id, o.product_id, name, quantity, o.unit_price
FROM order_items o
JOIN products p
	ON o.product_id = p.product_id;


-- Joining multiole tables
SELECT order_id, order_date, first_name, last_name, name AS status
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id 
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY name, order_id;


USE sql_invoicing;

SELECT p.payment_id, p.date, p.amount, c.name AS 'client name', c.city, c.state,  pm.name AS 'payment method'
FROM payments p
JOIN clients c ON p.client_id = c.client_id
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id;
 
 
 -- Compound join example
 
 USE sql_store; 
 SELECT *
 FROM order_items oi
 JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;
    
    
-- Outer Join Exercise

SELECT p.product_id, name, o.quantity
FROM products p
LEFT JOIN order_items o
	ON o.product_id = p.product_id;
    

SELECT o.order_date, o.order_id, c.first_name, s.name AS shipper, os.name AS status
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
ORDER BY status, order_id;

-- USING exercise
USE sql_invoicing;

SELECT p.date, c.name AS client, p.amount , pm.name
FROM payments p
JOIN clients c
USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.Payment_method_id;

-- CROSS JOIN exercise
--     Do a cross join between shippers and product
--         using the implicit syntax
--         and then the explicit syntax


--   Implicit syntax

SELECT *
FROM shippers, products;

--   Explicit syntax

SELECT *
FROM shippers
CROSS JOIN products;


--  UNIONS Exercise
SELECT customer_id, first_name, points, 'Bronze'AS type
FROM customers
WHERE points < 2000
UNION
SELECT customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id, first_name, points, 'Gold' AS type
FROM customers
WHERE points > 3000

ORDER BY first_name;


-- INSERT Exercise
INSERT INTO sql_inventory.products(name, quantity_in_stock, unit_price)
VALUES ('Hot Dog', 5, 4.5),
	('Sharwama', 13, 7.5),
    ('Suya', 10, 50.2);
    
SELECT LAST_INSERT_ID();

-- Copy Table Exercise
USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT invoice_id, number, invoice_total, payment_total, invoice_date, due_date, payment_date, name AS Client
FROM invoices i
LEFT JOIN clients c
ON i.client_id = c.client_id
WHERE i.payment_date IS NOT NULL
ORDER BY invoice_id;

-- UPDATE MULTIPLE ROWS EXERCISE
-- Write a SQL statement to
--    give any customer born before 1990
--    50 extra points

USE sql_store;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- Using Subqueries in UPDATE syntax Exercise
-- Write a SQL statement that updates the comments for orders who have > 3000 points
-- 			For those that have > 3000 points
-- 			ind their order if they have placed an order, and update it to Gold Customers

UPDATE orders
SET comments = 'Gold Customer'
WHERE customer_id IN(
			SELECT customer_id
			FROM customers
			WHERE points > 3000)