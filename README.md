# _**Global Tech Layoffs: SQL Data Cleaning & Exploratory Data Analysis (EDA)**_

This project presents a complete end-to-end SQL analysis on global tech layoff trends. It tackles raw, messy data by cleaning it in MySQL and then diving into exploratory analysis to extract real-world insights about headcount reductions across industries, countries, and timeline trends.

_**Executive Summary**_
Between 2020 and 2026, the global tech industry underwent significant restructuring, resulting in over **920,000+ laid-off employees** across thousands of companies worldwide. This project focuses on cleaning raw, unstructured global layoff data using **MySQL** and conducting **Exploratory Data Analysis (EDA)** to uncover macroeconomic trends, high-risk sectors, and organizational vulnerability patterns.

The objective of this analysis is to provide actionable data-driven insights for HR strategy, venture capital risk assessment, and organizational restructuring.


_**Business Problem Statement**_

Rapid expansion and over-hiring during the 2020–2021 pandemic boom, followed by rising interest rates and economic uncertainty, forced tech enterprises and startups to downsize. Key business questions addressed in this analysis:
1. Which business sectors and funding stages carry the highest workforce vulnerability?
2. How do layoff dynamics differ between mature enterprises (Post-IPO) and early-stage startups?
3. What geographic regions represent the primary epicenters of tech downsizing?
4. What macro-level trends can guide future headcount planning and venture investment risk models?


_**Data Architecture & SQL Methodology**_

**1. Data Cleaning Pipeline (LAYOFFS DATA CLEANSING PROJECT.sql)**
- **Duplicate Removal:** Utilized ROW_NUMBER() over composite partitions (COMPANY, LOCATION, STAGE, DATE, PERCENTAGE) to safely eliminate redundant records.
- **Data Standardization:** Trimmed whitespace, standardized non-standard location strings (e.g., updating international locations to Non-U.S.), and aligned country mapping via self-joins and CTEs.
- **Null & Blank Value Handling:** Imputed missing industry classifications by matching historical company records and converted empty strings to NULL.
- **Type Casting & Schema Optimization:** Formatted string date values into standardized DATE data types (YYYY-MM-DD) and created indexes (idx_staging_comp) to accelerate query runtime.

**2. Exploratory Data Analysis (EXPLORATORY LAYOFFS DATA.sql)**
- **Aggregation & Trend Analysis:** Computed total and rolling volume metrics per month, year, industry, and funding stage.
- **Advanced Ranking Window Functions:** Deployed DENSE_RANK() OVER (PARTITION BY YEAR ORDER BY TOTAL_LAID_OFF DESC) to dynamically isolate the Top 5 most impacted companies per calendar year.

 _**Tools & SQL Concepts Used**_

* **Database Management System:** MySQL / MySQL Workbench
* **Key SQL Techniques:**
  * **Window Functions:** ROW_NUMBER(), DENSE_RANK(), SUM() OVER()
  * **CTE (Common Table Expressions):** For structured multi-step queries and ranking
  * **Data Manipulation & DDL:** CREATE TABLE, INSERT INTO, ALTER TABLE, UPDATE, DELETE
  * **String & Date Functions:** TRIM(), SUBSTRING_INDEX(), STR_TO_DATE(), YEAR()
  * **Aggregations & Joins:** GROUP BY, ORDER BY, Self-Joins
 
    
_**Key Business Insights**_

1. **Enterprise Scale vs. Startup Closure:**
   - **Post-IPO Enterprises** accounted for over **62% (~584,000+)** of total laid-off personnel worldwide. Large-cap corporations (Amazon, Intel, Meta, Microsoft, Dell) executed large-scale workforce reductions to correct post-pandemic over-hiring and optimize operational margins.
   - **Early-Stage Startups (Series A–C):** While absolute layoff numbers were smaller, startups exhibited a higher frequency of **100% workforce downsizing (complete shutdown)** due to liquidity shortages and dried-up venture capital funding.

2. **Sector-Specific Vulnerability:**
   - **Retail, Hardware, Consumer, and Finance** emerged as the hardest-hit industries. Consumer-facing digital products experienced sharp drops in active demand post-lockdown, forcing aggressive cost containment.

3. **Geographic Concentration:**
   - **United States** represented the majority of global layoffs (**>70% / 650,000+ headcount**), followed by key international tech hubs in **India, Germany, the UK, and the Netherlands**.

4. **Temporal Peak & Recovery Trajectory:**
   - Layoffs peaked sharply between **2022 and 2023** (reaching ~265,000 in 2023 alone). From 2024 onwards, layoff volumes plateaued as companies transitioned from aggressive cost-cutting to sustainable headcount alignment.


_**Business Recommendations**_

**For Organizational Leadership & HR (Headcount Planning)**
* **Adopt Dynamic Capacity Forecasting:** Avoid aggressive over-hiring during temporary demand surges. Implement flexible contracting models to absorb demand spikes without incurring severances or structural restructuring costs later.
* **Redeployment over Severance:** Establish internal talent mobility programs. Re-skilling existing talent into high-growth areas (such as AI, Cloud, and Data Security) reduces recruitment overhead and severance liabilities.

**For Venture Capital & Investors (Risk Management)**
* **Burn Rate & Runway Auditing:** Evaluate early-stage portfolio companies on runway length rather than pure revenue growth. Startups with elevated burn rates in retail/consumer tech carry high shutdown risk during macroeconomic downturns.
* **Milestone-Gated Capital Release:** Structure funding rounds with performance-based capital tranches to ensure capital conservation prior to market stabilization.


_**Repository Structure**_

```text
├── layoffs.csv                          # Raw Dataset
├── LAYOFFS DATA CLEANSING PROJECT.sql   # Full SQL Script for ETL & Cleaning
├── EXPLORATORY LAYOFFS DATA.sql         # SQL Queries for EDA & Trend Analysis
└── README.md                            # Project Documentation
```
