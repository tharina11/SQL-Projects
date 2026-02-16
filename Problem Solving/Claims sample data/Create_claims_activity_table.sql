DROP TABLE IF EXISTS claims_activity;

CREATE TABLE claims_activity (
    claim_id INT PRIMARY KEY,
    member_id INT,
    claim_date DATE,
    claim_amount NUMERIC(10,2),
    status VARCHAR(20) -- approved, denied, pending
);

INSERT INTO claims_activity VALUES
(1, 1, '2023-01-05', 500.00, 'approved'),
(2, 1, '2023-01-20', 700.00, 'approved'),
(3, 2, '2023-01-15', 300.00, 'denied'),

(4, 1, '2023-02-10', 400.00, 'approved'),
(5, 2, '2023-02-12', 600.00, 'approved'),
(6, 3, '2023-02-25', 900.00, 'pending'),

(7, 1, '2023-03-03', 1000.00, 'approved'),
(8, 2, '2023-03-18', 200.00, 'denied'),
(9, 3, '2023-03-22', 1200.00, 'approved'),

(10, 1, '2023-04-02', 800.00, 'approved'),
(11, 2, '2023-04-15', 500.00, 'approved'),
(12, 3, '2023-04-30', 400.00, 'approved'),

(13, 1, '2023-05-10', 600.00, 'approved'),
(14, 2, '2023-05-21', 700.00, 'approved'),

(15, 1, '2023-06-05', 900.00, 'approved'),
(16, 3, '2023-06-18', 1100.00, 'denied');
