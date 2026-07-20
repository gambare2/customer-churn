import os
import pandas as pd
import numpy as np

# Define paths
raw_path = r"d:\data_analysis_project\customer-churn-analysis\data\raw\telco_customer_churn.csv"
processed_path = r"d:\data_analysis_project\customer-churn-analysis\data\processed\telco_customer_churn_cleaned.csv"

def clean_data():
    print("Executing python/data_cleaning.py...")
    if not os.path.exists(raw_path):
        print(f"Error: Raw file not found at {raw_path}")
        return
    
    # Load dataset
    df = pd.read_csv(raw_path)
    print(f"Loaded raw dataset shape: {df.shape}")
    
    # Check for duplicate rows
    duplicate_count = df.duplicated().sum()
    print(f"Found {duplicate_count} duplicate rows.")
    if duplicate_count > 0:
        df.drop_duplicates(inplace=True)
        print("Duplicates dropped.")
        
    # Check for missing values or spaces in TotalCharges
    # In Telco Churn, TotalCharges has blank spaces ' ' for new customers with tenure = 0
    blank_spaces = (df['TotalCharges'] == ' ') | (df['TotalCharges'] == '') | (df['TotalCharges'].isna())
    print(f"Found {blank_spaces.sum()} rows with blank or missing TotalCharges.")
    
    # Convert TotalCharges to numeric, coercing spaces to NaN
    df['TotalCharges'] = pd.to_numeric(df['TotalCharges'].replace(' ', np.nan), errors='coerce')
    
    # Since tenure is 0 for these rows, we fill missing TotalCharges with 0.0
    df['TotalCharges'] = df['TotalCharges'].fillna(0.0)
    print("Missing TotalCharges filled with 0.0.")
    
    # Standardize string fields (strip whitespaces)
    string_cols = df.select_dtypes(include=['object']).columns
    for col in string_cols:
        df[col] = df[col].astype(str).str.strip()
        
    # Standardize 'No internet service' and 'No phone service' categories if needed
    # Keep them clean as original but ensure no leading/trailing spaces
    
    # Verify types
    print("\nVerified Data Types:")
    print(df[['tenure', 'MonthlyCharges', 'TotalCharges']].dtypes)
    
    # Save cleaned file
    os.makedirs(os.path.dirname(processed_path), exist_ok=True)
    df.to_csv(processed_path, index=False, encoding="utf-8")
    print(f"Cleaned dataset saved successfully to {processed_path}!")

if __name__ == "__main__":
    clean_data()
