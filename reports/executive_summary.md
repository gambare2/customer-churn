# Executive Summary - Telco Customer Churn Analysis

## 1. Project Background
This analysis investigates customer retention patterns across **7,043 subscribers** of Telco. By combining Python metrics, SQL data warehouse modeling, and business visualization, we identify the key drivers of customer attrition and detail strategic options to reclaim revenue.

---

## 2. Key Metrics Dashboard
- **Total Revenue (Lifetime)**: `$16,056,168.00`
- **Active Subscriptions**: `5,174` (73.46% Retention Rate)
- **Lost Subscriptions (Churned)**: `1,869` (26.54% Churn Rate)
- **Average Monthly Bill**: `$64.76`
- **Monthly Revenue Leakage**: `$139,130.85` (Lost due to churned users)
- **High-Risk Segment size**: `1,297` users (Fiber Optic contract base)

---

## 3. Core Findings
- **Month-to-Month contracts** account for **88.5%** of all customer churn.
- **Fiber Optic broadband** is our most volatile product, showing a **41.9%** churn rate, suggesting potential network quality or pricing friction.
- **Electronic Check payments** display a **45.3%** churn rate, while customers on automated payment methods churn at just **15.8%**.
- **Onboarding Risk**: **52.3%** of all churn occurs within the first 6 months of customer tenure.

---

## 4. Strategic Recommendations
1. **Promote Automated Billing**: Offer a small billing credit (e.g. $2 per month) to migrate manual "Electronic Check" users to automated credit card/bank transfer billing.
2. **Onboarding Contact Campaigns**: Establish proactive support checks at month 1 and month 3 to help customers set up their services.
3. **Contract Migration Incentives**: Build a targeted promotion to offer month-to-month fiber optic customers a discounted transition to a 1-year contract.
4. **Bundle Optional Services**: Incentivize subscriptions to "Online Security" and "Tech Support" by bundling them as a package, as customers with these services exhibit 70% lower churn.
