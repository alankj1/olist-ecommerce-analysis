CREATE DATABASE oliststore;
USE oliststore;

-- importing tables to sql
CREATE TABLE olist_customers_dataset(
customer_id varchar(50),
customer_zip_code_prefix int,
customer_city varchar(50),
customer_state varchar(50)
);

CREATE TABLE olist_geolocation_dataset(
geolocation_zip_code_prefix int,
geolocation_city varchar(50),
geolocation_state varchar(50)
);
CREATE TABLE olist_order_items_dataset(
order_id varchar(50),
product_id varchar(50),
seller_id varchar(50),
price float
);  

CREATE TABLE olist_order_payments_dataset(
order_id varchar(50),
payment_type varchar(50),
payment_value float
);

CREATE TABLE olist_order_reviews_dataset(
review_id varchar(50),
order_id varchar(50),
review_score int
);

CREATE TABLE olist_orders_dataset(
order_id varchar(50),
customer_id varchar(50),
order_status varchar(50),
order_purchase_timestamp date,
order_delivered_customer_date date,
Day_of_week int,
weekend_vs_weekdays varchar(50),
shipping_days int
);

CREATE TABLE products_dataset(
product_id varchar(50),
product_category_name varchar(100)
);

CREATE TABLE olist_sellers_dataset(
seller_id varchar(50)
,seller_zip_code_prefix int,
seller_city varchar(50),
seller_state varchar(50)
);

-- loaading data from files 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_customers_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT *FROM olist_geolocation_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_order_items_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_order_payments_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_order_reviews_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_orders_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products_dataset.csv'
INTO TABLE products_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM products_dataset;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
SELECT * FROM olist_sellers_dataset;



-- Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

    
SELECT
    o.weekend_vs_weekdays,
    COUNT(o.order_id) AS delivered_order_count
FROM
    olist_orders_dataset o
GROUP BY
    o.weekend_vs_weekdays;



-- Number of Orders with Review Score 5 and Payment Type as Credit Card
    
SELECT
    COUNT(op.order_id) AS num_orders
FROM
    olist_order_payments_dataset op
JOIN
    olist_order_reviews_dataset r ON op.order_id = r.order_id
WHERE
    r.review_score = 5
    AND op.payment_type = 'credit_card';
    
    
   
   
   -- Average Number of Days for Order Delivery for Pet Shop Products
   
SELECT 
	p.product_category_name, AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS Avg_shippingdays 
FROM
	products_dataset AS p 
JOIN 
	olist_order_items_dataset AS i ON p.product_id = i.product_id 
JOIN 
	olist_orders_dataset AS o ON i.order_id = o.order_id 
WHERE 
	p.product_category_name LIKE "%%pet_shop%%" 
GROUP BY 
	p.product_category_name;
	
    
    
    -- Average Price and Payment Values for Customers in Sao Paulo

SELECT
    AVG(oi.price) AS avg_order_price,
    AVG(op.payment_value) AS avg_payment_value,
    c.customer_city
FROM
    olist_order_items_dataset oi
JOIN
    olist_orders_dataset o ON oi.order_id = o.order_id
JOIN
    olist_order_payments_dataset op ON o.order_id = op.order_id
JOIN
    olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE
    c.customer_city = 'sao paulo'
GROUP BY
    c.customer_city;
    
    
    
   -- Relationship between Shipping Days and Review Scores 
    
    SELECT
    AVG(o.shipping_days) AS avg_shipping_days,
    r.review_score
FROM
    olist_orders_dataset o
JOIN
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
    o.shipping_days IS NOT NULL
    AND r.review_score IS NOT NULL
GROUP BY
    r.review_score
ORDER BY
    r.review_score ASC;





