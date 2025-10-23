--   CAFE SALES DATA CLEANING & ANALYSIS PROJECT
--   Purpose: Clean, validate, and analyze café sales data

--  CREATE AND SELECT DATABASE
CREATE DATABASE Cafe;
USE Cafe;

--  Loading the data
SELECT * FROM cafe_sales;

-- STEP 1: DATA CLEANING
--  Replace invalid or missing values with NULL
UPDATE cafe_sales
SET 
    quantity = CASE WHEN TRIM(quantity) IN ('', '-', 'error', 'unknown') THEN NULL 
                  ELSE quantity END,
    total_spent = CASE WHEN TRIM(total_spent) IN ('', '-', 'error', 'unknown') THEN NULL 
                     ELSE total_spent END,
price_per_unit = CASE WHEN TRIM(price_per_unit) IN ('', '-', 'error', 'unknown') THEN NULL 
                        ELSE price_per_unit END,
    payment_method = CASE WHEN TRIM(payment_method) IN ('', '-', 'error', 'unknown') THEN NULL 
                        ELSE payment_method END,
    location = CASE WHEN TRIM(location) IN ('', '-', 'error', 'unknown') THEN NULL 
                  ELSE location END,
    transaction_date = CASE WHEN TRIM(transaction_date) IN ('', '-', 'error', 'unknown') THEN NULL 
                          ELSE transaction_date END,
    item = CASE WHEN TRIM(item) IN ('', '-', 'error', 'unknown') THEN NULL 
              ELSE item END;



-- STEP 2: DATA VALIDATION
--  Check total number of complete records (no missing values)
SELECT COUNT(*) AS total_rows,
  SUM( item IS NOT NULL 
           AND total_spent IS NOT NULL
           AND payment_method IS NOT NULL
           AND location IS NOT NULL
           AND transaction_date IS NOT NULL 
         ) AS complete_rows
FROM cafe_sales;



-- STEP 3: CREATE CLEANED DATASET
CREATE TABLE clean_cafe_sales AS
SELECT *
FROM cafe_sales
WHERE item IS NOT NULL
  AND total_spent IS NOT NULL
  AND payment_method IS NOT NULL
  AND location IS NOT NULL
  AND transaction_date IS NOT NULL;
  
  
  
-- STEP 4: DESCRIPTIVE ANALYSIS
--  to get item performance: total sales, quantity, price, and revenue
SELECT item,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(price_per_unit), 2) AS avg_price,
    ROUND(SUM(total_spent), 2) AS total_sales,
    ROUND(SUM(quantity * price_per_unit), 2) AS total_revenue
FROM clean_cafe_sales
GROUP BY item
ORDER BY total_revenue DESC;


--  Payment method distribution
SELECT payment_method,
    COUNT(*) AS total_transactions
FROM clean_cafe_sales
GROUP BY payment_method
ORDER BY total_transactions DESC;


-- Transactions by location
SELECT location,
    COUNT(*) AS total_transactions
FROM clean_cafe_sales
GROUP BY location
ORDER BY total_transactions DESC;


-- STEP 5: DATA QUALITY CHECK
SELECT COUNT(*) AS total_cleaned_records FROM clean_cafe_sales;


-- to preview the cleaned dataset
SELECT * FROM clean_cafe_sales LIMIT 20;


-- END