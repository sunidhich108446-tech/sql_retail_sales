CREATE DATABASE sql_project_p1;
USE sql_project_p1;
DROP TABLE IF EXISTS RetailSales;
CREATE TABLE RetailSales(
transactions_id  INT PRIMARY KEY,
sale_date DATE	,
sale_time  TIME,
customer_id  INT,
gender ENUM('Male','Female'),
age INT,
category VARCHAR(11),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);
-- data cleaning
SELECT * FROM RetailSales 
WHERE 
transactions_id IS NULL OR
sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL OR
quantity is NULL;


DELETE FROM RetailSales
WHERE 
transactions_id IS NULL OR
sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL OR
quantity is NULL;

-- DATA EXPLORATION
-- How many Sales we have?
   SELECT COUNT(*) as total_sale FROM RetailSales;
-- How many unique customers we have?
   SELECT COUNT(DISTINCT customer_id) as total_customers FROM RetailSales;-- Distinct will give us unique cust-id;
-- What kind of categories we have?
SELECT DISTINCT category FROM RetailSales;

-- DATA ANALYSIS AND BUISNESS KEY PROBLEMS
-- 1) Write an sql query to retrive all columns of sales made on 2022-11-05?
    SELECT * FROM  RetailSales
    WHERE sale_date ='2022-11-05';
-- 2) Retrive   all transactions where the category is clothing and the quantity sold is more than 10 in the month of november 2022?
	SELECT transactions_id FROM RetailSales 
    WHERE category = 'Clothing' AND quantity<10 AND MONTH(sale_date)=11 AND YEAR(sale_date)=2022;
    
-- 3) Write an sql query to calculate total sales of each category?
    SELECT category,SUM(total_sale) as totalSales FROM RetailSales  
    GROUP BY category;
-- 4) Find average age of the customers who purchased item from beauty category.
     SELECT AVG(age) FROM RetailSales WHERE category='Beauty';
-- 5) Find total number of transactions(transaction id) made by each gender in each category.
      SELECT category,gender,COUNT(*) AS tot_trans FROM RetailSales GROUP BY category, gender ORDER BY 1;
-- 6) Calculate the average sale for each month. Find out the best selling month in each year.
SELECT year, month, totalMonthSale
FROM (
    SELECT YEAR(sale_date) AS year,
           MONTH(sale_date) AS month,
           SUM(total_sale) AS totalMonthSale,
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS rnk
    FROM RetailSales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) 
WHERE rnk = 1;
-- 6) Write and sql query to find the top 5 customers based on the highest total_sale?
SELECT customer_id,SUM(total_sale) as total_sales FROM RetailSales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
-- 7) Write an sql query to find the number of unique customers who purchased item from each category.
SELECT category,COUNT(DISTINCT customer_id) as cust_id FROM RetailSales
GROUP BY 1
ORDER BY 2 DESC;
-- 8) Write an sql query to create each shift and number of orders (Example Morning<=12 , Afternoon between 12 and 17 , Evening>17)
     With Hourly_sales as
     (
     SELECT *, 
         CASE 
         WHEN HOUR(sale_time)<12 THEN 'morning'
         WHEN HOUR(sale_time) BETWEEN 12 AND 17  THEN 'afternoon' 
         ELSE   'evening'
         
	END as Shift
    FROM RetailSales
    )
    SELECT 
    shift,
    COUNT(*) as total_orders
    FROM Hourly_sales 
    GROUP BY Shift;

     
   