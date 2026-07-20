-- ==========================================================
-- 02_create_tables.sql
-- Author: Senior Data Analyst
-- Purpose: Create Staging and Normalized Star Schema Tables
-- ==========================================================

USE TelcoChurnDB;
GO

-- ==========================================
-- 1. STAGING TABLE (Flat Table matching CSV)
-- ==========================================
IF OBJECT_ID('stg_customer_churn', 'U') IS NOT NULL
    DROP TABLE stg_customer_churn;

CREATE TABLE stg_customer_churn (
    customerID VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(100),
    MonthlyCharges DECIMAL(18, 2),
    TotalCharges DECIMAL(18, 2),
    Churn VARCHAR(10),
    ChurnNumeric INT,
    PartnerNumeric INT,
    DependentsNumeric INT,
    PhoneServiceNumeric INT,
    PaperlessBillingNumeric INT,
    TenureGroup VARCHAR(30),
    SeniorCitizenLabel VARCHAR(20),
    TotalInternetServices INT,
    HasInternetService INT
);

-- ==========================================
-- 2. DIMENSION TABLES (Star Schema)
-- ==========================================

-- Customer Demographics Dimension
IF OBJECT_ID('dim_customer', 'U') IS NOT NULL
    DROP TABLE dim_customer;

CREATE TABLE dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL UNIQUE,
    gender VARCHAR(20),
    senior_citizen BIT,
    partner BIT,
    dependents BIT
);

-- Services Dimension
IF OBJECT_ID('dim_services', 'U') IS NOT NULL
    DROP TABLE dim_services;

CREATE TABLE dim_services (
    service_key INT IDENTITY(1,1) PRIMARY KEY,
    phone_service BIT,
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30)
);

-- Billing & Contract Dimension
IF OBJECT_ID('dim_contract', 'U') IS NOT NULL
    DROP TABLE dim_contract;

CREATE TABLE dim_contract (
    contract_key INT IDENTITY(1,1) PRIMARY KEY,
    contract_type VARCHAR(30),
    paperless_billing BIT,
    payment_method VARCHAR(100)
);

-- ==========================================
-- 3. FACT TABLE
-- ==========================================
IF OBJECT_ID('fact_churn', 'U') IS NOT NULL
    DROP TABLE fact_churn;

CREATE TABLE fact_churn (
    fact_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT FOREIGN KEY REFERENCES dim_customer(customer_key),
    service_key INT FOREIGN KEY REFERENCES dim_services(service_key),
    contract_key INT FOREIGN KEY REFERENCES dim_contract(contract_key),
    tenure INT NOT NULL,
    monthly_charges DECIMAL(18, 2) NOT NULL,
    total_charges DECIMAL(18, 2) NOT NULL,
    churn_status BIT NOT NULL,
    estimated_ltv DECIMAL(18, 2)
);
