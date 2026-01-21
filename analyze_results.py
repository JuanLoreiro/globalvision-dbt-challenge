import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

# Connect to the DuckDB database
conn = duckdb.connect('dev.duckdb')

# Query the ARR changes data
query = """
SELECT 
    month_end,
    account_id,
    monthly_arr,
    prev_month_arr,
    arr_change,
    arr_change_category,
    active_subscriptions,
    year,
    month
FROM main.fct_arr_changes_simple 
ORDER BY month_end, account_id
"""

df = pd.read_sql_query(query, conn)

# Answer the specific questions
print("=== ANSWERS TO SPECIFIC QUESTIONS ===\n")

# Question 1: What is the ARR change category and value for January 2024?
jan_2024 = df[(df['year'] == 2024) & (df['month'] == 1)]
if not jan_2024.empty:
    row = jan_2024.iloc[0]
    print(f"January 2024:")
    print(f"  - ARR Change Category: {row['arr_change_category']}")
    print(f"  - ARR Change Value: ${row['arr_change']:,.2f}")
    print(f"  - Monthly ARR: ${row['monthly_arr']:,.2f}")
print()

# Question 2: What is the ARR change category for December 2025?
dec_2025 = df[(df['year'] == 2025) & (df['month'] == 12)]
if not dec_2025.empty:
    row = dec_2025.iloc[0]
    print(f"December 2025:")
    print(f"  - ARR Change Category: {row['arr_change_category']}")
    print(f"  - Monthly ARR: ${row['monthly_arr']:,.2f}")
print()

# Question 3: What is the ARR change category and value for September 2023?
sep_2023 = df[(df['year'] == 2023) & (df['month'] == 9)]
if not sep_2023.empty:
    row = sep_2023.iloc[0]
    print(f"September 2023:")
    print(f"  - ARR Change Category: {row['arr_change_category']}")
    print(f"  - ARR Change Value: ${row['arr_change']:,.2f}")
    print(f"  - Monthly ARR: ${row['monthly_arr']:,.2f}")
print()

# Question 4: What is the customer's ARR in December 2025?
if not dec_2025.empty:
    row = dec_2025.iloc[0]
    print(f"Customer's ARR in December 2025: ${row['monthly_arr']:,.2f}")
print()

# Create visualization
plt.style.use('seaborn-v0_8')
fig, axes = plt.subplots(2, 2, figsize=(15, 12))
fig.suptitle('Subscription Revenue Analysis Dashboard', fontsize=16, fontweight='bold')

# 1. Monthly ARR Trend
df['date'] = pd.to_datetime(df['month_end'])
axes[0, 0].plot(df['date'], df['monthly_arr'], marker='o', linewidth=2, markersize=4)
axes[0, 0].set_title('Monthly ARR Trend', fontweight='bold')
axes[0, 0].set_xlabel('Date')
axes[0, 0].set_ylabel('ARR ($)')
axes[0, 0].grid(True, alpha=0.3)
axes[0, 0].tick_params(axis='x', rotation=45)

# 2. ARR Change Categories Distribution
category_counts = df['arr_change_category'].value_counts()
colors = ['#ff9999','#66b3ff','#99ff99','#ffcc99','#c2c2f0','#ffb3e6']
axes[0, 1].pie(category_counts.values, labels=category_counts.index, autopct='%1.1f%%', colors=colors)
axes[0, 1].set_title('ARR Change Categories Distribution', fontweight='bold')

# 3. Monthly ARR Changes (Bar Chart)
df_nonzero = df[df['arr_change'] != 0]
axes[1, 0].bar(df_nonzero['date'], df_nonzero['arr_change'], color='steelblue', alpha=0.7)
axes[1, 0].set_title('Monthly ARR Changes', fontweight='bold')
axes[1, 0].set_xlabel('Date')
axes[1, 0].set_ylabel('ARR Change ($)')
axes[1, 0].grid(True, alpha=0.3)
axes[1, 0].tick_params(axis='x', rotation=45)
axes[1, 0].axhline(y=0, color='red', linestyle='-', alpha=0.5)

# 4. Active Subscriptions Over Time
axes[1, 1].plot(df['date'], df['active_subscriptions'], marker='s', linewidth=2, markersize=4, color='green')
axes[1, 1].set_title('Active Subscriptions Over Time', fontweight='bold')
axes[1, 1].set_xlabel('Date')
axes[1, 1].set_ylabel('Number of Active Subscriptions')
axes[1, 1].grid(True, alpha=0.3)
axes[1, 1].tick_params(axis='x', rotation=45)

plt.tight_layout()
plt.savefig('arr_analysis_dashboard.png', dpi=300, bbox_inches='tight')
plt.show()

# Create a detailed timeline view
print("\n=== DETAILED TIMELINE VIEW ===")
timeline_df = df[['date', 'monthly_arr', 'arr_change_category', 'active_subscriptions']].copy()
timeline_df['ARR ($)'] = timeline_df['monthly_arr'].apply(lambda x: f"${x:,.2f}")
timeline_df['Change Category'] = timeline_df['arr_change_category']
timeline_df['Active Subs'] = timeline_df['active_subscriptions']

print(timeline_df[['date', 'ARR ($)', 'Change Category', 'Active Subs']].to_string(index=False))

# Key insights
print("\n=== KEY INSIGHTS ===")
print(f"• Total months analyzed: {len(df)}")
print(f"• Average monthly ARR: ${df['monthly_arr'].mean():,.2f}")
print(f"• Peak ARR: ${df['monthly_arr'].max():,.2f} (occurred in {df.loc[df['monthly_arr'].idxmax(), 'month_end']})")
print(f"• Lowest ARR: ${df['monthly_arr'].min():,.2f} (occurred in {df.loc[df['monthly_arr'].idxmin(), 'month_end']})")
print(f"• Total ARR changes: {len(df[df['arr_change'] != 0])}")
print(f"• Upgrades: {len(df[df['arr_change_category'] == 'Upgrade'])}")
print(f"• Downgrades: {len(df[df['arr_change_category'] == 'Downgrade'])}")
print(f"• New business: {len(df[df['arr_change_category'] == 'New'])}")
print(f"• Churn events: {len(df[df['arr_change_category'] == 'Churn'])}")

conn.close()
print("\nDashboard saved as 'arr_analysis_dashboard.png'")
