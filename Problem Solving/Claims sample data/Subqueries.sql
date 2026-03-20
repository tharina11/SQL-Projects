-- -- Scalar Subquery
-- -- -- # Compare data to a single number #
-- WITH cte AS
-- 	(SELECT claim_id,

-- 			(SELECT AVG(claim_amount)
-- 				FROM CLAIMS) AS avg_claims,
-- 			claim_amount
-- 		FROM claims
-- 		GROUP BY claim_id,
-- 			claim_amount)
-- SELECT *
-- FROM cte
-- WHERE claim_amount > avg_claims

-- Correlated subquery
-- # Claim ids that claimed above minimum per provider id # 
SELECT claim_id,
	provider_id,
	claim_amount
FROM claims c
WHERE claim_amount >
		(SELECT MIN(claim_amount)
			FROM claims
			WHERE provider_id = c.provider_id)


-- Subquery with IN/EXISTS
-- # Claim ids that claimed above minimum per provider id # --
SELECT claim_id,
	provider_id,
	claim_amount
FROM claims c
WHERE claim_amount IN
		(SELECT MIN(claim_amount)
			FROM claims
			WHERE provider_id = c.provider_id)
	
	
-- # Return the members who got claim amounts more than 1000$ #

SELECT full_name
FROM members m
WHERE EXISTS
		(SELECT 1
			FROM claims c
			WHERE c.member_id = m.member_id
				AND claim_amount > 1000 )
				
