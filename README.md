# cafe-sales-analytics-mysql
### Project Overview

This is a database-driven project designed to track and manage all core sales activities within a business. This project emphasizes database design, normalization, and SQL proficiency through real-world scenarios such as generating sales reports, identifying best-selling products, and calculating revenue trends.

### Project Objective

Design a Relational Database Schema 
* Data Cleaning: Identify and remove any records with missing or null values.
* Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
* Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
* Visualization : Developing dashboards and reports with Excel and Power BI to present data through interactive charts, graphs, and visualizations."

### Project Structure

1. Create a Database `cafe_db`
```ruby
 CREATE DATABASE cafe_db
```
   
2. Create a Table `orders` and `product`
```ruby
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

```
 
3. Data Exploration & Cleaning
* Record Count: Determine the total number of records in the dataset.
* Products Count: Find out how many products are in the dataset.
* Category Count: Identify all unique product categories in the dataset.
* Null Value Check: Check for any null values in the dataset and delete records with missing data or assign value.
```ruby
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM product;

SELECT COUNT(name) FROM product;
SELECT DISTINCT(name) AS Category FROM product;

SELECT * FROM orders
WHERE id IS NULL OR order_id IS NULL OR product_id IS NULL OR quantity IS NULL OR total IS NULL OR updated_at IS NULL OR created_at IS NULL
;

SELECT * FROM product
WHERE id IS NULL OR	name IS NULL OR price IS NULL OR	status IS NULL OR	created_at IS NULL OR updated_at IS NULL
;
```

4. Business Analysis:-

Q1. How many orders are in the orders table?
```ruby
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;
```

Q2. List all products with their price.
```ruby
SELECT id, name, price
FROM product;
```

Q3. Show the first 10 rows of the orders table.
```ruby
SELECT *
FROM orders
LIMIT 10;
```

Q4. How many unique products were sold?
```ruby
SELECT COUNT(DISTINCT product_id) AS unique_products_sold
FROM orders;
```

Q5. What is the total revenue?
```ruby
SELECT SUM(total) AS total_revenue
FROM orders;
```

Q6. What is the total quantity sold?
```ruby
SELECT SUM(quantity) AS total_quantity
FROM orders;
```

Q7. What is the average price per item sold?
```ruby
SELECT ROUND(SUM(total) / SUM(quantity), 2) AS avg_price_per_item
FROM orders;
```

Q8. What is the Daily revenue summary?
```ruby
SELECT 
    DATE(created_at) AS sale_date,
    SUM(total) AS daily_revenue
FROM orders
GROUP BY sale_date
ORDER BY sale_date;
```

Q9. Total sales per product
```ruby
SELECT 
    p.name,
    SUM(o.quantity) AS total_units,
    SUM(o.total) AS total_revenue
FROM orders o
JOIN product p ON o.product_id = p.id
GROUP BY p.name
ORDER BY total_revenue DESC;
```

Q10. What are the top 5 best-selling products by quantity?
```ruby
SELECT 
    p.name,
    SUM(o.quantity) AS quantity_sold
FROM orders o
JOIN product p ON o.product_id = p.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

Q11: How many products were never sold?
```ruby
SELECT 
    p.id, p.name
FROM product p
LEFT JOIN orders o ON p.id = o.product_id
WHERE o.id IS NULL;
```

Q12: Show the monthly revenue trend.
```ruby
SELECT 
    EXTRACT(MONTH FROM created_at) AS month,
    SUM(total) AS revenue
FROM orders
GROUP BY month
ORDER BY month;
```

Q13: What is the average order value (AOV) over time? (total revenue / count of orders)
```ruby
SELECT 
    DATE(created_at) AS order_date,
    COUNT(DISTINCT order_id) AS num_orders,
    SUM(total) / COUNT(DISTINCT order_id) AS average_order_value
FROM orders
GROUP BY order_date
ORDER BY order_date;
```

Q14: Which day of the week performs best?
```ruby
SELECT 
    DAY(created_at) AS weekday,
    COUNT(DISTINCT order_id) AS num_orders,
    SUM(total) AS revenue
FROM orders
GROUP BY weekday
ORDER BY revenue DESC
LIMIT 10;
```

Q15: Rank products by total sales each month
```ruby
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
```
### Visualization using Excel/Power BI
