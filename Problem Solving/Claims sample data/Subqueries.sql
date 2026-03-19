-- Scalar Subquery
-- -- # Compare data to a single number #
WITH cte AS
	(SELECT claim_id,

			(SELECT AVG(claim_amount)
				FROM CLAIMS) AS avg_claims,
			claim_amount
		FROM claims
		GROUP BY claim_id,
			claim_amount)
SELECT *
FROM cte
WHERE claim_amount > avg_claims

-- Correlated subquery
-- # Claim ids that claimed above minimum than each provider id # 
SELECT claim_id,
	provider_id,
	claim_amount
FROM claims c
WHERE claim_amount >
		(SELECT MIN(claim_amount)
			FROM claims
			WHERE provider_id = c.provider_id)

