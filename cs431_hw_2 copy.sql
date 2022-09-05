/*Name: Lorenzo Miro San Diego
Filename: cs431_hw_2.sql
Assignment: Assignment 2 
*/

-- Name: Lorenzo Miro San Diego

-- CS 431 Assignment 2

-- Problem 1
SELECT category_name, COUNT(*) AS goods_count, MAX(list_price) AS most_expensive_good
FROM sportinggoods_categories cat
	JOIN sportinggoods_inventory inv ON cat.category_id = inv.category_id
GROUP BY category_name
ORDER BY goods_count DESC, category_name;

-- Problem 2
SELECT email_address,
	SUM(item_price * quantity) AS item_price_total, 
    SUM(discount_amount * quantity) AS discount_total_amount
	FROM athletes at
		JOIN athlete_orders ao
			ON at.athlete_id = ao.athlete_id
		JOIN athlete_order_items oi
			ON ao.order_id = oi.order_id
	GROUP BY email_address
	ORDER BY item_price_total DESC;
    
-- Problem 3
SELECT email_address,
	COUNT(DISTINCT oi.order_id) AS order_count,
	SUM((item_price - discount_amount) * quantity) AS order_total
	FROM athletes at
	JOIN athlete_orders ao
		ON at.athlete_id = ao.athlete_id
	JOIN athlete_order_items oi
		ON ao.order_id = oi.order_id
	GROUP BY email_address
	HAVING order_count > 1
	ORDER BY order_total DESC;

-- Problem 4
SELECT email_address,
	COUNT(DISTINCT oi.order_id) AS order_count,
    SUM((item_price - discount_amount) * quantity) AS order_total
	FROM athletes at
	JOIN athlete_orders ao
		ON at.athlete_id = ao.athlete_id
	JOIN athlete_order_items oi
		ON ao.order_id = oi.order_id
	WHERE item_price > 400
	GROUP BY email_address
	HAVING order_count > 1
	ORDER BY order_total DESC;
    
-- Problem 5
SELECT sportinggoods_name,
	SUM((item_price - discount_amount) * quantity) AS goods_total
	FROM sportinggoods_inventory inv
	JOIN athlete_order_items aoi
		ON inv.sportinggoods_id = aoi.sportinggoods_id
	GROUP BY sportinggoods_name WITH ROLLUP;
    
-- Problem 6
SELECT email_address,
	COUNT(DISTINCT aoi.item_id) AS number_of_goods
	FROM athletes ath
		JOIN athlete_orders ao
			ON ath.athlete_id = ao.athlete_id
		JOIN athlete_order_items aoi
			ON ao.order_id = aoi.order_id
	GROUP BY email_address
	HAVING COUNT(*) > 1
	ORDER BY email_address;

-- Problem 7
SELECT
	IF(GROUPING(category_name) = 1, "Grand Total", category_name) AS category_name,
	IF(GROUPING(sportinggoods_name) = 1, "Category Total", sportinggoods_name) AS goods_name,
	SUM(quantity) AS qty_purchased
	FROM sportinggoods_categories cat
	JOIN sportinggoods_inventory inv
		ON cat.category_id = inv.category_id
	JOIN athlete_order_items aoi
		ON inv.sportinggoods_id = aoi.sportinggoods_id
	GROUP BY category_name, sportinggoods_name WITH ROLLUP;
    
-- Problem 8
SELECT order_id,
	(item_price - discount_amount) * quantity AS item_amount, 
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY order_id) AS order_amount
	FROM athlete_order_items
	ORDER BY order_id;
    
-- Problem 9
SELECT order_id,
	(item_price - discount_amount) * quantity AS item_amount, 
    SUM((item_price - discount_amount) * quantity) OVER(win ORDER BY (item_price - discount_amount) * quantity) AS order_amount, 
    ROUND(AVG((item_price - discount_amount) * quantity) OVER(win), 2) AS avg_order_amount
	FROM athlete_order_items
	WINDOW win AS (PARTITION BY order_id)
	ORDER BY order_id;

-- Problem 10
SELECT athlete_id, order_date, 
	(item_price - discount_amount) AS item_total,
    SUM((item_price - discount_amount) * quantity) OVER(win) AS athlete_total,
	SUM((item_price - discount_amount) * quantity) OVER(win ORDER BY order_date
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS athlete_total_by_date
	FROM athlete_orders ao
	JOIN athlete_order_items aoi
		ON ao.order_id = aoi.order_id
        WINDOW win AS (PARTITION BY athlete_id);