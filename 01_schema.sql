CREATE DATABASE IF NOT EXISTS superstore_sales_portfolio;
USE superstore_sales_portfolio;
DROP TABLE IF EXISTS superstore_sales;
CREATE TABLE superstore_sales (
row_id INT, order_id VARCHAR(30), order_date DATE, ship_date DATE, ship_mode VARCHAR(40),
customer_id VARCHAR(30), customer_name VARCHAR(100), segment VARCHAR(30), country VARCHAR(60),
city VARCHAR(80), state VARCHAR(80), postal_code VARCHAR(20), region VARCHAR(30),
product_id VARCHAR(40), category VARCHAR(40), sub_category VARCHAR(40), product_name VARCHAR(255),
sales DECIMAL(12,4));