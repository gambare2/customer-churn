# Data Dictionary - Customer Churn Analysis

This data dictionary documents the schemas and columns of the **Telco Customer Churn** raw and processed datasets.

---

## 1. Cleaned and Engineered Dataset Schema
**File Path**: `data/processed/telco_customer_churn_cleaned.csv`

| Column Name | Data Type | Description | Values / Examples |
| :--- | :--- | :--- | :--- |
| **customerID** | String | Unique alpha-numeric identifier for each customer | `7590-VHVEG`, `5575-GN926` |
| **gender** | String | Customer's self-identified gender | `Male`, `Female` |
| **SeniorCitizen** | Integer | Binary indicator of senior citizen age bracket | `1` (Senior), `0` (Non-Senior) |
| **Partner** | String | Indicator of whether the customer has a partner | `Yes`, `No` |
| **Dependents** | String | Indicator of whether the customer has dependents | `Yes`, `No` |
| **tenure** | Integer | Number of months the customer has been with the company | `1` to `72` |
| **PhoneService** | String | Indicator of subscription to telephone service | `Yes`, `No` |
| **MultipleLines** | String | Subscription status for multiple telephone lines | `Yes`, `No`, `No phone service` |
| **InternetService** | String | Customer's internet service provider type | `DSL`, `Fiber optic`, `No` |
| **OnlineSecurity** | String | Subscription to online security add-on | `Yes`, `No`, `No internet service` |
| **OnlineBackup** | String | Subscription to online backup add-on | `Yes`, `No`, `No internet service` |
| **DeviceProtection** | String | Subscription to device protection plan add-on | `Yes`, `No`, `No internet service` |
| **TechSupport** | String | Subscription to dedicated technical support add-on | `Yes`, `No`, `No internet service` |
| **StreamingTV** | String | Subscription to streaming television option | `Yes`, `No`, `No internet service` |
| **StreamingMovies** | String | Subscription to streaming movies option | `Yes`, `No`, `No internet service` |
| **Contract** | String | Customer's current billing contract duration term | `Month-to-month`, `One year`, `Two year` |
| **PaperlessBilling** | String | Indicator of paperless billing preferences | `Yes`, `No` |
| **PaymentMethod** | String | Current payment method configuration | `Electronic check`, `Mailed check`, `Bank transfer (automatic)`, `Credit card (automatic)` |
| **MonthlyCharges** | Float | The amount billed to the customer monthly | Numerical (e.g. `29.85`, `56.95`) |
| **TotalCharges** | Float | Cumulative charges billed over the lifetime | Numerical (e.g. `1889.50`, `0.0`) |
| **Churn** | String | Target indicator of customer churn | `Yes` (Churned), `No` (Retained) |
| **ChurnNumeric** | Integer | Numerical representation of the churn target column | `1` (Yes), `0` (No) |
| **PartnerNumeric** | Integer | Binary mapping of the Partner column | `1` (Yes), `0` (No) |
| **DependentsNumeric** | Integer | Binary mapping of the Dependents column | `1` (Yes), `0` (No) |
| **PhoneServiceNumeric** | Integer | Binary mapping of the PhoneService column | `1` (Yes), `0` (No) |
| **PaperlessBillingNumeric**| Integer | Binary mapping of the PaperlessBilling column | `1` (Yes), `0` (No) |
| **TenureGroup** | String | Binned classification of customer tenure duration | `0-12 Month`, `12-24 Month`, `24-48 Month`, `48-60 Month`, `60+ Month` |
| **SeniorCitizenLabel** | String | Readable text label for senior citizen column | `Senior`, `Non-Senior` |
| **TotalInternetServices** | Integer | The count of optional internet services subscribed (out of 6) | `0` to `6` |
| **HasInternetService** | Integer | Flag indicating internet service usage | `1` (Yes), `0` (No) |
