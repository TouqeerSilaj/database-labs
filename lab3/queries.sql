-- ============================================================
-- Lab 03: Advanced SQL Aggregations & Analytics
-- Author: Touqeer
-- Date: 2026-03-06
-- ============================================================

-- Query 1: Overall Business Summary (KPIs)
-- Purpose: Summary of delivered orders to track core business health.
SELECT 
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MAX(total_amount) AS largest_order
FROM orders
WHERE status = 'delivered';

-- Query 2: Revenue by Product Category
-- Purpose: Identifies which product categories are driving the most value.
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS orders_containing,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Query 3: Monthly Order Volume and Revenue
-- Purpose: Time-series analysis to spot seasonal trends or growth.
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(*) AS num_orders,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

-- Query 4: HAVING - Active Cities
-- Purpose: Filters geographic locations with more than 2 orders to find high-activity hubs.
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) > 2
ORDER BY total_orders DESC;

-- Query 5: Device Performance with HAVING
-- Purpose: Analyzes user engagement by device, filtering for statistical significance (5+ sessions).
SELECT 
    device,
    COUNT(*) AS total_sessions,
    ROUND(AVG(duration_mins), 2) AS avg_duration,
    SUM(CASE WHEN converted THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        100.0 * SUM(CASE WHEN converted THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS conversion_rate_pct
FROM user_sessions
GROUP BY device
HAVING COUNT(*) >= 5
   AND AVG(duration_mins) > 15
ORDER BY conversion_rate_pct DESC;

-- Query 6: Ranking Orders with ROW_NUMBER()
-- Purpose: Ranks each customer's personal purchase history from largest to smallest.
SELECT 
    customer_id,
    order_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY total_amount DESC
    ) AS rank_within_customer
FROM orders
ORDER BY customer_id, rank_within_customer;

-- Query 7: Overall Revenue Ranking with RANK vs DENSE_RANK
-- Purpose: Compares global ranking methods, specifically how ties are handled.
SELECT 
    order_id,
    customer_id,
    total_amount,
    RANK() OVER (ORDER BY total_amount DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rank
FROM orders
ORDER BY total_amount DESC
LIMIT 15;

-- Query 8: Month-over-Month (MoM) Revenue Trend with LAG
-- Purpose: Calculates growth metrics by comparing current month to the previous one.
WITH monthly_revenue AS (
    SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'delivered'
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    revenue - LAG(revenue) OVER (ORDER BY month) AS absolute_change,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
        1
    ) AS pct_change
FROM monthly_revenue
ORDER BY month;

-- Query 9: Customer Value Segmentation using CTEs
-- Purpose: Groups customers into tiers (VIP, High Value, etc.) to analyze revenue share.
WITH customer_spend AS (
    SELECT c.customer_id,
    c.name,
    c.city,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'delivered'
    GROUP BY c.customer_id, c.name, c.city
),
customer_tiers AS (
    SELECT *,
    CASE
        WHEN total_spent > 30000 THEN 'VIP'
        WHEN total_spent > 10000 THEN 'High Value'
        WHEN total_spent > 0 THEN 'Active'
        ELSE 'Never Purchased'
    END AS tier
    FROM customer_spend
)
SELECT 
    tier,
    COUNT(*) AS num_customers,
    ROUND(SUM(total_spent), 2) AS tier_revenue,
    ROUND(
        100.0 * SUM(total_spent)
        / NULLIF(SUM(SUM(total_spent)) OVER (), 0),
        1
    ) AS revenue_share_pct
FROM customer_tiers
GROUP BY tier
ORDER BY tier_revenue DESC;

-- Query 10: Session-to-Purchase Funnel Analysis
-- Purpose: Joins behavioral session data with sales data to find churn risks.
WITH session_summary AS (
    SELECT customer_id,
    COUNT(*) AS total_sessions,
    SUM(pages_viewed) AS total_pages,
    ROUND(AVG(duration_mins), 2) AS avg_duration,
    SUM(CASE WHEN converted THEN 1 ELSE 0 END) AS converted_sessions
    FROM user_sessions
    GROUP BY customer_id
),
order_summary AS (
    SELECT customer_id,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
)
SELECT 
    c.name,
    c.city,
    s.total_sessions,
    s.total_pages,
    s.avg_duration,
    COALESCE(o.total_orders, 0) AS total_orders,
    COALESCE(o.total_spent, 0) AS total_spent
FROM session_summary s
JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN order_summary o ON s.customer_id = o.customer_id
ORDER BY s.total_sessions DESC;
