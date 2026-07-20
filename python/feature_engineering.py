import os
import pandas as pd
import numpy as np

processed_path = r"d:\data_analysis_project\customer-churn-analysis\data\processed\telco_customer_churn_cleaned.csv"

def engineer_features():
    print("Executing python/feature_engineering.py...")
    if not os.path.exists(processed_path):
        print(f"Error: Processed file not found at {processed_path}")
        return
        
    df = pd.read_csv(processed_path)
    
    # 1. Map Churn to numeric (1, 0)
    df['ChurnNumeric'] = df['Churn'].apply(lambda x: 1 if x == 'Yes' else 0)
    
    # 2. Map other binary columns to numeric
    df['PartnerNumeric'] = df['Partner'].apply(lambda x: 1 if x == 'Yes' else 0)
    df['DependentsNumeric'] = df['Dependents'].apply(lambda x: 1 if x == 'Yes' else 0)
    df['PhoneServiceNumeric'] = df['PhoneService'].apply(lambda x: 1 if x == 'Yes' else 0)
    df['PaperlessBillingNumeric'] = df['PaperlessBilling'].apply(lambda x: 1 if x == 'Yes' else 0)
    
    # 3. Create Tenure Groupings
    def get_tenure_group(months):
        if months <= 12:
            return "0-12 Month"
        elif months <= 24:
            return "12-24 Month"
        elif months <= 48:
            return "24-48 Month"
        elif months <= 60:
            return "48-60 Month"
        else:
            return "60+ Month"
            
    df['TenureGroup'] = df['tenure'].apply(get_tenure_group)
    
    # 4. Senior Citizen Label
    df['SeniorCitizenLabel'] = df['SeniorCitizen'].apply(lambda x: 'Senior' if x == 1 else 'Non-Senior')
    
    # 5. Count of services used
    # List of optional internet/phone services
    service_cols = ['OnlineSecurity', 'OnlineBackup', 'DeviceProtection', 'TechSupport', 'StreamingTV', 'StreamingMovies']
    df['TotalInternetServices'] = df[service_cols].apply(lambda row: sum(1 for cell in row if str(cell).strip() == 'Yes'), axis=1)
    
    # 6. Has Internet Service flag
    df['HasInternetService'] = df['InternetService'].apply(lambda x: 1 if x != 'No' else 0)
    
    # Save back to processed file
    df.to_csv(processed_path, index=False, encoding="utf-8")
    print(f"Feature engineering completed! Shape: {df.shape}. Saved to {processed_path}")

if __name__ == "__main__":
    engineer_features()
