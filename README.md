# 👟 End-to-End Global Footwear Sales Data Pipeline & Analytics (MySQL)

## Overview

This repository presents an end-to-end SQL data pipeline built using MySQL, designed to transform raw global footwear sales data into a clean, validated, and analysis-ready dataset.

The project demonstrates how transactional sales data from multiple countries, brands, and sales channels can be systematically processed to generate meaningful business insights.

The pipeline follows a structured layered architecture:

```
Raw Layer → Clean Layer → Analytical Layer → Optimization Layer
```

The main objectives of this project are:
1. ingesting raw CSV data into a structured database,
2. cleaning and standardizing inconsistent fields,
3. validating business-critical metrics (pricing, revenue, units sold),
4. transforming data into an analytics-ready format,
5. and generating actionable insights using advanced SQL techniques.
All processes are implemented entirely using SQL in MySQL.

---

## Architecture Overview

```
CSV File
   │
   ▼
footwear_sales_raw          (Raw ingestion layer)
   │
   ▼
footwear_sales_clean        (Clean / analytical base table)
   │
   ▼
Analytical Queries          (Business insights)
   │
   ▼
Views & Indexing            (Performance & automation layer)
```

This architecture ensures:
1. preservation of raw source data,
2. controlled and traceable transformations,
3. consistent and reliable analytical outputs.

---

## Data Source

The dataset is sourced from:
```
Data_sports_footwear.csv
```

It contains transactional-level data, including:
* order details
* product attributes (brand, category, size, color)
* pricing and discounts
* sales channels
* geographic distribution
* customer segmentation data
Data ingestion simulates a real-world batch loading process using LOAD DATA INFILE.

---

## Raw Layer – Data Ingestion

Table:

```
portofolio.footwear_sales_raw
```

The raw table stores the dataset in its original form without transformation.
### Characteristics:
* order date stored as text
* no enforced formatting
* minimal constraints applied
* preserves original data integrity

---

## Clean Layer – Data Transformation & Standardization

Table:

```
portofolio.footwear_sales_clean
```

This table represents the curated analytical dataset.

### Transformations Applied:

Data Type Standardization
* order_date converted into DATE format using:

```sql
STR_TO_DATE(order_date, '%Y-%m-%d')
```

Derived Columns
* order_year and order_month extracted for time-based analysis

Text Cleaning
* all string fields are trimmed to remove unnecessary whitespace

Revenue Recalculation
* revenue is recalculated using:

```sql
final_price_usd * units_sold
```

to ensure consistency and eliminate source errors

Data Integrity
* order_id enforced as PRIMARY KEY
* duplicate checks performed prior to constraint application

---

## Data Validation & Audit

Data quality checks are implemented to ensure analytical reliability.

### Validation Rules:
* revenue must equal final_price × units_sold
* final price must not exceed base price
* no NULL values in critical fields (order_id, order_date, revenue)
* customer rating must be within 0–5 range
* units sold must be greater than zero

Invalid records are identified through audit queries for transparency.

---

## Analytical Use Cases

All analyses are performed on the clean dataset.

---

## 💰 Revenue Analysis
* total revenue across all transactions

### Insight:
Provides a baseline for overall business performance.

---

## 📅 Revenue Trend Analysis
revenue aggregated by year

### Insight:
Identifies growth trends and potential market shifts over time.

---

## 🌍 Geographic Analysis
* revenue distribution by country
* top-performing country per year

### Insight:
Highlights key markets and regional dominance patterns.

---

## 👟 Brand Performance
top brand per year (using window functions)
overall top-performing brands

### Insight:
Evaluates brand competitiveness and market leadership.

---

## 🛒 Customer Behavior
Average Order Value (AOV)

### Insight:
Measures customer spending behavior and transaction value.

---

## 📦 Sales Channel Analysis
revenue by sales channel

### Insight:
Identifies preferred purchasing channels (online vs offline).

---

## 🏷️ Pricing Strategy (Discount Impact)
relationship between discount levels, volume, and revenue

### Insight:
Evaluates effectiveness of discount strategies on profitability.

---

## 👥 Customer Segmentation
revenue contribution by income level

### Insight:
Supports targeted marketing and pricing strategies.

---

## 📊 Product Performance
revenue by product category

### Insight:
Identifies high-demand product segments.

---

## 📈 Growth Analysis
Year-over-Year (YoY) revenue growth using window functions

### Insight:
Measures business expansion and detects performance fluctuations.

---

## Optimization Layer

### Indexing Strategy
Indexes are created to improve query performance:
* order_year
* brand

These indexes optimize aggregation and filtering operations.

---

## Data Automation

View:

```sql
sales_summary
```

### Provides:
* yearly aggregated revenue
This enables reusable and simplified reporting queries.

---

## Key Engineering Highlights
This project demonstrates:
1. layered data architecture (raw → clean → analytics)
2. robust data cleaning and transformation techniques
3. use of window functions (RANK, LAG)
4. defensive SQL practices (NULLIF, validation queries)
5. performance optimization using indexing
6. analytical thinking with business-driven insights

---

## Assumptions & Scope
* each row represents a single transaction
* dataset may contain inconsistencies from source systems
* project focuses on analytical processing (not OLTP design)
* batch processing approach is used

---

## Technology Stack
* MySQL 8.x
* SQL (DDL, DML, Data Cleaning, Data Analysis)

---

## Repository Structure

```
.
├── DATA/
│   └── data_sports_footwear.csv
├── SQL/
│   └── footwear_sales_pipeline.sql
└── README.md
```

---

## How to Run This Project
1. Create database and raw table
2. Load CSV into:

```
footwear_sales_raw
```

3. Create clean table
4. Run audit queries
5. Execute analytical queries
(Optional) Create indexes and views

### Ensure:
* file path is allowed by secure_file_priv
* MySQL has permission to access the file

---

## Intended Usage

### This repository is designed for:
1. showcasing SQL data analytics skills
2. demonstrating real-world data cleaning pipelines
3. building analytical datasets from raw transactional data
4. practicing business-oriented data analysis

---

## 👤 Author

### Y Baskara
LinkedIn : https://www.linkedin.com/in/yugobaskara/
Data Analyst | SQL | Data Engineering Enthusiast

---

## 📄 Data Source & Attribution

Dataset sourced from a public dataset by Ali Hussain.

This project is developed for educational and portfolio purposes.
All data transformations, validations, and analysis are implemented by the author.

---
