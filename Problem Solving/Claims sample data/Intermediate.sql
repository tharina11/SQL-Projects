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

--