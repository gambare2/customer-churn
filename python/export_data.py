import os
import pandas as pd

processed_path = r"d:\data_analysis_project\customer-churn-analysis\data\processed\telco_customer_churn_cleaned.csv"
exports_dir = r"d:\data_analysis_project\customer-churn-analysis\data\exports"

def export_summaries():
    print("Executing python/export_data.py...")
    if not os.path.exists(processed_path):
        print(f"Error: Processed file not found at {processed_path}")
        return
        
    df = pd.read_csv(processed_path)
    os.makedirs(exports_dir, exist_ok=True)
    
    # 1. Churn Summary
    total_customers = len(df)
    churn_counts = df['Churn'].value_counts()
    churned_count = churn_counts.get('Yes', 0)
    retained_count = churn_counts.get('No', 0)
    churn_rate = churned_count / total_customers
    retention_rate = retained_count / total_customers
    avg_monthly_charges = df['MonthlyCharges'].mean()
    total_monthly_charges_lost = df[df['Churn'] == 'Yes']['MonthlyCharges'].sum()
    
    churn_summary_data = {
        'Metric': ['Total Customers', 'Active Customers', 'Churned Customers', 'Churn Rate', 'Retention Rate', 'Average Monthly Charges', 'Monthly Revenue Lost Due to Churn'],
        'Value': [total_customers, retained_count, churned_count, churn_rate, retention_rate, avg_monthly_charges, total_monthly_charges_lost]
    }
    churn_summary_df = pd.DataFrame(churn_summary_data)
    churn_summary_df.to_csv(os.path.join(exports_dir, 'churn_summary.csv'), index=False)
    print("Exported churn_summary.csv")
    
    # Helper to calculate rate by group
    def get_group_churn_summary(df, group_col):
        group_df = df.groupby(group_col).agg(
            Total_Customers=(group_col, 'count'),
            Churned_Customers=('ChurnNumeric', 'sum'),
            Average_Monthly_Charges=('MonthlyCharges', 'mean'),
            Total_Monthly_Charges=('MonthlyCharges', 'sum')
        ).reset_index()
        group_df['Churn_Rate'] = group_df['Churned_Customers'] / group_df['Total_Customers']
        return group_df
        
    # 2. Churn by Contract
    churn_contract_df = get_group_churn_summary(df, 'Contract')
    churn_contract_df.to_csv(os.path.join(exports_dir, 'churn_by_contract.csv'), index=False)
    print("Exported churn_by_contract.csv")
    
    # 3. Churn by Payment Method
    churn_payment_df = get_group_churn_summary(df, 'PaymentMethod')
    churn_payment_df.to_csv(os.path.join(exports_dir, 'churn_by_payment_method.csv'), index=False)
    print("Exported churn_by_payment_method.csv")
    
    # 4. Churn by Internet Service
    churn_internet_df = get_group_churn_summary(df, 'InternetService')
    churn_internet_df.to_csv(os.path.join(exports_dir, 'churn_by_internet_service.csv'), index=False)
    print("Exported churn_by_internet_service.csv")
    
    print("Data export pipeline finished successfully!")

if __name__ == "__main__":
    export_summaries()
