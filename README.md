# 🚲 Cyclistic Bike-Share: From 5.5M Raw Records to Actionable Insights
### **Google Data Analytics Capstone Project**

---

## 📖 Project Overview
This project follows the **Google Data Analytics Professional Certificate** methodology to analyze over **5.5 million records** of historical trip data. The goal is to uncover behavioral differences between annual members and casual riders to design a data-driven marketing strategy for membership conversion.

---

## 🛠 Strategic Tech Stack: Why These Tools?
To handle a dataset of this magnitude, I built a hybrid analytical pipeline. Each tool was selected for its specific strengths:

* **MS SQL Server (T-SQL):**
    * **Scalability:** Seamlessly managing 5.5M+ rows where Excel reaches its limits.
    * **Data Integrity:** Strict enforcement of schemas through a Medallion Architecture (Bronze/Silver/Gold).
    * **Refactoring Power:** Rebuilding tables and cleaning data "on the fly" using complex T-SQL migration scripts.
* **Python (Pandas & Seaborn):**
    * **Advanced Statistics:** Performing Exploratory Data Analysis (EDA) and calculating metrics like medians and correlations.
    * **Visual Storytelling:** Creating high-fidelity statistical plots to identify patterns in trip duration.
* **Power BI:**
    * **Interactive Analytics:** Transforming static data into a dynamic environment for stakeholders.
    * **AI Integration:** Utilizing built-in Machine Learning capabilities like **Key Influencers** and **Decomposition Trees** for automated insight discovery.

---

## 🔄 The Data Process (Google Methodology)

### 1️⃣ Ask
* **Business Task:** Analyze user behavior to convert casual riders into annual members.
* **Key Stakeholders:** Lily Moreno (Director of Marketing) and the Cyclistic Executive Team.

### 2️⃣ Prepare (The Bronze Layer)
In this stage, I focused on data sourcing and initial organization:
* **Data Source:** 12 monthly CSV files (Jan 2025 - Dec 2025) provided by Motivate International Inc.
* **Methodology:** Implemented the **Bronze Layer** (Raw Data) in SQL.
* **Execution:** Used `BULK INSERT` to consolidate all files into a single "Source of Truth" while maintaining the original raw format for auditing.
  
> #### 💡 Why Consolidate into a Single Table?
> Instead of analyzing 12 separate files, I merged them into one unified dataset to:
> * **Enable Time-Series Analysis:** Comparing usage patterns across different months and seasons.
> * **Ensure Statistical Significance:** Analyzing the full 5.5M+ records at once provides more accurate averages and trends.
> * **Simplify Querying:** Performing complex joins and aggregations without the need for repetitive `UNION` operations.

### 3️⃣ Process (Refactoring & Silver Layer)
This was the most intensive phase, where I applied a **Medallion Architecture** to move data from "Raw" to "Clean":

* **Schema Refactoring:** I didn't just move data; I rebuilt the table. I dropped the initial structure and recreated the **Silver Layer** with optimized types (`DATETIME2`, `FLOAT`) to ensure precision.
* **The "Invisible" Data Battle:** I encountered corrupted records due to double quotes `""` and trailing spaces in the CSVs. I solved this by writing a migration script using `REPLACE`, `LTRIM`, and `RTRIM`.
* **Geographic Integrity:** I audited GPS coordinates to ensure they were logically bound within Chicago, filtering out "Zero" signals and invalid coordinates.

> #### 🧹 The 8-Step Cleaning Audit:
> 1. **Standardizing IDs:** Trimmed and cleaned `ride_id`.
> 2. **Precision Timing:** Calculated `ride_length_min` with second-level accuracy.
> 3. **Temporal Extraction:** Isolated `day_of_week` for usage patterns.
> 4. **Ghost Trip Filtration:** Removed trips < 1 min or > 24 hours.
> 5. **Null Management:** Handled missing station names to maintain density.
> 6. **Consistency:** Unified bike types and user categories.
> 7. **Scope Enforcement:** Strictly filtered for the **2025 calendar year**.
> 8. **Geographic Validation:** Verified Lat/Lng accuracy.

### 4️⃣ Analyze (The Gold Layer) 
In this final SQL stage, I transitioned from cleaning to **Aggregation**. I developed the **Gold Layer**, consisting of curated SQL Views designed for high-performance reporting in Python and Power BI.

* **Statistical Robustness:** Instead of relying solely on Averages, I calculated the **Median** ride length using `PERCENTILE_CONT` to mitigate the influence of outliers.
* **Spatial Optimization:** Performed a station popularity audit, specifically filtering out **"Remote"** and **"Test"** station artifacts to ensure marketing insights are based on real-world customer hotspots.
* **Complex Aggregations:** Leveraged `CTE`s and `Window Functions` to calculate percentage shares and distribution metrics directly in the database.

> #### 📊 Key Gold Views Created:
> 1. **`v_User_Proportions`**: Market share breakdown (Member vs. Casual).
> 2. **`v_Trip_Duration_Metrics`**: Comprehensive duration analysis (Mean, Median, Max, Min).
> 3. **`v_Monthly_Trends`**: Seasonal usage patterns across the year.
> 4. **`v_Weekly_Trends`**: Day-of-week usage comparison.
> 5. **`v_Hourly_Trends`**: Hourly distribution and peak usage (Rush Hour).
> 6. **`v_Top_Stations_Summary`**: The "Top 10" actionable locations for targeted advertisements.
> 7. **`v_Bike_Preferences`**: Usage breakdown by equipment type (Classic vs. Electric).

### 5️⃣ Share (The Dashboard & AI Phase)
The analysis culminated in an interactive **Executive Dashboard** with a **Dark-Mode Neon UI**:
* **User Segment Flow (Sankey):** Visualizing how volume vs. duration differs between segments.
* **AI-Driven Key Influencers:** Used ML to identify that **Ride Hour** and **Duration** are the top predictors for membership.
* **Decomposition Tree:** An AI-powered "Deep-Dive" visual allowing stakeholders to unfold data patterns from total rides down to specific hours.

### 6️⃣ Act (Strategic Recommendations)
1.  **The "Commuter Bridge" Campaign:** Target casual riders exhibiting "Member-like" behavior (rush hour usage) with trial offers.
2.  **Hotspot Marketing:** Leverage the **Top 10 Stations** data for hyper-local digital advertisements.
3.  **Weekend Peak Optimization:** Introduce weekend-only passes to capture high-duration casual leisure riders.

---

## 🚀 Tech Stack
* **Database:** MS SQL Server (T-SQL)
* **Analysis:** Python (Pandas, Matplotlib, Seaborn)
* **Visualization:** Power BI
* **Architecture:** Medallion (Bronze/Silver/Gold)
* **Methodology:** Google Data Analytics 6-Step Process

---

## 📂 Repository Structure
```text
├── 📂 SQL-Scripts/
│   ├── 01_Bronze_Layer_ETL.sql        # Data ingestion & consolidation
│   ├── 02_Silver_Layer.sql             # Cleaning, refactoring & audit
│   └── 03_Gold_Layer_Views.sql         # Business-ready aggregated views
├── 📂 Python-Analysis/
│   └── 04_Exploratory_Analysis.ipynb    # Deep dive & advanced visualization
├── 📂 PowerBI-Dashboard/
│   └── 05_Cyclistic_Dashboard.pbix     # Interactive dashboard & final story
├── 📂 Documentation/
│   └── Case_Study_Report.pdf           # Final business recommendations
├── 📄 .gitignore
└── 📄 README.md
