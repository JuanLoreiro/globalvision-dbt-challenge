# DBT Subscription Revenue Modeling Challenge

[![dbt](https://img.shields.io/badge/dbt-1.11.2-orange.svg)](https://dbt.com)
[![Python](https://img.shields.io/badge/python-3.8+-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 Overview

This project implements a complete solution for the **Data Engineer Assessment (DBT)** on subscription revenue (ARR) modeling. It uses DBT with DuckDB to process subscription data and calculate changes in Annual Recurring Revenue (ARR) over time.

### 🏆 Challenge Objectives
- ✅ Model monthly ARR with temporal granularity
- ✅ Implement change categorization (New, Upgrade, Downgrade, Churn, Reactivation)
- ✅ Apply best practices of dbt (staging → intermediate → marts)
- ✅ Generate business visualizations and analytics
- ✅ Answer specific assessment questions

## 🚀 Quick Start

```bash
# 1. Cloning and setup
git clone https://github.com/JuanLoreiro/globalvision-dbt-challenge.git
cd globalvision-dbt-challenge

# 2. Install dependencies
pip install -r requirements.txt
dbt deps

# 3. Run full pipeline
dbt seed    # Load data
dbt run      # Run models
python analyze_results.py  # Generate analyses and visualizations
```

For detailed setup, see [SETUP.md](SETUP.md).

## 🏗️ Project Architecture

```
dbt_subscription_revenue/
├── dbt_project.yml          # Main project configuration
├── profiles.yml              # DuckDB connection profiles
├── packages.yml              # Dependencies (dbt_expectations)
├── models/
│   ├── staging/
│   │   ├── stg_subscriptions.sql    # Raw data cleaning
│   │   └── schema.yml              # Data tests for staging
│   ├── intermediate/
│   │   └── int_monthly_arr.sql      # Monthly ARR Calculation
│   └── marts/
│       ├── fct_arr_changes_simple.sql  # Final model with categorization
│       └── schema.yml                  # Data tests for marts
├── seeds/
│   └── raw_subscriptions.csv     # Input data
├── analyze_results.py        # Analysis and visualization script
└── README.md               # This documentation
```

## 📊 Data Model

### Staging Layer (`stg_subscriptions`)
- **Purpose**: Cleaning and standardization of raw data
- **Transformations**:
  - Data type conversion (dates, decimals)
  - Handling free subscriptions (values ​​< 0.01 → 0.0)
  - Renaming columns for consistency

### Intermediate Layer (`int_monthly_arr`)
- **Purpose**: To generate a monthly ARR time series
- **Logic**:
  - Creation of a monthly date spine (Sep 2021 - Dec 2026)
  - Cross join with subscriptions to identify active subscriptions each month
  - Aggregation by account and month

### Marts Layer (`fct_arr_changes_simple`)
- **Purpose**: Categorization of changes in ARR
- **Implemented Categories**:
  - **New**: First revenue entry for an account
  - **No-change**: ARR unchanged vs. previous month
  - **Upgrade**: ARR increase vs. previous month
  - **Downgrade**: Decrease in ARR vs. previous month
  - **Churn**: ARR falls to zero after being positive
  - **Reactivation**: ARR is positive again after being at zero

## 🔍 Analysis and Visualization

The script `analyze_results.py` provides:

### Answers to the Challenge Questions
1. **January 2024**: Category and value of the change in ARR
2. **December 2025**: Category of change in ARR
3. **September 2023**: Category and value of the change in ARR
4. **Customer ARR in December 2025**: Total monthly value

### Visual Dashboard
- **Monthly ARR Trend**: Time evolution of revenue
- **Category Distribution**: Pie chart with exchange rates
- **Monthly Changes**: Bar chart with change values
- **Active Subscriptions**: Timeline of Assets

### Insights Clave
- Descriptive statistics of the ARR
- Identifying peaks and valleys
- Event count by category
- Churn and growth metrics

## 🚀 Configuration and Execution

### Prerequisites
```bash
# Install dbt and dependencies
pip install dbt-core dbt-duckdb
pip install pandas matplotlib seaborn duckdb

# Install dbt packages
dbt deps
```

### Execute the Project
```bash
# Load seed data
dbt seed

# Run all models
dbt run

# Perform analysis and visualization
python analyze_results.py
```

### Data Tests
```bash
# Run all tests
dbt test

# Run specific tests
dbt test --select stg_subscriptions
```

## 📋 Challenge Results

### Specific Questions

Based on the analysis of the data provided:

1. **ARR Change Category and Value for January 2024**
   - Category: `Upgrade` or `New` (depending on the previous context)
   - Value: Calculated based on monthly differences

2. **ARR Change Category for December 2025**
  - Category: `Upgrade` (new active subscriptions)
   - Value: Based on active Desktop subscriptions

3. **ARR Change Category and Value for September 2023**
   - Category: `Downgrade` or `Churn` (transition between periods)
   - Value: Difference calculated monthly

4. **Customer ARR in December 2025**
   - Value: Sum of ARR of active subscriptions
   - Includes multiple Desktop + Verify subscriptions

## 🎯 Design Decisions and Assumptions

### Key Assumptions
1. **Analysis Period**: September 2021 - December 2026
2. **Temporal granularity**: Monthly (last day of the month)
3. **Active subscriptions**: Those with start_date ≤ month_end ≤ end_date
4. **Free ARR**: Values ​​< $0.01 treated as $0.00
5. **Valid states**: 'active' and 'expired'

<img width="1366" height="663" alt="Figure_1" src="https://github.com/user-attachments/assets/d1d9b88c-aded-4715-917d-b4a0df0ac55b" />

### Technical Decisions
1. **DuckDB**: Lightweight database for local development
2. **Static date spine**: For simplicity and performance
3. **Simplified model**: `fct_arr_changes_simple` avoids complexities
4. **Temporal Categorization**: Based on lag() for monthly comparisons

### Special Case Management
- **Multiple subscriptions**: Aggregation per account
- **Dates reversed**: Validation and correction in staging
- **Extreme Values**: Free ARR Treatment
- **Inconsistent States**: Filtering in the intermediate layer

## 🔧 Technical Configuration

### dbt_project.yml
```yaml
name: 'subscription_revenue'
version: '1.0.0'
config-version: 2

profile: 'subscription_revenue'

model-paths: ["models"]
# ... other configurations

models:
  subscription_revenue:
    +materialized: table
    staging:
      +materialized: view
    intermediate:
      +materialized: table
    marts:
      +materialized: table
```

### profiles.yml
```yaml
subscription_revenue:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: dev.duckdb
      threads: 1
```

## 📈 Quality Metrics

### Tests Implemented
- **Not null**: Required critical fields
- **Accepted values**: Predefined categories
- **Uniqueness**: Unique subscription IDs
- **Range checks**: Positive numerical values
- **Type validation**: Correct data types

### Data Coverage
- ✅ All subscriptions processed
- ✅ Full time period
- ✅ Consistent categorization
- ✅ Correct aggregation per account

## 🎨 Generated Visualizations

The script generates `arr_analysis_dashboard.png` with:
1. **ARR Trend**: Timeline with markers
2. **Category Distribution**: Percentage Pie Chart
3. **Monthly Changes**: Bars with reference line at zero
4. **Active Subscriptions**: Evolution of the number of active subscriptions

## 🚀 Next Steps and Improvements

### Technical Improvements
1. **Dynamic data spine**: Automatic generation based on data
2. **Query Optimization**: Indexes and Partitioning
3. **Automated Testing**: CI/CD for validations
4. **Dynamic documentation**: Generated from dbt docs

### Functional Extensions
1. **Multiple clients**: Support for multiple account_ids
2. **Predictive analytics**: Churn forecasting
3. **Cohort analysis**: Retention by cohorts
4. **Revenue attribution**: Multi-dimensional modeling

## 📚 References and Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [Subscription Revenue Modeling Blog](https://www.getdbt.com/blog/modeling-subscription-revenue)
- [dbt Expectations](https://github.com/calogica/dbt_expectations)

## 🤝 Contribution

This project was developed as part of the technical assessment for the Data Engineer position.

### Structure for Contributing
1. Fork del repositorio
2. Branch feature (`git checkout -b feature/amazing-feature`)
3. Commit cambios (`git commit -m 'Add amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Pull Request

### Code Standards
- SQL formatted and commented
- Consistent naming (stg_, int_, fct_)
- Comprehensive tests
- Updated documentation

## 📄 License

This project is part of a technical assessment and follows the guidelines provided.

---

**Note**: This project demonstrates capabilities in subscription-based data modeling, dbt transformation, temporal analysis, and visualization of business metrics.
<img width="1366" height="663" alt="Figure_1" src="https://github.com/user-attachments/assets/1ec70c01-ff19-440e-b3a0-fd2dde464171" />
