/*
-- Create data table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_month TEXT,
    region TEXT,
    product TEXT,
    amount INT
);

INSERT INTO sales (sale_month, region, product, amount) VALUES
('2024-01', 'East',  'Laptop', 1200),
('2024-01', 'East',  'Phone',   800),
('2024-01', 'West',  'Laptop', 1000),
('2024-01', 'West',  'Phone',   700),
('2024-02', 'East',  'Laptop', 1300),
('2024-02', 'East',  'Phone',   900),
('2024-02', 'West',  'Laptop', 1100),
('2024-02', 'West',  'Phone',   750),
('2024-02', 'East',  'Tablet',  600),
('2024-02', 'West',  'Tablet',  500);
*/

-- SELECT *
-- FROM sales;


-- 1. Show total sales by region, with separate columns for Laptop, Phone, and Tablet
SELECT region,
SUM(CASE WHEN product = 'Laptop' THEN amount ELSE 0 END) AS Laptop_sales,
SUM(CASE WHEN product = 'Phone' THEN amount ELSE 0 END) AS Phone_sales,
SUM(CASE WHEN product = 'Tablet' THEN amount ELSE 0 END) AS Tablet_sales
FROM sales
GROUP BY region;

-- 2. Do the same operation using Filter
SELECT region,
SUM(amount) FILTER(WHERE product = 'Laptop') AS Laptop_sales,
SUM(amount) FILTER(WHERE product = 'Phone') AS Phone_sales,
SUM(amount) FILTER(WHERE product = 'Tablet') AS Tablet_sales
FROM sales
GROUP BY region;

-- 3. Show total sales by product, with columns for Jan 2024 and Feb 2024.
SELECT product,
SUM(amount) FILTER(WHERE sale_month = '2024-01') AS january_sales,
SUM(amount) FILTER(WHERE sale_month = '2024-02') AS february_sales
FROM sales
GROUP BY product;

-- 4. Show total sales by region, pivoting months into columns.
SELECT
    region,
    SUM(amount) FILTER (WHERE sale_month = '2024-01') AS jan_sales,
    SUM(amount) FILTER (WHERE sale_month = '2024-02') AS feb_sales
FROM sales
GROUP BY region
ORDER BY region;

-- 5. Show sales by region and product, plus a total column (total sales per region).
SELECT region,
SUM(amount) FILTER(WHERE product = 'Laptop') AS Laptop_sales,
SUM(amount) FILTER(WHERE product = 'Phone') AS Phone_sales,
SUM(amount) FILTER(WHERE product = 'Tablet') AS Tablet_sales,
SUM(amount) AS regional_total_sales
FROM sales
GROUP BY region;

--6. For each region, show percentage contribution of each product.
