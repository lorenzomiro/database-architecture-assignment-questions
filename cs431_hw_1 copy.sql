/*Name: Lorenzo Miro San Diego
Filename: cs431_hw_1.sql
Assignment: Assignment 1
*/

SELECT * FROM athlete_addresses;

-- Name: Lorenzo Miro San Diego

-- CS 431 Assignment 1

-- Problem 1 

SELECT sportinggoods_name, list_price, date_added 
FROM cs431_sporting_goods.sportinggoods_inventory
WHERE list_price BETWEEN 500 AND 2000
ORDER BY date_added DESC;

-- Problem 2

SELECT item_id, item_price, discount_amount, quantity, (item_price * quantity) AS price_total, (discount_amount * quantity) AS discount_total, (quantity * (item_price - discount_amount)) AS item_total
FROM athlete_order_items
WHERE (quantity * (item_price - discount_amount)) > 500
ORDER BY item_total DESC;

-- Problem 3 

SELECT
	NOW() AS today_unformatted,
	DATE_FORMAT(NOW(), '%M %D %Y') as today_formatted1,
	DATE_FORMAT(NOW(), '%D %M %Y') as today_formatted2;

-- Problem 4

SELECT athletes.first_name, athletes.last_name, athlete_addresses.line1, athlete_addresses.city, athlete_addresses.state, athlete_addresses.zip_code
    FROM athletes
    INNER JOIN athlete_addresses ON athlete_addresses.athlete_id = athletes.athlete_id
    WHERE athletes.email_address = "david.goldstein@hotmail.com";


-- Problem 5
SELECT athletes.first_name, athletes.last_name, athlete_addresses.line1, athlete_addresses.city, athlete_addresses.state, athlete_addresses.zip_code
    FROM athletes
    INNER JOIN athlete_addresses ON athlete_addresses.address_id = athletes.billing_address_id;

-- Problem 6 
SELECT athletes.last_name, athletes.first_name, athlete_orders.order_date, sportinggoods_inventory.sportinggoods_name,
	athlete_order_items.item_price, athlete_order_items.discount_amount, athlete_order_items.quantity
    FROM athlete_order_items
    INNER JOIN athlete_orders ON athlete_order_items.order_id = athlete_orders.order_id
    INNER JOIN athletes ON athlete_orders.athlete_id = athletes.athlete_id
    INNER JOIN sportinggoods_inventory ON sportinggoods_inventory.sportinggoods_id = athlete_order_items.sportinggoods_id
    ORDER BY last_name, order_date, sportinggoods_name DESC;
    
-- Problem 7
SELECT s1.sportinggoods_name, s1.list_price
FROM sportinggoods_inventory s1
JOIN sportinggoods_inventory s2
	ON s1.sportinggoods_id <> s2.sportinggoods_id
    AND s2.list_price = s1.list_price
ORDER BY s1.sportinggoods_name;

-- Problem 8
SELECT 'SHIPPED' AS ship_status, order_id, order_date
	FROM athlete_orders
    WHERE ship_date IS NOT NULL
UNION
	SELECT 'NOT SHIPPED', order_id, order_date
	FROM athlete_orders
    WHERE ship_date IS NULL
ORDER BY order_date;
    