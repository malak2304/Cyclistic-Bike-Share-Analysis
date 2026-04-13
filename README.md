🚲 Cyclistic Bike-Share: From 5.5M Raw Records to Actionable Insights
Google Data Analytics Capstone Project
📖 Project Overview
This project follows the Google Data Analytics Professional Certificate methodology to analyze over 5.5 million records of historical trip data. The goal is to uncover behavioral differences between annual members and casual riders to design a data-driven marketing strategy for membership conversion.

🛠 Why MS SQL Server?
For a dataset of this magnitude (5.5M+ rows), Excel reaches its limits. I chose T-SQL because:

Scalability: Seamlessly managing millions of rows without performance lags.

Data Integrity: Strict enforcement of schemas and data types.

Refactoring Power: The ability to restructure and "clean on the fly" using complex migration scripts.

🔄 The Data Process (Google Methodology)
1️⃣ Ask
Business Task: Analyze user behavior to convert casual riders into annual members.

Key Stakeholders: Lily Moreno (Director of Marketing) and the Cyclistic Executive Team.

2️⃣ Prepare (The Bronze Layer)
In this stage, I focused on data sourcing and initial organization:

Data Source: 12 monthly CSV files (Jan 2025 - Dec 2025) provided by Motivate International Inc.

Methodology: Implemented the Bronze Layer (Raw Data) in SQL.

Execution: Used BULK INSERT to consolidate all files into a single "Source of Truth" while maintaining the original raw format for auditing.

3️⃣ Process (Refactoring & Silver Layer)
This was the most intensive phase, where I applied a Medallion Architecture to move data from "Raw" to "Clean":

Schema Refactoring: I didn't just move data; I rebuilt the table. I dropped the initial structure and recreated the Silver Layer with optimized types (DATETIME2, FLOAT) to ensure precision.

The "Invisible" Data Battle: I encountered corrupted records due to double quotes "" and trailing spaces in the CSVs. I solved this by writing a migration script using REPLACE, LTRIM, and RTRIM.

Geographic Integrity: I audited GPS coordinates to ensure they were logically bound within Chicago, filtering out "Zero" signals and invalid coordinates.

🧹 The 8-Step Cleaning Audit:
Standardizing IDs: Trimmed and cleaned ride_id.

Precision Timing: Calculated ride_length_min with second-level accuracy.

Temporal Extraction: Isolated day_of_week for usage patterns.

Ghost Trip Filtration: Removed trips < 1 min or > 24 hours.

Null Management: Handled missing station names to maintain density.

Consistency: Unified bike types and user categories.

Scope Enforcement: Strictly filtered for the 2025 calendar year.

Geographic Validation: Verified Lat/Lng accuracy.

4️⃣ Analyze [In Progress]
Status: Currently performing descriptive statistics in SQL.

Focus: Comparing mean ride lengths, identifying peak days, and station popularity per user group.

5️⃣ Share [Upcoming]
Tool: Tableau / Power BI.

Goal: Create interactive dashboards to visualize the "Why" behind the numbers.

6️⃣ Act [Upcoming]
Goal: Providing final data-backed recommendations for the marketing team.

🚀 Tech Stack
Database: MS SQL Server (T-SQL)

Architecture: Medallion (Bronze/Silver)

Methodology: Google Data Analytics 6-Step Process

📂 Repository Structure
├── 📂 SQL-Scripts/
│   ├── 01_Bronze_Layer_ETL.sql         # Raw data ingestion & loading
│   └── 02_Silver_Layer.sql              # Data cleaning, refactoring & audit
├── 📂 Documentation/
│   └── Case_Study_Report.pdf           # Project findings & methodology report
├── 📄 .gitignore                       # Files to be ignored by Git (CSV, etc.)
└── 📄 README.md                        # Project overview & documentation
