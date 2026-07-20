-- ==========================================================
-- 06_advanced_analysis.sql
-- Author: Senior Data Analyst
-- Purpose: Advanced Windowing and CTE Queries (Q17 - Q24)
-- ==========================================================

USE TelcoChurnDB;
GO

-- Q17: Running Cumulative Sum of Monthly Charges for Active Customers
SELECT 
    customerID,
    tenure,
    MonthlyCharges,
    SUM(MonthlyCharges) OVER (ORDER BY tenure, customerID) AS running_monthly_charges
FROM stg_customer_churn
WHERE Churn = 'No';

-- Q18: Ranking Customers by Monthly Charges within each Contract Category (RANK)
SELECT 
    Contract,
    customerID,
    MonthlyCharges,
    RANK() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS charge_rank_in_contract
FROM stg_customer_churn;

-- Q19: Row numbering of customers by tenure length within payment methods (ROW_NUMBER)
SELECT 
    PaymentMethod,
    customerID,
    tenure,
    ROW_NUMBER() OVER (PARTITION BY PaymentMethod ORDER BY tenure DESC) AS tenure_sequence
FROM stg_customer_churn;

-- Q20: Finding difference between customer MonthlyCharges and Category Average
SELECT 
    customerID,
    InternetService,
    MonthlyCharges,
    AVG(MonthlyCharges) OVER (PARTITION BY InternetService) AS avg_category_charges,
    (MonthlyCharges - AVG(MonthlyCharges) OVER (PARTITION BY InternetService)) AS difference_from_avg
FROM stg_customer_churn;

-- Q21: CTE - Cohort Churn metrics by Tenure Groups
WITH TenureCohorts AS (
    SELECT 
        TenureGroup,
        COUNT(customerID) AS cohort_size,
        SUM(ChurnNumeric) AS churned_count,
        AVG(MonthlyCharges) AS avg_monthly_bill
    FROM stg_customer_churn
    GROUP BY TenureGroup
)
SELECT 
    TenureGroup,
    cohort_size,
    churned_count,
    ROUND(churned_count * 100.0 / cohort_size, 2) AS cohort_churn_rate_percent,
    ROUND(avg_monthly_bill, 2) AS avg_monthly_bill
FROM TenureCohorts
ORDER BY TenureGroup;

-- Q22: LEAD/LAG comparison of customer monthly charges
SELECT 
    customerID,
    tenure,
    MonthlyCharges AS current_charges,
    LAG(MonthlyCharges, 1) OVER (ORDER BY tenure) AS prior_customer_charges,
    (MonthlyCharges - LAG(MonthlyCharges, 1) OVER (ORDER BY tenure)) AS difference_from_prior
FROM stg_customer_churn;

-- Q23: NTILE classification - Dividing customers into 10 pricing deciles
SELECT 
    customerID,
    MonthlyCharges,
    NTILE(10) OVER (ORDER BY MonthlyCharges DESC) AS monthly_charges_decile
FROM stg_customer_churn;

-- Q24: CTE - Isolating high-risk segments on Month-to-month contracts
WITH HighRiskSegment AS (
    SELECT 
        customerID,
        gender,
        InternetService,
        MonthlyCharges,
        TotalCharges
    FROM stg_customer_churn
    WHERE Contract = 'Month-to-month' AND MonthlyCharges > 90.0 AND Churn = 'No'
)
SELECT 
    InternetService,
    COUNT(customerID) AS active_high_risk_customers,
    AVG(MonthlyCharges) AS avg_risk_charges
FROM HighRiskSegment
GROUP BY InternetService;
