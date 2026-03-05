-- ============================================================
-- Lab 02: SQL Fundamentals
-- Author: Touqeer
-- Date: March 2026
-- ============================================================
-- Query 1: Explore the data
SELECT * FROM customers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;

-- Query 2: Select specific columns
SELECT name, city, signup_date FROM customers ORDER BY signup_date DESC;

-- Query 3: Filter by status
SELECT order_id, customer_id, total_amount, order_date FROM orders 
WHERE status = 'delivered' ORDER BY order_date DESC;
-- Method A: BETWEEN
SELECT product_name, category, price FROM products 
WHERE price BETWEEN 1000 AND 5000 ORDER BY price;

-- Method B: Comparison operators
SELECT product_name, category, price FROM products 
WHERE price >= 1000 AND price <= 5000 ORDER BY price;
-- Query 5: Top 10 highest-value orders
SELECT order_id, customer_id, total_amount, status FROM orders 
ORDER BY total_amount DESC LIMIT 10;

-- Query 6: Multi-condition filter (2025 high-value delivered)
SELECT order_id, customer_id, total_amount, order_date FROM orders
WHERE status = 'delivered' AND order_date >= '2025-01-01' AND total_amount > 10000
ORDER BY total_amount DESC;

-- Query 7: Pattern matching (Gmail users)
SELECT name, email, city FROM customers 
WHERE email LIKE '%@gmail.com' ORDER BY name;
-- Query 8: NULL handling (Unshipped orders)
SELECT order_id, customer_id, order_date, status FROM orders 
WHERE shipped_date IS NULL ORDER BY order_date;

-- Query 9: Computed Columns (20% Discount)
SELECT product_name, price AS original_price, 
ROUND(price * 0.80, 2) AS discounted_price, ROUND(price * 0.20, 2) AS savings
FROM products ORDER BY discounted_price DESC;

-- Query 10: Conditional Logic (Priority Tiers)
SELECT order_id, total_amount, order_date,
CASE 
    WHEN total_amount > 20000 THEN 'CRITICAL'
    WHEN total_amount > 10000 THEN 'URGENT'
    ELSE 'NORMAL'
END AS priority
FROM orders WHERE shipped_date IS NULL AND order_date >= '2025-01-01'
ORDER BY total_amount DESC LIMIT 5;
