/*1. Basic Time Aggregation */
-- Return total claim amount per month
SELECT 
	DATE_TRUNC('month', claim_date) AS claim_month,
	SUM(claim_amount)
FROM public.claims_activity
GROUP BY claim_month;

-- Return number of claims per month
SELECT 
	DATE_TRUNC('month', claim_date) AS claim_month,
	COUNT(claim_id) AS monthly_claims_count
FROM public.claims_activity
GROUP BY claim_month;

-- Return daily totals only for March 2023.
SELECT 
	claim_date,
	SUM(claim_amount)
FROM public.claims_activity
WHERE DATE_TRUNC('month', claim_date) = '2023-03-01'
GROUP BY claim_date;

/*2. Growth & Comparison */
-- Calculate total claim amount per month and the difference from previous month.
WITH CTE1 AS
(
SELECT 
	DATE_TRUNC('month', claim_date) AS claim_month,
	SUM(claim_amount) AS monthly_claim_amount
FROM public.claims_activity
GROUP BY claim_month
)
SELECT
	claim_month, 
	monthly_claim_amount,
	monthly_claim_amount - LAG(monthly_claim_amount) OVER (ORDER BY claim_month) AS diff_from_previous
FROM CTE1
;

-- Add percentage Growth Month-over-Month
WITH CTE1 AS(
	SELECT 
		DATE_TRUNC('month', claim_date) AS claim_month,
		SUM(claim_amount) AS monthly_claim_amount
	FROM public.claims_activity
	GROUP BY claim_month
)
SELECT
	claim_month, 
	monthly_claim_amount,
	ROUND((monthly_claim_amount - LAG(monthly_claim_amount) OVER (ORDER BY claim_month))*100
 	/LAG(monthly_claim_amount) OVER (ORDER BY claim_month), 2) AS growth_MoM
FROM CTE1
;

-- Compare Approved vs Denied Trend Monthly
SELECT
	DATE_TRUNC('month', claim_date) AS claim_month,
	SUM(claim_amount) AS monthly_claim_amount,
	status
FROM public.claims_activity
GROUP BY claim_month, status
ORDER BY claim_month;

  -- Pivoted version
SELECT
    DATE_TRUNC('month', claim_date) AS month,
    SUM(CASE WHEN status = 'approved' THEN claim_amount ELSE 0 END) AS approved_total,
    SUM(CASE WHEN status = 'denied' THEN claim_amount ELSE 0 END) AS denied_total,
    SUM(CASE WHEN status = 'pending' THEN claim_amount ELSE 0 END) AS pending_total
FROM claims_activity
GROUP BY DATE_TRUNC('month', claim_date)
ORDER BY month;

-- One step further
WITH monthly_totals AS (
    SELECT
        DATE_TRUNC('month', claim_date) AS month,
        status,
        SUM(claim_amount) AS total_amount
    FROM claims_activity
    GROUP BY DATE_TRUNC('month', claim_date), status
)

SELECT
    month,
    status,
    total_amount,
    ROUND(
        total_amount * 100.0 /
        SUM(total_amount) OVER (PARTITION BY month),
        2
    ) AS pct_of_month
FROM monthly_totals
ORDER BY month, status;


--/*3. Running Totals and Cumulative Metrics */
-- Calculate cumulative claim amount over months.
WITH CTE AS
(
SELECT 
	DATE_TRUNC('month', claim_date) AS claim_month,
	SUM(claim_amount) AS month_sum
FROM public.claims_activity
GROUP BY DATE_TRUNC('month', claim_date)
ORDER BY claim_month
)
SELECT 
	claim_month,
	month_sum,
SUM(month_sum) OVER(ORDER BY claim_month) AS cumulative_monthly_sum
FROM CTE;

-- Same question. CTE as Subquery
SELECT 
	claim_month,
	month_sum,
SUM(month_sum) OVER(ORDER BY claim_month) AS cumulative_monthly_sum
FROM (
	SELECT 
		DATE_TRUNC('month', claim_date) AS claim_month,
		SUM(claim_amount) AS month_sum
	FROM public.claims_activity
	GROUP BY DATE_TRUNC('month', claim_date)
	ORDER BY claim_month
	) AS t1;
---

-- Cumulative claim amount per member ordered by claim_date.
SELECT 
member_id,
claim_id,
claim_date,
claim_amount,
SUM(claim_amount) OVER(PARTITION BY member_id ORDER BY claim_date) AS cumulative_member_sum
FROM public.claims_activity
ORDER BY member_id, claim_date
