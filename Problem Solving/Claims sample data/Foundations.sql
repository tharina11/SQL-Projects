-- Total claims per member
SELECT member_id,
	COUNT(claim_id)
FROM claims
GROUP BY member_id;

-- Members with no claims
SELECT m.member_id,
claim_id
FROM members m
LEFT JOIN claims c
ON m.member_id = c.member_id
WHERE claim_id IS NULL;

-- Total approved amount per provider
SELECT provider_id,
SUM(claim_amount)
FROM claims
WHERE status = 'approved'
GROUP BY provider_id;

-- Count distinct members per state
SELECT state,
COUNT(DISTINCT member_id) AS distinct_members
FROM members
GROUP BY state;
