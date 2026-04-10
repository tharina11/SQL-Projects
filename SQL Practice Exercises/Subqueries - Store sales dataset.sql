-- Data exploration example 1
SELECT 
  purchase_item.purchase_id,
  product.product_name,
  category.name AS category_name,
  product.unit_price
FROM product
JOIN purchase_item
  ON product.product_id = purchase_item.product_id
JOIN category
  ON category.category_id = product.category_id
  
 -- Data exploration example 2
 SELECT
  first_name,
  last_name,
  COUNT(purchase_id) AS number_of_purchases
FROM employee
LEFT JOIN purchase
  ON employee.employee_id = purchase.employee_id
GROUP BY first_name, last_name
ORDER BY number_of_purchases DESC, last_name;

-- Average unit price in category
SELECT
  category.name AS category_name,
  AVG(unit_price) AS average_price
FROM category
JOIN product
ON category.category_id = product.category_id
GROUP BY category.name
HAVING AVG(unit_price) > (
  SELECT
    AVG(unit_price)
  FROM product);
  
-- Difference between customer minimum and overall minimum
SELECT
  purchase.customer_id,
  MIN(purchase_item.unit_price) - (SELECT MIN(purchase_item.unit_price) FROM purchase_item) AS difference
FROM purchase
JOIN purchase_item
  ON purchase_item.purchase_id = purchase.purchase_id
GROUP BY purchase.customer_id;


-- Highest total price among all customers
SELECT
  contact_name,
  SUM(total_price) AS highest_total_price
FROM customer
JOIN purchase
  ON customer.customer_id = purchase.customer_id
GROUP BY contact_name
HAVING SUM(total_price) >= ALL (
                                SELECT
  								  SUM(total_price)
                                FROM purchase
                                GROUP BY contact_name
								);
								
-- Purchase percentage per employee
SELECT
  last_name,
  first_name,
  COUNT(purchase_id) AS purchases_number,
  (SELECT COUNT(purchase_id)
   FROM purchase) AS total_purchases_number,
  (COUNT(purchase_id)* 100 ::numeric / (SELECT COUNT(purchase_id)
   						 FROM purchase)) AS purchases_percentage
FROM employee
JOIN purchase
  ON employee.employee_id = purchase.employee_id
GROUP BY last_name, first_name;

-- Filter data with two conditions
SELECT *
FROM purchase_item
WHERE purchase_id IN (
  SELECT 
    purchase_id 
  FROM purchase_item
  GROUP BY purchase_id
  HAVING COUNT(*) > 4)
AND purchase_id NOT IN (
  SELECT
    purchase_id
  FROM purchase_item
  JOIN product
  ON product.product_id = purchase_item.product_id
  WHERE category_id = 6)
  
 -- Percentage money spent by each customer on their purchases
SELECT
  contact_name,
  purchase_id,
  ROUND(total_price::numeric * 100/ (
  	SELECT
    SUM(total_price)
   	FROM purchase p2
   	WHERE p2.customer_id = p1.customer_id),0) AS percentage
FROM customer
JOIN purchase p1
ON customer.customer_id = p1.customer_id
;

-- Number of expensive products per category
SELECT
  name,
  COUNT(product_id) AS expensive_products
FROM category
JOIN product p1
  ON category.category_id = p1.category_id
WHERE unit_price > (
  SELECT
    AVG(unit_price)
  FROM product p2
  WHERE p1.category_id = p2.category_id)
GROUP BY name;

-- Maximum quantity each product was purchased
SELECT
  product_name,
  quantity,
  COUNT(purchase_id) purchases_number
  FROM product
  JOIN purchase_item p1
  ON product.product_id = p1.product_id
  WHERE quantity = (
    SELECT 
      MAX(quantity) 
    FROM purchase_item p2
    WHERE p1.product_id = p2.product_id
  )
GROUP BY product_name, quantity
;

-- Count of categories based on condition
SELECT
  c.name,
  (SELECT COUNT(*) FROM product WHERE category_id = c.category_id AND discontinued IS TRUE) AS discontinued_products,
  (SELECT COUNT(*) FROM product WHERE category_id = c.category_id AND discontinued IS FALSE) AS continued_products,
  (SELECT COUNT(*) FROM product WHERE category_id = c.category_id) AS all_products
FROM category c;