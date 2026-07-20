-- ==========================================================
-- 07_business_queries.sql
-- Author: Senior Data Analyst
-- Purpose: Business Insight and Customer Value Queries (Q25 - Q32)
-- ==========================================================

USE TelcoChurnDB;
GO

-- Q25: Monthly Revenue Lost Due to Churn by Contract Type
WITH RevenueLost AS (
    SELECT 
        Contract,
        SUM(MonthlyCharges) AS monthly_revenue_lost,
        COUNT(customerID) AS churned_customer_count
    FROM stg_customer_churn
    WHERE Churn = 'Yes'
    GROUP BY Contract
)
SELECT 
    r.Contract,
    r.churned_customer_count,
    r.monthly_revenue_lost,
    ROUND(r.monthly_revenue_lost * 100.0 / (SELECT SUM(MonthlyCharges) FROM stg_customer_churn), 2) AS pct_of_total_billing_lost
FROM RevenueLost r
ORDER BY monthly_revenue_lost DESC;

-- Q26: Churn Rate comparison: Fiber Optic vs DSL
SELECT 
    InternetService,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_count,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
WHERE InternetService IN ('Fiber optic', 'DSL')
GROUP BY InternetService;

-- Q27: Impact of Multiple Services on Churn
-- Comparing churn rate by count of active optional internet services
SELECT 
    TotalInternetServices,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_count,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY TotalInternetServices
ORDER BY TotalInternetServices;

-- Q28: Automatic vs Manual Payments on Churn
SELECT 
    CASE 
        WHEN PaymentMethod LIKE '%automatic%' THEN 'Automatic (Credit Card/Bank Transfer)'
        ELSE 'Manual (Electronic/Mailed Check)'
    END AS billing_type,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY 
    CASE 
        WHEN PaymentMethod LIKE '%automatic%' THEN 'Automatic (Credit Card/Bank Transfer)'
        ELSE 'Manual (Electronic/Mailed Check)'
    END;

-- Q29: Cumulative Percentage of Total Revenue Contributed by Tenure groups (Pareto analysis helper)
WITH TenureRevenue AS (
    SELECT 
        TenureGroup,
        SUM(TotalCharges) AS group_revenue
    FROM stg_customer_churn
    GROUP BY TenureGroup
),
CumulativeRevenue AS (
    SELECT 
        TenureGroup,
        group_revenue,
        SUM(group_revenue) OVER (ORDER BY group_revenue DESC) AS cum_revenue,
        SUM(group_revenue) OVER () AS total_revenue
    FROM TenureRevenue
)
SELECT 
    TenureGroup,
    group_revenue,
    ROUND(group_revenue * 100.0 / total_revenue, 2) AS revenue_share_pct,
    ROUND(cum_revenue * 100.0 / total_revenue, 2) AS cumulative_share_pct
FROM CumulativeRevenue
ORDER BY group_revenue DESC;

-- Q30: Early Churn Cohort (Tenure <= 6 Months) Churn Rate
SELECT 
    CASE 
        WHEN tenure <= 6 THEN 'New Customers (0-6m)'
        ELSE 'Established Customers (>6m)'
    END AS cohort,
    COUNT(customerID) AS customer_count,
    SUM(ChurnNumeric) AS churned_customers,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
GROUP BY 
    CASE 
        WHEN tenure <= 6 THEN 'New Customers (0-6m)'
        ELSE 'Established Customers (>6m)'
    END;

-- Q31: Tech Support impact on Churn Rate (for Internet Customers)
SELECT 
    TechSupport,
    COUNT(customerID) AS total_customers,
    SUM(ChurnNumeric) AS churned_count,
    ROUND(SUM(ChurnNumeric) * 100.0 / COUNT(customerID), 2) AS churn_rate_percent
FROM stg_customer_churn
WHERE InternetService != 'No'
GROUP BY TechSupport;

-- Q32: Estimated Customer Lifetime Value (CLV) based on contract status
-- CLV = Average Monthly Charges * Average Tenure for Retained Customers
SELECT 
    Contract,
    AVG(MonthlyCharges) AS avg_monthly_bill,
    AVG(tenure) AS avg_tenure_months,
    AVG(MonthlyCharges) * AVG(tenure) AS estimated_clv
FROM stg_customer_churn
WHERE Churn = 'No'
GROUP BY Contract
ORDER BY estimated_clv DESC;
