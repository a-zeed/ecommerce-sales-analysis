-- =====================================================
-- E-COMMERCE SALES ANALYSIS PROJECT
-- SQL ANALYSIS QUERIES
-- =====================================================



-- =====================================================
-- 1. TOTAL REVENUE
-- =====================================================

SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;

-- Insight:
-- The business generated over 16 million in total revenue,
-- indicating strong overall sales performance across the dataset period.



-- =====================================================
-- 2. TOTAL ORDERS
-- =====================================================

SELECT 
    COUNT(*) AS total_orders
FROM orders;

-- Insight:
-- The platform processed a high volume of orders, demonstrating
-- substantial customer activity and marketplace engagement.



-- =====================================================
-- 3. ORDER STATUS BREAKDOWN
-- =====================================================

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Insight:
-- Most orders were successfully delivered, suggesting efficient
-- order fulfillment and operational performance across the platform.



-- =====================================================
-- 4. TOP 10 BEST-SELLING PRODUCTS
-- =====================================================

SELECT 
    p.product_category_name,
    oi.product_id,
    ROUND(SUM(pay.payment_value), 2) AS revenue
FROM order_items oi
JOIN payments pay
    ON oi.order_id = pay.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name, oi.product_id
ORDER BY revenue DESC
LIMIT 10;

-- Insight:
-- Products in the telefonia_fixa category generated the highest revenue,
-- indicating strong customer demand for telecommunications-related products.

-- Business Recommendation:
-- The company should prioritize inventory management, supplier relationships,
-- and targeted marketing campaigns within telecommunications-related categories
-- to maximize future revenue growth.



-- =====================================================
-- 5. TOP CUSTOMERS BY SPENDING
-- =====================================================

SELECT 
    c.customer_unique_id,
    ROUND(SUM(p.payment_value), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- Insight:
-- A small number of customers contribute disproportionately to total revenue,
-- with top customers spending significantly more than the average buyer.

-- Business Recommendation:
-- The company should implement loyalty programs, personalized offers,
-- and retention strategies for high-value customers to improve long-term revenue.



-- =====================================================
-- 6. MONTHLY REVENUE TREND
-- =====================================================

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- Insight:
-- Revenue shows strong and consistent growth from early 2017 onward,
-- indicating business expansion and increasing customer activity over time.

-- Insight:
-- Significant spikes observed during late 2017 suggest seasonal demand,
-- promotional campaigns, or holiday-driven purchasing behavior.

-- Insight:
-- Extremely low revenue values in late 2016 likely indicate incomplete
-- or early-stage operational data rather than actual poor performance.



-- =====================================================
-- 7. TOP PRODUCT CATEGORIES BY REVENUE
-- =====================================================

SELECT 
    p.product_category_name,
    ROUND(SUM(pay.payment_value), 2) AS revenue
FROM order_items oi
JOIN payments pay
    ON oi.order_id = pay.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- Insight:
-- The top-performing product categories are cama_mesa_banho,
-- beleza_saude, and informatica_acessorios, each generating
-- over 1.5 million in revenue.

-- Insight:
-- Strong revenue performance across home, beauty, and technology-related
-- categories suggests broad consumer demand across multiple segments.

-- Business Recommendation:
-- The company should prioritize these high-performing categories through
-- increased inventory allocation, optimized pricing strategies,
-- and targeted digital marketing campaigns.



-- =====================================================
-- 8. CATEGORY PERFORMANCE ANALYSIS
-- =====================================================

SELECT 
    p.product_category_name,
    COUNT(oi.order_id) AS total_orders,
    ROUND(SUM(pay.payment_value), 2) AS revenue,
    ROUND(AVG(pay.payment_value), 2) AS avg_order_value
FROM order_items oi
JOIN payments pay
    ON oi.order_id = pay.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- Insight:
-- cama_mesa_banho performs strongly primarily due to high order volume,
-- indicating mass-market popularity and consistent customer demand.

-- Insight:
-- beleza_saude demonstrates a strong balance between order volume
-- and average order value, making it a stable revenue-generating category.

-- Insight:
-- informatica_acessorios revenue appears to be driven more by
-- higher-priced products than sheer transaction volume.

-- Insight:
-- relogios_presentes functions as a premium category with
-- fewer purchases but significantly higher-value transactions.

-- Business Recommendation:
-- High-volume categories should focus on scaling inventory,
-- bundling strategies, and promotional campaigns.

-- Business Recommendation:
-- Premium categories should emphasize product positioning,
-- brand value, and higher profit margins rather than sales volume.



-- =====================================================
-- 9. MONTHLY ORDERS AND REVENUE ANALYSIS
-- =====================================================

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- Insight:
-- The business experienced strong and consistent growth throughout
-- 2017 and early 2018, with both order volume and revenue increasing steadily.

-- Insight:
-- December 2016 showed an abnormal decline with extremely low order
-- activity and revenue, likely indicating incomplete or missing data.

-- Insight:
-- A sharp decline observed in late 2018 may suggest reporting inconsistencies,
-- incomplete records, or temporary operational disruptions.

-- Business Recommendation:
-- The company should analyze operational strategies implemented during
-- high-growth periods and replicate successful practices to sustain expansion.



-- =====================================================
-- 10. MONTHLY GROWTH RATE ANALYSIS
-- =====================================================

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY month
)

SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month) * 100,
    2) AS growth_percent
FROM monthly_revenue;

-- Insight:
-- The business demonstrates generally positive month-to-month growth,
-- with moderate fluctuations across most periods.

-- Insight:
-- Revenue spikes during late 2017 suggest strong seasonal purchasing behavior,
-- likely influenced by promotions, holidays, or large-scale campaigns.

-- Insight:
-- Extreme fluctuations observed during late 2016 and late 2018 are likely
-- caused by incomplete data rather than actual business performance.

-- Overall Finding:
-- The company exhibits stable long-term growth trends with periodic
-- seasonal surges, indicating a healthy and expanding e-commerce business.



-- =====================================================
-- 11. DATA CLEANING & QUALITY CHECKS
-- =====================================================

-- Check for missing or invalid payment values
SELECT *
FROM payments
WHERE payment_value IS NULL
   OR payment_value <= 0;

-- Check count of null payment values
SELECT 
    COUNT(*) AS null_payment_values
FROM payments
WHERE payment_value IS NULL;

-- Preview purchase timestamps
SELECT 
    order_purchase_timestamp
FROM orders
LIMIT 5;

-- Data Quality Finding:
-- Very few missing or invalid payment records were identified,
-- indicating relatively strong transactional data quality overall.

-- Data Quality Finding:
-- Certain time periods contain unusually low activity,
-- suggesting possible incomplete historical records.