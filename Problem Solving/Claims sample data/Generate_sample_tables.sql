DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS members;

CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    state VARCHAR(50),
    join_date DATE
);

CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    member_id INT,
    provider_id INT,
    claim_date DATE,
    claim_amount NUMERIC(10,2),
    status VARCHAR(20),  -- approved, denied, pending
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);

CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    member_id INT,
    provider_id INT,
    visit_date DATE,
    diagnosis_code VARCHAR(10),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);


INSERT INTO members VALUES
(1, 'John Silva', 'M', 'MO', '2022-01-10'),
(2, 'Anita Perera', 'F', 'IL', '2022-03-15'),
(3, 'David Miller', 'M', 'MO', '2023-05-01'),
(4, 'Sara Lee', 'F', 'TX', '2021-11-20'),
(5, 'Kevin Brown', 'M', 'IL', '2023-01-05');

INSERT INTO providers VALUES
(101, 'Dr. Smith', 'Cardiology', 'MO'),
(102, 'Dr. Johnson', 'Dermatology', 'IL'),
(103, 'Dr. Patel', 'General Practice', 'TX'),
(104, 'Dr. Adams', 'Orthopedics', 'MO');

INSERT INTO claims VALUES
(1001, 1, 101, '2023-01-15', 1200.00, 'approved'),
(1002, 1, 104, '2023-02-20', 800.00, 'approved'),
(1003, 2, 102, '2023-03-05', 450.00, 'denied'),
(1004, 3, 101, '2023-03-18', 1500.00, 'approved'),
(1005, 3, 101, '2023-04-10', 700.00, 'pending'),
(1006, 4, 103, '2023-04-25', 300.00, 'approved'),
(1007, 4, 103, '2023-05-10', 400.00, 'approved'),
(1008, 5, 102, '2023-06-01', 650.00, 'denied');

INSERT INTO visits VALUES
(201, 1, 101, '2023-01-15', 'I10'),
(202, 1, 104, '2023-02-20', 'M25'),
(203, 2, 102, '2023-03-05', 'L30'),
(204, 3, 101, '2023-03-18', 'I20'),
(205, 3, 101, '2023-04-10', 'I20'),
(206, 4, 103, '2023-04-25', 'J10'),
(207, 4, 103, '2023-05-10', 'J10'),
(208, 5, 102, '2023-06-01', 'L40');
