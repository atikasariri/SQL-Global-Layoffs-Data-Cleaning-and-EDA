# _**Global Tech Layoffs: SQL Data Cleaning & Exploratory Data Analysis (EDA)**_

This project presents a complete end-to-end SQL analysis on global tech layoff trends. It tackles raw, messy data by cleaning it in MySQL and then diving into exploratory analysis to extract real-world insights about headcount reductions across industries, countries, and timeline trends.

 **Repository Description (For GitHub About Section)**

 *End-to-end MySQL project performing data cleaning and exploratory data analysis (EDA) on global tech layoffs using CTEs, Window Functions, and aggregations.*


 _**What This Project Does**_
 
Working with real-world data often means dealing with duplicates, inconsistent formatting, missing values, and messy dates. This repository is split into two major parts:

1. **Data Cleaning (01_data_cleaning.sql)**: Preparing a raw dataset by staging, removing duplicate entries, standardizing country/city naming inconsistencies, converting string values to date types, and removing unneeded missing records.
2. **Exploratory Data Analysis (02_exploratory_analysis.sql)**: Querying the clean dataset to uncover which companies laid off the most employees, high-impact industries, month-over-month rolling totals, and yearly company rankings.


 _**Tools & SQL Concepts Used**_

* **Database Management System:** MySQL / MySQL Workbench
* **Key SQL Techniques:**
  * **Window Functions:** ROW_NUMBER(), DENSE_RANK(), SUM() OVER()
  * **CTE (Common Table Expressions):** For structured multi-step queries and ranking
  * **Data Manipulation & DDL:** CREATE TABLE, INSERT INTO, ALTER TABLE, UPDATE, DELETE
  * **String & Date Functions:** TRIM(), SUBSTRING_INDEX(), STR_TO_DATE(), YEAR()
  * **Aggregations & Joins:** GROUP BY, ORDER BY, Self-Joins


 _**Repository Structure**_

```text
├── data/
│   ├── raw_layoffs.csv         # Original raw dataset
│   └── layoffs_cleaned.csv     # Cleaned dataset exported after SQL transformation
├── scripts/
│   ├── 01_data_cleaning.sql    # Complete SQL script for data prep & cleaning
│   └── 02_eda_layoffs.sql      # SQL script for business insights and exploratory analysis
└── README.md                   # Project documentation
```

 _**Step-by-Step Data Cleaning Process**_

Here is how the raw dataset was transformed into clean, production-ready data:

**1. Staging & Preserving Raw Data**

Created a staging table "layoffs_staging" (and later "layoffs_staging2") to ensure operations never modify the original raw data directly.

**2. Identifying and Removing Duplicates**

Used CTEs combined with ROW_NUMBER() partitioned across all key attributes (company, location, industry, total_laid_off, percentage, date, stage, country, funds_raised) to isolate and remove duplicate rows cleanly.

**3. Data Standardization**

* **Whitespace & Formatting:** Trimmed leading/trailing spaces from company and location names.
* **Location Inconsistencies:** Standardized city names (e.g., updating location variations to clean formats like 'Auckland, Non-U.S.', 'Tel Aviv, Non-U.S.', etc.).
* **Country Normalization:** Fixed mismatched country labels by cross-referencing locations with dominant country entries.
* **Date Conversion:** Transformed date values stored as text into actual DATE data types (YYYY-MM-DD) using STR_TO_DATE().

**4. Handling Missing/Null Values**

* Converted empty strings ('') into NULL across numeric and text fields.
* Populated missing industry records by joining companies with their known industry entries elsewhere in the dataset.
* Deleted rows where both total_laid_off and percentage were completely missing, as they provided no analytical value.

**5. Cleaning Up Temporary Artifacts**

Dropped auxiliary columns like row_num used during duplicate removal to leave a streamlined table ready for querying.

 _**Key Insights from EDA**_

Some of the main questions answered through SQL queries include:

* **Largest Single Layoff Events:** Identified companies with the highest total headcount cuts as well as those that shut down entirely (percentage_laid_off = 1).
* **Industry & Geographic Impact:** Consumer, Retail, and Transportation sectors experienced some of the highest cumulative layoffs globally, with the US representing the largest volume.
* **Rolling Monthly Totals:** Used SUM(total_laid_off) OVER(ORDER BY month) to chart the compounding momentum of tech layoffs month by month.
* **Top 5 Companies Per Year:** Leveraged DENSE_RANK() partitioned by year to find the top 5 companies responsible for the highest number of layoffs each calendar year.


 _**How to Run**_

1. **Setup Database:** Create a new MySQL schema and import data/raw_layoffs.csv into a table named "layoffs".
2. **Execute Data Cleaning:** Run "scripts/01_data_cleaning.sql" in MySQL Workbench to produce the "layoffs_staging2" clean table.
3. **Execute EDA Queries:** Run "scripts/02_eda_layoffs.sql" to generate insights and view summary reports.


 _**Author**_

Project created as part of a Data Analytics portfolio to demonstrate end-to-end SQL data wrangling and exploratory analysis skills.
