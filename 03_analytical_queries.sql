-- Query 1: Monthly Cohort Retention Matrix
WITH cohort_sizes AS (
    SELECT 
        DATE_TRUNC('month', signup_date)::DATE AS cohort_month,
        COUNT(user_id) AS total_users
    FROM users
    GROUP BY 1
),
user_activities AS (
    SELECT 
        DATE_TRUNC('month', u.signup_date)::DATE AS cohort_month,
        (DATE_PART('year', a.activity_date) - DATE_PART('year', u.signup_date)) * 12 +
        (DATE_PART('month', a.activity_date) - DATE_PART('month', u.signup_date)) AS month_number,
        COUNT(DISTINCT a.user_id) AS active_users
    FROM users u
    JOIN user_activity a ON u.user_id = a.user_id
    GROUP BY 1, 2
)
SELECT 
    c.cohort_month,
    c.total_users,
    a.month_number,
    a.active_users,
    ROUND((a.active_users::NUMERIC / c.total_users) * 100, 2) AS retention_rate_pct
FROM cohort_sizes c
JOIN user_activities a ON c.cohort_month = a.cohort_month
ORDER BY c.cohort_month, a.month_number;

-- Query 2: Net MRR Waterfall
WITH monthly_user_mrr AS (
    SELECT 
        DATE_TRUNC('month', s.start_date)::DATE AS mrr_month,
        s.user_id,
        SUM(p.monthly_price) AS mrr
    FROM subscriptions s
    JOIN plans p ON s.plan_id = p.plan_id
    WHERE s.status IN ('active', 'canceled')
    GROUP BY 1, 2
),
mrr_with_lag AS (
    SELECT 
        mrr_month,
        user_id,
        mrr,
        LAG(mrr) OVER (PARTITION BY user_id ORDER BY mrr_month) AS prev_mrr
    FROM monthly_user_mrr
)
SELECT 
    mrr_month,
    SUM(CASE WHEN prev_mrr IS NULL THEN mrr ELSE 0 END) AS new_mrr,
    SUM(CASE WHEN mrr > prev_mrr AND prev_mrr IS NOT NULL THEN (mrr - prev_mrr) ELSE 0 END) AS expansion_mrr,
    SUM(CASE WHEN mrr < prev_mrr THEN (prev_mrr - mrr) ELSE 0 END) AS contraction_mrr,
    SUM(mrr) AS total_mrr
FROM mrr_with_lag
GROUP BY mrr_month
ORDER BY mrr_month;

-- Query 3: RFM Customer Health & Churn Risk
WITH rfm_raw AS (
    SELECT 
        u.user_id,
        MAX(a.activity_date) AS last_active_date,
        COUNT(a.activity_id) AS total_actions,
        COALESCE(SUM(p.monthly_price), 0) AS lifetime_value
    FROM users u
    LEFT JOIN user_activity a ON u.user_id = a.user_id
    LEFT JOIN subscriptions s ON u.user_id = s.user_id
    LEFT JOIN plans p ON s.plan_id = p.plan_id
    GROUP BY u.user_id
),
rfm_scores AS (
    SELECT 
        user_id,
        NTILE(4) OVER (ORDER BY last_active_date ASC) AS recency_score,
        NTILE(4) OVER (ORDER BY total_actions ASC) AS frequency_score,
        NTILE(4) OVER (ORDER BY lifetime_value ASC) AS monetary_score
    FROM rfm_raw
)
SELECT 
    user_id,
    recency_score,
    frequency_score,
    monetary_score,
    CASE 
        WHEN recency_score = 1 AND frequency_score <= 2 THEN 'Critical Churn Risk'
        WHEN recency_score = 4 AND frequency_score = 4 THEN 'Power User'
        WHEN monetary_score = 4 AND recency_score <= 2 THEN 'At-Risk Enterprise'
        ELSE 'Regular'
    END AS segment_label
FROM rfm_scores;
