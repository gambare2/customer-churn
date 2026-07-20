# SQL Queries Documentation - Customer Churn Analysis

This document outlines the **32 business analysis queries** designed and developed for the customer churn database, showing the breakdown and categorization of SQL files.

---

## SQL Scripts Overview

### 1. Database Creation (`sql/01_create_database.sql`)
- Creates the schema database `TelcoChurnDB` and switches context to it.

### 2. Schema Definitions (`sql/02_create_tables.sql`)
- Defines the raw staging table `stg_customer_churn` to import CSV rows.
- Defines normalized dimension tables: `dim_customer`, `dim_services`, `dim_contract`.
- Defines the fact table: `fact_churn` which references dimensions and hosts key metrics.

### 3. Staging and Validation (`sql/03_data_cleaning.sql`)
- Contains 5 diagnostic queries to check for null values in `TotalCharges`, duplicate primary keys, identify tenure anomalies, and check categorical distributions.

### 4. Basic Analytical Queries (`sql/04_basic_analysis.sql`)
- **Q1: Count and Splits**: Overall retained vs churned customer counts.
- **Q2: Baseline Churn & Retention Rates**: Calculates standard percentage KPIs.
- **Q3: Gender Performance**: Explores churned customers grouped by gender.
- **Q4: Senior Citizen Split**: Churn rates across age groups.
- **Q5: Demographics Combo**: Intersects Partner and Dependent variables on churn rates.
- **Q6: Average Tenure**: Compares average months stayed for churned vs active customer cohorts.
- **Q7: Billing Charges**: Average monthly bills for churned vs active customer segments.
- **Q8: Revenue Distribution**: Summarizes total revenue generated vs lost due to churn.

### 5. Intermediate Segmentation Queries (`sql/05_intermediate_analysis.sql`)
- **Q9: Contract Churn**: Calculates customer volumes and churn rates by Contract type.
- **Q10: Internet Service Impact**: Breaks down churn rates across DSL, Fiber Optic, and No Internet customers.
- **Q11: Monthly charges by Payment Method**: Computes average charges by payment channel.
- **Q12: Age Classification**: CASE WHEN statement grouping seniors vs younger demographics.
- **Q13: Phone & Multi-line Matrix**: Grouping of PhoneService and MultipleLines subscriptions.
- **Q14: Monthly Charge Brackets**: CASE statement grouping customers into Low (<= $30), Medium ($30-$80), and High (> $80) billing groups.
- **Q15: High Churn Payments (HAVING)**: Groups by payment methods and identifies those with churn rates exceeding the overall average.
- **Q16: Billing Style comparison**: Evaluates the effect of PaperlessBilling vs traditional paper billing.

### 6. Advanced Analytics & Windowing (`sql/06_advanced_analysis.sql`)
- **Q17: Running Totals**: Uses `SUM() OVER(ORDER BY tenure)` to compute cumulative billing values for active customers.
- **Q18: Contract Ranking**: Employs `RANK() OVER(PARTITION BY Contract ORDER BY MonthlyCharges DESC)` to find high-paying accounts in each contract type.
- **Q19: Payment Tenure Sequences**: Employs `ROW_NUMBER() OVER(PARTITION BY PaymentMethod ORDER BY tenure DESC)` to sort transactions.
- **Q20: Category Averages**: Compares customer charges against the internet service category average using `AVG() OVER()`.
- **Q21: CTE Cohorts**: Employs a CTE to calculate churn sizes and average bills for tenure cohorts.
- **Q22: LEAD/LAG Comparison**: Uses `LAG()` to evaluate step-changes in monthly charges across sequential records.
- **Q23: Pricing Deciles**: Employs `NTILE(10)` to split the customer base into 10 equal charges brackets.
- **Q24: Risk Mitigation CTE**: Isolates high-paying month-to-month customers and summarizes them by internet service type.

### 7. Strategic Business Decisions (`sql/07_business_queries.sql`)
- **Q25: Revenue Loss analysis**: Employs a CTE to map the exact monthly billing losses due to churn across contract types.
- **Q26: Fiber vs DSL rates**: Compares churn metrics for broadband services using subqueries.
- **Q27: Multi-Service Churn**: Groups by optional services count to observe the relationship between bundle size and loyalty.
- **Q28: Automated vs Manual Payments**: Employs a CASE statement to compare automatic credit/bank payments vs manual check payments.
- **Q29: Cumulative Revenue Share**: Employs a window function and CTE to calculate the cumulative revenue contribution of tenure cohorts.
- **Q30: Early-term Churn Cohort**: Groups customers by tenure (<= 6m vs > 6m) to identify early retention drops.
- **Q31: Tech Support Value**: Identifies churn differences between customers subscribing to tech support.
- **Q32: Customer Lifetime Value (CLV)**: Estimates CLV by multiplying average monthly charges by average tenure across contract terms.
