-- ==========================================================
-- 05_intermediate_analysis.sql
-- Author: Senior Data Analyst
-- Purpose: Intermediate Segment Analysis Queries (Q9 - Q16)
-- ==========================================================

USE TelcoChurnDB;
GO

-- Q9: Churn rate by Contract Type
SELECT 
    Contract,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY Contract
ORDER BY churn_rate_percent DESC;

-- Q10: Churn rate by Internet Service Type
SELECT 
    InternetService,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;

-- Q11: Average Monthly Charges by Payment Method
SELECT 
    PaymentMethod,
    AVG(MonthlyCharges) AS avg_monthly_charges,
    COUNT(customerID) AS customer_count
FROM stg_customer_churn
GROUP BY PaymentMethod
ORDER BY avg_monthly_charges DESC;

-- Q12: Churn by Senior Citizen using CASE statements
SELECT 
    CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior Citizens'
        ELSE 'Younger/Adult Customers'
    END AS age_segment,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY 
    CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior Citizens'
        ELSE 'Younger/Adult Customers'
    END;

-- Q13: Phone Service and Multiple Lines combination analysis
SELECT 
    PhoneService,
    MultipleLines,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY PhoneService, MultipleLines
ORDER BY churn_rate_percent DESC;

-- Q14: Monthly Charges Categorization and Churn Rate (CASE Statement)
SELECT 
    CASE 
        WHEN MonthlyCharges <= 30 THEN 'Low Charges (<= $30)'
        WHEN MonthlyCharges > 30 AND MonthlyCharges <= 80 THEN 'Medium Charges ($30 - $80)'
        ELSE 'High Charges (> $80)'
    END AS charges_bracket,
    COUNT(customerID) AS customer_count,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY 
    CASE 
        WHEN MonthlyCharges <= 30 THEN 'Low Charges (<= $30)'
        WHEN MonthlyCharges > 30 AND MonthlyCharges <= 80 THEN 'Medium Charges ($30 - $80)'
        ELSE 'High Charges (> $80)'
    END
ORDER BY churn_rate_percent DESC;

-- Q15: Payment Methods with above-average overall churn rates (HAVING)
SELECT 
    PaymentMethod,
    COUNT(customerID) AS customer_count,
    SUM(ChurnNumeric) AS churned_count,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS payment_churn_rate
FROM stg_customer_churn
GROUP BY PaymentMethod
HAVING ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) > (
    SELECT ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) FROM stg_customer_churn
)
ORDER BY payment_churn_rate DESC;

-- Q16: Paperless Billing style comparison on Churn
SELECT 
    PaperlessBilling,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY PaperlessBilling;
