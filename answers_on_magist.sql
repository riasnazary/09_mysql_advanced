use magist;
--------------------------------------------------------------------------------
/* Select all the products from the health_beauty or perfumery categories 
that have been paid by credit card with a payment amount of more than 1000$,
from orders that were purchased during 2018 and have a ‘delivered’ status? */
WITH temp AS (
	SELECT o.order_id, oi.product_id, o.order_status, o.order_purchase_timestamp, 
    op.payment_type, op.payment_value, pcnt.product_category_name_english
	FROM orders o
	JOIN order_payments op
		ON o.order_id = op.order_id
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON p.product_id = oi.product_id
	JOIN product_category_name_translation pcnt
		ON p.product_category_name = pcnt.product_category_name 
	WHERE order_status = "delivered" AND YEAR(order_purchase_timestamp) = "2018" 
    AND payment_type = "credit_card" AND ROUND(payment_value > 1000) 
    AND product_category_name_english IN ("health_beauty","perfumery"))
SELECT temp.product_id
FROM temp;
# 60 pcs
--------------------------------------------------------------------------------
-- For the products that you selected, get the following information:
-- The average weight of those products
WITH temp AS (
	SELECT o.order_id, oi.product_id, o.order_status, o.order_purchase_timestamp, 
    op.payment_type, op.payment_value, pcnt.product_category_name_english
	FROM orders o
	JOIN order_payments op
		ON o.order_id = op.order_id
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON p.product_id = oi.product_id
	JOIN product_category_name_translation pcnt
		ON p.product_category_name = pcnt.product_category_name 
	WHERE order_status = "delivered" AND YEAR(order_purchase_timestamp) = "2018" 
    AND payment_type = "credit_card" AND ROUND(payment_value > 1000) 
    AND product_category_name_english IN ("health_beauty","perfumery"))
SELECT temp.product_id, ROUND(AVG(products.product_weight_g))
FROM temp, products
GROUP BY temp.product_id;
--------------------------------------------------------------------------------
-- The cities where there are sellers that sell those products
--------------------------------------------------------------------------------
-- The cities where there are customers who bought products
