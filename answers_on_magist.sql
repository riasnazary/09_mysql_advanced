USE magist;
--------------------------------------------------------------------------------
/* Select all the products from the health_beauty or perfumery categories 
that have been paid by credit card with a payment amount of more than 1000$,
from orders that were purchased during 2018 and have a ‘delivered’ status? */
DROP TABLE IF EXISTS selected_orders;
CREATE TEMPORARY TABLE selected_orders
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
AND product_category_name_english IN ("health_beauty","perfumery");
SELECT product_id FROM selected_orders;
# 60 pcs
--------------------------------------------------------------------------------
-- For the products that you selected, get the following information:
-- The average weight of those products
WITH temp AS (
    SELECT p.product_weight_g
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name 
    WHERE order_status = "delivered" AND YEAR(order_purchase_timestamp) = "2018" 
    AND payment_type = "credit_card" AND ROUND(payment_value > 1000) 
    AND product_category_name_english IN ("health_beauty","perfumery"))
SELECT AVG(temp.product_weight_g) FROM temp;
# '5180.4833'
--------------------------------------------------------------------------------
-- The cities where there are sellers that sell those products
WITH temp AS (
    SELECT g.city
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name 
    JOIN sellers s ON oi.seller_id = s.seller_id
	JOIN geo g ON s.seller_zip_code_prefix = g.zip_code_prefix
    WHERE order_status = "delivered" AND YEAR(order_purchase_timestamp) = "2018" 
    AND payment_type = "credit_card" AND ROUND(payment_value > 1000) 
    AND product_category_name_english IN ("health_beauty","perfumery"))
SELECT DISTINCT temp.city FROM temp;
/*
'campinas'
'sao paulo'
'niteroi'
'sao bernardo do campo'
'teresopolis'
'bombinhas'
'indaial'
'curitiba'
'piracicaba'
*/
--------------------------------------------------------------------------------
-- The cities where there are customers who bought products
WITH temp AS (
    SELECT g.city
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name 
    JOIN customers c ON o.customer_id = c.customer_id
	JOIN geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
    WHERE order_status = "delivered" AND YEAR(order_purchase_timestamp) = "2018" 
    AND payment_type = "credit_card" AND ROUND(payment_value > 1000) 
    AND product_category_name_english IN ("health_beauty","perfumery"))
SELECT DISTINCT temp.city FROM temp;
/* 
'uberaba'
'cachoeiro de itapemirim'
'sao paulo'
'sao joao do piaui'
'fortaleza'
'colider'
'guarapuava'
'palmas'
'ribeirao preto'
'feira de santana'
'botucatu'
'bonfinopolis de minas'
'rio de janeiro'
'coari'
'campinas'
'vicosa'
'belo horizonte'
'tres lagoas'
'americo brasiliense'
'lages'
'ji-parana'
'divinopolis'
'guaratingueta'
'campo grande'
'juiz de fora'
'guarani'
'belem'
'brasilia'
'costa marques'
'picos'
'parnamirim'
'tapiramuta'
'natal'
'santana do jacare'
*/