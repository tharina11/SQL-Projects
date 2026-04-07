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
GROUP BY purchase.customer_id