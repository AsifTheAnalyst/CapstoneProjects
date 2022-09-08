--We will be helping Ginny to keep her Japanese food restaurant business afloat, which she started in 2021. Ginny have couple of months data and need you as SQL expert to help in scaling her business --

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions

--What is the total amount each customer spent at the restaurant?--

SELECT 
s.customer_id, 
SUM(price) AS total_sales
FROM 
dbo.sales AS s
JOIN dbo.menu AS m
ON s.product_id = m.product_id
GROUP BY customer_id;

--How many days has each customer visited the restaurant?--

SELECT 
customer_id, 
 COUNT(DISTINCT(order_date)) AS visit_count
FROM 
dbo.sales
GROUP BY customer_id;

--What was the first item from the menu purchased by each customer?--

WITH ordered_sales_cte AS
(
 SELECT customer_id, order_date, product_name,
 DENSE_RANK() OVER(PARTITION BY s.customer_id
 ORDER BY s.order_date) AS rank
 FROM dbo.sales AS s
 JOIN dbo.menu AS m
 ON s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM ordered_sales_cte
WHERE rank = 1
GROUP BY customer_id, product_name;

--What is the most purchased item on the menu and how many times was it purchased by all customers?--

SELECT (COUNT(s.product_id)) AS most_purchased, product_name
FROM dbo.sales AS s
JOIN dbo.menu AS m
 ON s.product_id = m.product_id
GROUP BY s.product_id, product_name
ORDER BY most_purchased DESC
LIMIT 1;

--Which item was the most popular one for each customer?--

WITH fav_item_cte AS
(
 SELECT s.customer_id, m.product_name, 
 COUNT(m.product_id) AS order_count,
 DENSE_RANK() OVER(PARTITION BY s.customer_id
 ORDER BY COUNT(m.product_id) DESC) AS rank
FROM dbo.menu AS m
JOIN dbo.sales AS s
 ON m.product_id = s.product_id
GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, order_count
FROM fav_item_cte 
WHERE rank = 1;













