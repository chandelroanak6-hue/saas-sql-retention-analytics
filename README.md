# SaaS Metrics & Cohort Retention Analytics Engine

An end-to-end SQL analytics project built in **PostgreSQL** modeling subscription lifecycle events, recurring revenue (MRR) changes, customer health scoring, and cohort retention.

---

## 📌 Business Overview
Understanding churn and subscriber lifetime value is critical for subscription-based business models. This project establishes a normalized relational database (3NF) to track customer events, subscriptions, and product usage to answer key business questions:
- What percentage of new cohorts remain active month-over-month?
- How much revenue is driven by new signups vs. lost to churn and downgrades?
- Which high-value customer accounts are exhibiting churn risk behavior?

---

## 🗄️ Database Architecture
The database schema consists of four relational tables:
- **`users`**: Demographics and acquisition attribution.
- **`plans`**: Subscription pricing tiers and product features.
- **`subscriptions`**: Active, canceled, and paused account lifecycles.
- **`user_activity`**: High-frequency feature interaction logs.

---

## 🔍 Key SQL Techniques Demonstrated
- **Common Table Expressions (CTEs)**: Structuring multi-stage transformations for complex cohort and revenue aggregation.
- **Window Functions**:
  - `LAG()`: Calculating MoM subscription tier movements (Expansion vs. Contraction MRR).
  - `NTILE()`: Generating 4-quartile RFM distributions for behavioral segmentation.
- **Date & Interval Arithmetic**: Normalizing event timestamps with `DATE_TRUNC()` and computing dynamic cohort retention intervals.
- **Defensive Schema Design**: Primary/Foreign keys, `ON DELETE CASCADE` integrity constraints, and domain checks.

---

## 📊 Analytical Insights

### 1. Monthly Cohort Retention Matrix
Measures user retention from the initial signup month through subsequent monthly intervals to determine drop-off trends.

### 2. Net MRR Waterfall
Breaks down revenue changes between consecutive months into:
- **New MRR**: First-time paying subscriptions.
- **Expansion MRR**: Account upgrades.
- **Contraction MRR**: Account downgrades.
- **Net MRR**: Total recurring revenue.

### 3. RFM Churn Risk Scoring
Segments customers based on **Recency** (last active date), **Frequency** (total product interactions), and **Monetary Value** (lifetime spend) to flag at-risk accounts.

---

## 🚀 How to Run
1. Create a PostgreSQL instance (e.g., via Neon.tech).
2. Execute `01_schema.sql` to initialize the database structure.
3. Execute `02_seed_data.sql` to populate initial mock data.
4. Run queries from `03_analytical_queries.sql` to reproduce reports.
