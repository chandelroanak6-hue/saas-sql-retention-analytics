-- 1. Plans
INSERT INTO plans (plan_id, plan_name, monthly_price, tier_level) VALUES
(1, 'Starter', 29.00, 1),
(2, 'Pro', 79.00, 2),
(3, 'Enterprise', 199.00, 3);

-- 2. Users
INSERT INTO users (user_id, email, signup_date, acquisition_channel) VALUES
(1, 'john@example.com', '2024-01-05', 'Organic Search'),
(2, 'sarah@example.com', '2024-01-12', 'Paid Ads'),
(3, 'mike@example.com', '2024-01-20', 'Referral'),
(4, 'emily@example.com', '2024-02-02', 'Organic Search'),
(5, 'alex@example.com', '2024-02-15', 'Email Campaign'),
(6, 'lisa@example.com', '2024-03-01', 'Paid Ads');

-- 3. Subscriptions
INSERT INTO subscriptions (user_id, plan_id, start_date, end_date, status) VALUES
(1, 1, '2024-01-05', NULL, 'active'),
(2, 2, '2024-01-12', '2024-03-01', 'canceled'),
(3, 1, '2024-01-20', NULL, 'active'),
(4, 2, '2024-02-02', NULL, 'active'),
(5, 3, '2024-02-15', '2024-02-28', 'canceled'),
(6, 1, '2024-03-01', NULL, 'active');

-- 4. Activity Logs
INSERT INTO user_activity (user_id, activity_date, feature_used) VALUES
(1, '2024-01-10', 'Export Data'),
(1, '2024-02-14', 'Create Report'),
(1, '2024-03-05', 'Export Data'),
(2, '2024-01-15', 'Create Report'),
(3, '2024-01-25', 'Dashboard View'),
(3, '2024-02-10', 'Export Data'),
(4, '2024-02-05', 'Invite Team'),
(4, '2024-03-12', 'Create Report'),
(6, '2024-03-02', 'Dashboard View');
