-- ==========================================================
-- 04_basic_analysis.sql
-- Author: Senior Data Analyst
-- Purpose: Basic KPI and Demographic Queries (Q1 - Q8)
-- ==========================================================

USE TelcoChurnDB;
GO

-- Q1: Total customer count and churn split
SELECT 
    Churn,
    COUNT(customerID) AS customer_count,
    ROUND(COUNT(customerID) * 100.0 / (SELECT COUNT(*) FROM stg_customer_churn), 2) AS percentage
FROM stg_customer_churn
GROUP BY Churn;

-- Q2: Overall Churn Rate percentage
SELECT 
    SUM(ChurnNumeric) AS total_churned,
    COUNT(customerID) AS total_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent,
    ROUND((COUNT(customerID) - SUM(ChurnNumeric)) * 100.0 / COUNT(customerID), 2) AS retention_rate_percent
FROM stg_customer_churn;

-- Q3: Gender distribution of Churned Customers
SELECT 
    gender,
    COUNT(customerID) AS churned_count,
    ROUND(COUNT(customerID) * 100.0 / (SELECT SUM(ChurnNumeric) FROM stg_customer_churn), 2) AS pct_of_total_churned
FROM stg_customer_churn
WHERE Churn = 'Yes'
GROUP BY gender;

-- Q4: Churn comparison by Senior Citizen label
SELECT 
    SeniorCitizenLabel,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY SeniorCitizenLabel;

-- Q5: Demographic Segmentation: Impact of Partner and Dependents on Churn
SELECT 
    Partner,
    Dependents,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY Partner, Dependents
ORDER BY churn_rate_percent DESC;

-- Q6: Tenure summaries for Churned vs Retained customers
SELECT 
    Churn,
    AVG(tenure) AS average_tenure_months,
    MIN(tenure) AS min_tenure_months,
    MAX(tenure) AS max_tenure_months
FROM stg_customer_churn
GROUP BY Churn;

-- Q7: Average Monthly Charges by Churn Status
SELECT 
    Churn,
    AVG(MonthlyCharges) AS avg_monthly_charges,
    MIN(MonthlyCharges) AS min_monthly_charges,
    MAX(MonthlyCharges) AS max_monthly_charges
FROM stg_customer_churn
GROUP BY Churn;

-- Q8: Total Charges generated vs lost due to Churn
SELECT 
    Churn,
    SUM(TotalCharges) AS total_revenue_generated,
    ROUND(SUM(TotalCharges) * 100.0 / (SELECT SUM(TotalCharges) FROM stg_customer_churn), 2) AS revenue_share_pct
FROM stg_customer_churn
GROUP BY Churn;
