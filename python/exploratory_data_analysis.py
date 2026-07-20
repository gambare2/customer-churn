import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

processed_path = r"d:\data_analysis_project\customer-churn-analysis\data\processed\telco_customer_churn_cleaned.csv"
output_dir = r"d:\data_analysis_project\customer-churn-analysis\powerbi\screenshots"

def run_eda():
    print("Executing python/exploratory_data_analysis.py...")
    if not os.path.exists(processed_path):
        print(f"Error: Processed file not found at {processed_path}")
        return
        
    df = pd.read_csv(processed_path)
    os.makedirs(output_dir, exist_ok=True)
    
    # Set visual styles
    sns.set_theme(style="whitegrid")
    plt.rcParams["figure.figsize"] = (10, 6)
    
    # 1. Churn Distribution Pie Chart
    print("Generating Churn Distribution Pie Chart...")
    plt.figure(figsize=(6, 6))
    churn_counts = df['Churn'].value_counts()
    plt.pie(churn_counts, labels=churn_counts.index, autopct='%1.1f%%', colors=['#4C72B0', '#C44E52'], startangle=90)
    plt.title("Telco Customer Churn Distribution")
    plt.savefig(os.path.join(output_dir, "churn_distribution.png"), bbox_inches='tight')
    plt.close()
    
    # 2. Correlation Heatmap
    print("Generating Correlation Heatmap...")
    numeric_cols = ['tenure', 'MonthlyCharges', 'TotalCharges', 'ChurnNumeric', 
                    'PartnerNumeric', 'DependentsNumeric', 'TotalInternetServices', 'HasInternetService']
    corr_matrix = df[numeric_cols].corr()
    plt.figure(figsize=(10, 8))
    sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', fmt=".2f", linewidths=0.5)
    plt.title("Correlation Heatmap of Key Numerical Variables")
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, "correlation_heatmap.png"), bbox_inches='tight')
    plt.close()
    
    # 3. Churn by Contract Type (Bar Chart)
    print("Generating Churn by Contract Type Bar Chart...")
    plt.figure(figsize=(10, 6))
    contract_churn = df.groupby(['Contract', 'Churn']).size().unstack(fill_value=0)
    # Convert to percentages
    contract_churn_pct = contract_churn.div(contract_churn.sum(axis=1), axis=0) * 100
    contract_churn_pct.plot(kind='bar', stacked=True, color=['#4C72B0', '#C44E52'])
    plt.title("Churn Percentage by Contract Type")
    plt.ylabel("Percentage (%)")
    plt.xlabel("Contract Type")
    plt.xticks(rotation=0)
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, "contract_churn.png"), bbox_inches='tight')
    plt.close()
    
    # 4. Churn by Internet Service Type
    print("Generating Churn by Internet Service Type Bar Chart...")
    plt.figure(figsize=(10, 6))
    internet_churn = df.groupby(['InternetService', 'Churn']).size().unstack(fill_value=0)
    internet_churn_pct = internet_churn.div(internet_churn.sum(axis=1), axis=0) * 100
    internet_churn_pct.plot(kind='bar', stacked=True, color=['#4C72B0', '#C44E52'])
    plt.title("Churn Percentage by Internet Service Type")
    plt.ylabel("Percentage (%)")
    plt.xlabel("Internet Service")
    plt.xticks(rotation=0)
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, "internet_churn.png"), bbox_inches='tight')
    plt.close()
    
    # 5. Churn by Payment Method
    print("Generating Churn by Payment Method Bar Chart...")
    plt.figure(figsize=(12, 6))
    payment_churn = df.groupby(['PaymentMethod', 'Churn']).size().unstack(fill_value=0)
    payment_churn_pct = payment_churn.div(payment_churn.sum(axis=1), axis=0) * 100
    payment_churn_pct.plot(kind='barh', stacked=True, color=['#4C72B0', '#C44E52'])
    plt.title("Churn Percentage by Payment Method")
    plt.xlabel("Percentage (%)")
    plt.ylabel("Payment Method")
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, "payment_churn.png"), bbox_inches='tight')
    plt.close()
    
    # 6. Monthly Charges Distribution
    print("Generating Monthly Charges Distribution...")
    plt.figure(figsize=(10, 6))
    sns.kdeplot(data=df, x="MonthlyCharges", hue="Churn", fill=True, common_norm=False, palette=['#4C72B0', '#C44E52'], alpha=0.5)
    plt.title("Monthly Charges Density Distribution by Churn Status")
    plt.xlabel("Monthly Charges ($)")
    plt.savefig(os.path.join(output_dir, "charges_distribution.png"), bbox_inches='tight')
    plt.close()
    
    # 7. Tenure Distribution
    print("Generating Tenure Distribution Boxplot...")
    plt.figure(figsize=(10, 5))
    sns.boxplot(data=df, x="tenure", y="Churn", palette=['#4C72B0', '#C44E52'])
    plt.title("Tenure Months Distribution by Churn Status")
    plt.xlabel("Tenure (Months)")
    plt.ylabel("Churn Status")
    plt.savefig(os.path.join(output_dir, "tenure_distribution.png"), bbox_inches='tight')
    plt.close()
    
    print("EDA graphs generated and saved successfully!")

if __name__ == "__main__":
    run_eda()
