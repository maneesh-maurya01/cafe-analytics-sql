-- Create a Database
-- CREATE DATABASE cafe_db;

-- Create a Table
CREATE TABLE orders(
id INT PRIMARY KEY,
order_id INT,	
product_id INT,
quantity INT,
total DECIMAL,
updated_at TIMESTAMP,
created_at TIMESTAMP,
FOREIGN KEY (product_id) 
REFERENCES product(id)
);

CREATE TABLE product(
id INT PRIMARY KEY,
name TEXT,	
price DECIMAL,
status	TEXT,
created_at	TIMESTAMP,
updated_at TIMESTAMP


);


-- DATA Exploration
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM product;

SELECT COUNT(name) FROM product;
SELECT DISTINCT(name) AS Category FROM product;

SELECT 
    *
FROM
    orders
WHERE
    id IS NULL OR order_id IS NULL
        OR product_id IS NULL
        OR quantity IS NULL
        OR total IS NULL
        OR updated_at IS NULL
        OR created_at IS NULL
;
SELECT 
    *
FROM
    product
WHERE
    id IS NULL OR name IS NULL
        OR price IS NULL
        OR status IS NULL
        OR created_at IS NULL
        OR updated_at IS NULL
;

-- STEP 1 : Understanding the sales summary

-- Q1. How many orders are in the orders table?
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- Q2. List all products with their price.
SELECT id, name, price
FROM product;


-- Q3. Show the first 10 rows of the orders table.
SELECT *
FROM orders
LIMIT 10;



-- Q4. How many unique products were sold?
SELECT COUNT(DISTINCT product_id) AS unique_products_sold
FROM orders;


-- STEP 2: Aggregations & Filtering

-- Q5. What is the total revenue?
SELECT SUM(total) AS total_revenue
FROM orders;


-- Q6. What is the total quantity sold?
SELECT SUM(quantity) AS total_quantity
FROM orders;


-- Q7. What is the average price per item sold?
SELECT ROUND(SUM(total) / SUM(quantity), 2) AS avg_price_per_item
FROM orders;


-- Q8. What is the Daily revenue summary?
SELECT 
    DATE(created_at) AS sale_date,
    SUM(total) AS daily_revenue
FROM orders
GROUP BY sale_date
ORDER BY sale_date;


-- STEP 3: Grouping & Joining


-- Q9. Total sales per product
SELECT 
    p.name,
    SUM(o.quantity) AS total_units,
    SUM(o.total) AS total_revenue
FROM orders o
JOIN product p ON o.product_id = p.id
GROUP BY p.name
ORDER BY total_revenue DESC;


-- Q10. What are the top 5 best-selling products by quantity?
SELECT 
    p.name,
    SUM(o.quantity) AS quantity_sold
FROM orders o
JOIN product p ON o.product_id = p.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q11: How many products were never sold?
SELECT 
    p.id, p.name
FROM product p
LEFT JOIN orders o ON p.id = o.product_id
WHERE o.id IS NULL;


-- Q12: Show the monthly revenue trend.
SELECT 
    EXTRACT(MONTH FROM created_at) AS month,
    SUM(total) AS revenue
FROM orders
GROUP BY month
ORDER BY month;


-- Q13: What is the average order value (AOV) over time? (total revenue / count of orders)
SELECT 
    DATE(created_at) AS order_date,
    COUNT(DISTINCT order_id) AS num_orders,
    SUM(total) / COUNT(DISTINCT order_id) AS average_order_value
FROM orders
GROUP BY order_date
ORDER BY order_date;


-- Q14: Which day of the week performs best?
SELECT 
    DAY(created_at) AS weekday,
    COUNT(DISTINCT order_id) AS num_orders,
    SUM(total) AS revenue
FROM orders
GROUP BY weekday
ORDER BY revenue DESC
LIMIT 10;

-- Q15: Rank products by total sales each month
WITH monthly_product_sales AS (
    SELECT 
        EXTRACT(month FROM o.created_at) AS sale_month,
        p.name,
        SUM(o.total) AS total_sales
    FROM orders o
    JOIN product p ON o.product_id = p.id
    GROUP BY sale_month, p.name
)
SELECT *,
       RANK() OVER (PARTITION BY sale_month ORDER BY total_sales DESC) AS sales_rank
FROM monthly_product_sales;
