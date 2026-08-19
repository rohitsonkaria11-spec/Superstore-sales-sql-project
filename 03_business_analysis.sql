USE superstore_sales_portfolio;
-- 01 KPIs
SELECT ROUND(SUM(sales),2) total_sales, COUNT(DISTINCT order_id) orders, COUNT(DISTINCT customer_id) customers, COUNT(DISTINCT product_id) products, ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) avg_order_value FROM superstore_sales;
-- 02 Monthly sales
SELECT DATE_FORMAT(order_date,'%Y-%m') month, ROUND(SUM(sales),2) sales, COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY month;
-- 03 MoM growth
WITH m AS (SELECT DATE_FORMAT(order_date,'%Y-%m') month,SUM(sales) sales FROM superstore_sales GROUP BY DATE_FORMAT(order_date,'%Y-%m')) SELECT month,ROUND(sales,2) sales,ROUND(100*(sales-LAG(sales) OVER(ORDER BY month))/NULLIF(LAG(sales) OVER(ORDER BY month),0),2) mom_growth_pct FROM m;
-- 04 Category
SELECT category,ROUND(SUM(sales),2) sales,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY category ORDER BY sales DESC;
-- 05 Sub-category
SELECT sub_category,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY sub_category ORDER BY sales DESC;
-- 06 Top products
SELECT product_id,product_name,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY product_id,product_name ORDER BY sales DESC LIMIT 20;
-- 07 Top customers
SELECT customer_id,customer_name,ROUND(SUM(sales),2) sales,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY customer_id,customer_name ORDER BY sales DESC LIMIT 20;
-- 08 Segment
SELECT segment,ROUND(SUM(sales),2) sales,COUNT(DISTINCT customer_id) customers,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY segment ORDER BY sales DESC;
-- 09 Region
SELECT region,ROUND(SUM(sales),2) sales,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY region ORDER BY sales DESC;
-- 10 States
SELECT state,ROUND(SUM(sales),2) sales,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY state ORDER BY sales DESC LIMIT 15;
-- 11 Cities
SELECT city,state,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY city,state ORDER BY sales DESC LIMIT 20;
-- 12 Ship mode
SELECT ship_mode,ROUND(SUM(sales),2) sales,COUNT(DISTINCT order_id) orders FROM superstore_sales GROUP BY ship_mode ORDER BY sales DESC;
-- 13 Shipping days
SELECT ship_mode,ROUND(AVG(DATEDIFF(ship_date,order_date)),2) avg_ship_days FROM superstore_sales GROUP BY ship_mode;
-- 14 Weekday
SELECT DAYNAME(order_date) weekday,COUNT(DISTINCT order_id) orders,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY DAYOFWEEK(order_date),DAYNAME(order_date) ORDER BY DAYOFWEEK(order_date);
-- 15 Month number
SELECT MONTH(order_date) month_number,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY MONTH(order_date) ORDER BY month_number;
-- 16 Category share
WITH c AS (SELECT category,SUM(sales) sales FROM superstore_sales GROUP BY category) SELECT category,ROUND(sales,2) sales,ROUND(100*sales/SUM(sales) OVER(),2) sales_share_pct FROM c ORDER BY sales DESC;
-- 17 Running total
WITH m AS (SELECT DATE_FORMAT(order_date,'%Y-%m') month,SUM(sales) sales FROM superstore_sales GROUP BY DATE_FORMAT(order_date,'%Y-%m')) SELECT month,ROUND(sales,2) sales,ROUND(SUM(sales) OVER(ORDER BY month),2) running_sales FROM m;
-- 18 Top 3 products/category
WITH p AS (SELECT category,product_id,product_name,SUM(sales) sales FROM superstore_sales GROUP BY category,product_id,product_name),r AS (SELECT *,DENSE_RANK() OVER(PARTITION BY category ORDER BY sales DESC) category_rank FROM p) SELECT * FROM r WHERE category_rank<=3 ORDER BY category,category_rank;
-- 19 Top customers/segment
WITH c AS (SELECT segment,customer_id,customer_name,SUM(sales) sales FROM superstore_sales GROUP BY segment,customer_id,customer_name),r AS (SELECT *,ROW_NUMBER() OVER(PARTITION BY segment ORDER BY sales DESC) segment_rank FROM c) SELECT * FROM r WHERE segment_rank<=5 ORDER BY segment,segment_rank;
-- 20 Repeat customers
SELECT customer_id,customer_name,COUNT(DISTINCT order_id) orders,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY customer_id,customer_name HAVING COUNT(DISTINCT order_id)>1 ORDER BY orders DESC;
-- 21 High-frequency products
SELECT product_id,product_name,COUNT(DISTINCT order_id) orders,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY product_id,product_name HAVING COUNT(DISTINCT order_id)>=10 ORDER BY orders DESC LIMIT 20;
-- 22 Multi-product orders
SELECT order_id,COUNT(DISTINCT product_id) products_in_order,ROUND(SUM(sales),2) order_sales FROM superstore_sales GROUP BY order_id HAVING COUNT(DISTINCT product_id)>1 ORDER BY products_in_order DESC LIMIT 20;
-- 23 AOV segment
SELECT segment,ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) avg_order_value FROM superstore_sales GROUP BY segment ORDER BY avg_order_value DESC;
-- 24 AOV region
SELECT region,ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) avg_order_value FROM superstore_sales GROUP BY region ORDER BY avg_order_value DESC;
-- 25 State share
WITH s AS (SELECT state,SUM(sales) sales FROM superstore_sales GROUP BY state) SELECT state,ROUND(sales,2) sales,ROUND(100*sales/SUM(sales) OVER(),2) sales_share_pct FROM s ORDER BY sales DESC;
-- 26 Category x segment
SELECT category,segment,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY category,segment ORDER BY category,sales DESC;
-- 27 Region x category
SELECT region,category,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY region,category ORDER BY region,sales DESC;
-- 28 Shipping buckets
SELECT CASE WHEN DATEDIFF(ship_date,order_date)<=1 THEN '0-1 days' WHEN DATEDIFF(ship_date,order_date)<=3 THEN '2-3 days' WHEN DATEDIFF(ship_date,order_date)<=5 THEN '4-5 days' ELSE '6+ days' END shipping_bucket,COUNT(DISTINCT order_id) orders,ROUND(SUM(sales),2) sales FROM superstore_sales GROUP BY shipping_bucket;
-- 29 Best month
WITH m AS (SELECT DATE_FORMAT(order_date,'%Y-%m') month,SUM(sales) sales FROM superstore_sales GROUP BY DATE_FORMAT(order_date,'%Y-%m')) SELECT month,ROUND(sales,2) sales FROM m ORDER BY sales DESC LIMIT 1;
-- 30 Executive summary
SELECT ROUND(SUM(sales),2) total_sales,COUNT(DISTINCT order_id) total_orders,COUNT(DISTINCT customer_id) total_customers,COUNT(DISTINCT product_id) total_products,ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) avg_order_value FROM superstore_sales;