USE superstore_sales_portfolio;
SELECT COUNT(*) rows, COUNT(DISTINCT order_id) orders, COUNT(DISTINCT customer_id) customers, COUNT(DISTINCT product_id) products FROM superstore_sales;
SELECT MIN(order_date) first_order_date, MAX(order_date) last_order_date FROM superstore_sales;
SELECT SUM(order_id IS NULL OR TRIM(order_id)='') missing_order_id, SUM(customer_id IS NULL OR TRIM(customer_id)='') missing_customer_id, SUM(product_id IS NULL OR TRIM(product_id)='') missing_product_id, SUM(order_date IS NULL) missing_order_date, SUM(sales IS NULL) missing_sales FROM superstore_sales;
SELECT row_id, COUNT(*) duplicate_count FROM superstore_sales GROUP BY row_id HAVING COUNT(*)>1;
SELECT COUNT(*) negative_sales_rows FROM superstore_sales WHERE sales<0;
SELECT COUNT(*) invalid_ship_dates FROM superstore_sales WHERE ship_date<order_date;