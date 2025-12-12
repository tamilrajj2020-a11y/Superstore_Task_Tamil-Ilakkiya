CREATE DATABASE superstore;
USE superstore;
select*from super;
ALTER TABLE super CHANGE `ORDER ID` order_id varchar(100);
ALTER TABLE super CHANGE `Order Date` Order_Date varchar(100);
UPDATE super
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y');

ALTER TABLE super
MODIFY COLUMN Order_Date DATE;

ALTER TABLE super CHANGE `Ship Date` Ship_Date varchar(100);
UPDATE super
SET Ship_Date = STR_TO_DATE(Ship_Date, '%d-%m-%Y');
ALTER TABLE super
MODIFY COLUMN Ship_Date DATE;

ALTER TABLE super CHANGE `Ship Mode` Ship_Mode varchar(100);
ALTER TABLE super CHANGE `Customer ID` Customer_ID varchar(100);
ALTER TABLE super CHANGE `Customer Name` Customer_Name varchar(100);
ALTER TABLE super CHANGE `Postal Code` Postal_Code varchar(100);
ALTER TABLE super CHANGE `Product ID` Product_ID varchar(100);
ALTER TABLE super CHANGE `Product name` Product_name varchar(300);


# 1.Total sales, profit, quantity

SELECT round(sum(sales),2) as Total_Sales,
       sum(quantity) as Total_quantity,
       round(sum(profit),2) as Total_profit
FROM super;

# 2. Monthly sales trend
SELECT 
    MONTHNAME(Order_Date) AS Month_Name,
    round(SUM(Sales),2) AS Total_Sales
FROM super
GROUP BY Month_Name;

# 3. YoY sales comparison
SELECT 
    YEAR(Order_Date) AS Year,
    round(SUM(Sales),2) AS Total_Sales
FROM super
GROUP BY YEAR(Order_Date)
ORDER BY Year;

# 4.Top 10 products by sales
SELECT 
    Product_Name,
    round(SUM(Sales),2) AS Total_Sales
FROM super
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

# 5. Top 10 customers by revenue
SELECT 
    Customer_Name,
    round(SUM(Sales),2) AS Total_Sales
FROM super
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

# 6. Category-wise profit margin
SELECT 
    Category,
    round(SUM(Profit),2) AS Total_Profit,
    round(SUM(Sales),2) AS Total_Sales,
   round(SUM(Profit) / SUM(Sales),2) * 100 AS Profit_Margin_Percentage
FROM super
GROUP BY Category;

# 7. Region performance (sales + profit)
SELECT 
    Region,
    round(SUM(Sales),2) AS Total_Sales,
    round(SUM(Profit),2)AS Total_Profit
FROM super
GROUP BY Region;

# 8. Discount impact on profitability
SELECT 
    Discount,
    round(AVG(Profit),2) AS Avg_Profit,
    round(AVG(Sales),2)AS Avg_Sales
FROM super
GROUP BY Discount
ORDER BY Discount;

# 9. Profit loss analysis (items with negative profit)
SELECT 
    Order_ID,
    Product_Name,
    Sales,
    Profit
FROM super
WHERE Profit < 0
ORDER BY Profit ASC;

# 10. Segment contribution %
SELECT 
    Segment,
    round(SUM(Sales),2) AS Segment_Sales,
    round((SUM(Sales) / (SELECT SUM(Sales) FROM super)),2)* 100 AS Contribution_Percentage
FROM super
GROUP BY Segment;


# 11. Shipping time calculation (Ship Date – Order Date)
SELECT 
    Order_ID,
    DATEDIFF(Ship_Date, Order_Date) AS Shipping_Time_Days
FROM super
order by Shipping_Time_Days Desc;

# 12. Identify outlier orders (High sales or loss)
SELECT 
    Order_ID,
    Product_Name,
    Sales,
    Profit
FROM super
WHERE Sales > (SELECT AVG(Sales) + 3 * STD(Sales) FROM super)
   OR Profit < (SELECT AVG(Profit) - 3 * STD(Profit) FROM super);






