-- ==========================================================
-- 03_data_cleaning.sql
-- Author: Senior Data Analyst
-- Purpose: SQL Data Cleaning & Ingest Validation Queries
-- ==========================================================

USE TelcoChurnDB;
GO

-- 1. Identify missing values in TotalCharges
SELECT 
    customerID, 
    tenure, 
    MonthlyCharges, 
    TotalCharges
FROM stg_customer_churn
WHERE TotalCharges IS NULL;

-- 2. Identify blank space representations (if loaded as raw string before typecast)
-- (Ensures we catch records where customer has 0 tenure but blank charges)
SELECT 
    COUNT(customerID) AS blank_charges_count
FROM stg_customer_churn
WHERE tenure = 0 AND (TotalCharges = 0 OR TotalCharges IS NULL);

-- 3. Check for Duplicate Customers
SELECT 
    customerID, 
    COUNT(*) AS record_count
FROM stg_customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

-- 4. Check for anomalies in Tenure values
SELECT 
    MIN(tenure) AS min_tenure, 
    MAX(tenure) AS max_tenure,
    AVG(tenure) AS avg_tenure
FROM stg_customer_churn;

-- 5. Standardize categories - Checking for irregular strings in key columns
SELECT DISTINCT InternetService FROM stg_customer_churn;
SELECT DISTINCT Contract FROM stg_customer_churn;
SELECT DISTINCT PaymentMethod FROM stg_customer_churn;
