-- Members with total claim amount > 1000
SELECT member_id,
SUM(claim_amount) AS total_claim_amount
FROM claims
GROUP BY member_id
HAVING SUM(claim_amount) > 1000
;

-- Providers whose average claim > overall average
SELECT provider_id,
	AVG(claim_amount) AS average_provider_claim_amount
FROM claims
GROUP BY provider_id
HAVING AVG(claim_amount) > 
	(SELECT AVG(claim_amount) AS overall_avg
	 FROM claims)
;

-- Members with more than 1 visit
SELECT member_id,
	COUNT(visit_id) AS visit_count
FROM visits
GROUP By member_id
HAVING COUNT(visit_id) > 1;

-- Claims in last 36 months
SELECT claim_id,
claim_date
FROM claims
WHERE claim_date > (SELECT CURRENT_DATE - INTERVAL '33 months');

