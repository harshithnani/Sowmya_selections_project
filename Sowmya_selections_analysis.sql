-- =====================================================
-- Customer Fabric Purchase Analysis (Dec - May)
-- =====================================================
-- Table: customer_purchases
-- Columns: s_no, customer_name, city, state, phone_number,
--          fabric_purchased, purchase_month
-- Note: fabric_purchased may contain multiple comma-separated
-- fabric names in a single cell (e.g. "Cotton, Silk").
-- =====================================================

USE your_database_name;  -- update to your actual database name

-- =====================================================
-- SCHEMA & LOAD (for reference / reproducing the import)
-- =====================================================
CREATE TABLE customer_purchases (
    s_no INT,
    customer_name VARCHAR(500),
    city VARCHAR(500),
    state VARCHAR(500),
    phone_number VARCHAR(500),
    fabric_purchased VARCHAR(500),
    purchase_month VARCHAR(500)
);

-- Combine all 6 monthly sheets into one CSV first (with a purchase_month
-- column added), then load with an extra @dummy column to absorb any
-- stray trailing column from the source file:
-- LOAD DATA INFILE 'path/to/your_file.csv'
-- INTO TABLE customer_purchases
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (s_no, customer_name, city, state, phone_number, fabric_purchased, purchase_month, @dummy);


-- =====================================================
-- Q1: Total unique customers overall
-- =====================================================
SELECT COUNT(DISTINCT phone_number) AS unique_customers
FROM customer_purchases;

-- Check for near-duplicate / inconsistent phone number formatting
SELECT phone_number, COUNT(*) 
FROM customer_purchases
GROUP BY phone_number
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 20;


-- =====================================================
-- Q2: Month-wise purchase count - which month has the most
-- fabric purchases, and how many?
-- =====================================================
SELECT 
    purchase_month,
    COUNT(*) AS total_purchase_records,
    COUNT(DISTINCT phone_number) AS unique_customers
FROM customer_purchases
GROUP BY purchase_month
ORDER BY total_purchase_records DESC;


-- =====================================================
-- Q3: Filter purchases for a specific fabric (handles
-- comma-separated multi-fabric cells with LIKE)
-- =====================================================
SELECT 
    purchase_month,
    COUNT(*) AS purchase_count
FROM customer_purchases
WHERE fabric_purchased LIKE '%RADHA KRISHNA%'
GROUP BY purchase_month
ORDER BY purchase_count DESC;


-- =====================================================
-- Q4: Customer count by month, in true chronological order
-- (Dec -> May), not alphabetical
-- =====================================================
SELECT 
    purchase_month,
    COUNT(DISTINCT phone_number) AS customer_count
FROM customer_purchases
GROUP BY purchase_month
ORDER BY 
    CASE purchase_month
        WHEN 'December' THEN 1
        WHEN 'January' THEN 2
        WHEN 'February' THEN 3
        WHEN 'March' THEN 4
        WHEN 'April' THEN 5
        WHEN 'May' THEN 6
    END;


-- =====================================================
-- Q5: Repeat customer rate - % of customers who purchased
-- in more than one month
-- =====================================================
WITH customer_months AS (
    SELECT 
        phone_number,
        COUNT(DISTINCT purchase_month) AS months_active
    FROM customer_purchases
    WHERE phone_number IS NOT NULL AND phone_number <> ''
    GROUP BY phone_number
)
SELECT 
    COUNT(*) AS total_unique_customers,
    SUM(CASE WHEN months_active >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN months_active >= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS repeat_customer_pct
FROM customer_months;


-- =====================================================
-- Q6: Do repeat customers buy the same fabric again, or
-- different ones each time? (self-join across months)
-- =====================================================
SELECT 
    a.phone_number,
    a.purchase_month AS month_1,
    a.fabric_purchased AS fabric_1,
    b.purchase_month AS month_2,
    b.fabric_purchased AS fabric_2,
    CASE WHEN a.fabric_purchased = b.fabric_purchased 
         THEN 'Same Fabric' ELSE 'Different Fabric' END AS repeat_pattern
FROM customer_purchases a
JOIN customer_purchases b 
    ON a.phone_number = b.phone_number 
    AND a.purchase_month < b.purchase_month
WHERE a.phone_number IS NOT NULL AND a.phone_number <> '';


-- =====================================================
-- Q7: Data quality - % of rows with missing city/state/phone
-- (checks BOTH NULL and empty string, since blank CSV cells
-- loaded as '' rather than true NULL)
-- =====================================================
SELECT 
    SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS missing_city,
    ROUND(SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_missing_city,
    SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) AS missing_state,
    ROUND(SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_missing_state,
    SUM(CASE WHEN phone_number IS NULL OR phone_number = '' THEN 1 ELSE 0 END) AS missing_phone,
    ROUND(SUM(CASE WHEN phone_number IS NULL OR phone_number = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_missing_phone,
    COUNT(*) AS total_rows
FROM customer_purchases;


-- =====================================================
-- Q8: Data quality - malformed name/address entries
-- (flags unusually long customer_name values, which likely
-- indicate a name+address merge from inconsistent source data)
-- =====================================================
SELECT COUNT(*) AS malformed_name_count
FROM customer_purchases
WHERE LENGTH(customer_name) > 40;

SELECT customer_name FROM customer_purchases
WHERE LENGTH(customer_name) > 40
LIMIT 10;
