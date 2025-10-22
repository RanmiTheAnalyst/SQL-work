create database Superstore;

SELECT * FROM superstore;


-- to check Data Quality 
SELECT 
    COUNT(*) AS Missing_Values
FROM superstore
WHERE Sales IS NULL OR Profit IS NULL OR Order_Date IS NULL OR Ship_Date IS NULL;



-- 1. to get the category performance for total sales, profit, and quality
SELECT Category,
		SUM(Sales) AS Total_Sales, 
        SUM(Profit) AS Total_Profit, 
		SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;
-- this helps to identify which category contributes most to total sales and profit


-- 2. the top 5 Customers by Total Sales
SELECT 
    Customer_Name, 
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 5;


-- 3. the average discount offered per region
SELECT 
    Region, 
    ROUND(AVG(Discount), 3) AS Avg_Discount
FROM superstore
GROUP BY Region;
-- Regions with high average discounts might show lower profit margins


-- To verify that the regions with high average discount show lower profit margins
SELECT 
    Region,
    ROUND(AVG(Discount), 3) AS Avg_Discount,
    ROUND(AVG(Profit / Sales) * 100, 2) AS Avg_Profit_Margin
FROM superstore
GROUP BY Region
ORDER BY Avg_Profit_Margin DESC;


-- 4. monthly sales totals for the year 2017(the latest year)
SELECT
    MONTHNAME(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS Month,
    round(SUM(Sales),3) AS Total_Sales
FROM superstore
WHERE YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')) = 2017
GROUP BY
    MONTHNAME(STR_TO_DATE(Order_Date, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(Order_Date, '%m/%d/%Y'))
ORDER BY
    MONTH(STR_TO_DATE(Order_Date, '%m/%d/%Y'));
-- this shows the peak and low sales months


-- 5. to calculate Profit Margin and Shipping Days
alter table superstore
add column Profit_Margin int;

update superstore
set Profit_Margin = (Profit/Sales) * 100;

select * from superstore;

alter table superstore
add column Shipping_Days int;

update sample_superstore
set Shipping_Days = Ship_Date-Order_Date;


UPDATE superstore
SET Shipping_Days = DATEDIFF(
    STR_TO_DATE(Ship_Date, '%m/%d/%Y'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y'));

UPDATE superstore
SET Shipping_Days = DATEDIFF(STR_TO_DATE(Ship_Date, '%m/%d/%Y'), STR_TO_DATE(Order_Date, '%m/%d/%Y'));
    
update superstore
set Shipping_Days = Ship_Date-Order_Date;
-- Profit margin helps evaluate product or regional profit.
-- Shipping days provide an operational metric for logistics efficiency.


-- 6. Lowest Profit Margin by State
select state,
 ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin
from superstore
group by state
order by  Avg_Profit_Margin asc
limit 1;
-- this identifies the lowest profit by state 


-- 7. Orders Taking More Than 5 Days to Ship
SELECT *
FROM superstore
WHERE Shipping_Days > 5;
-- These delayed orders may show logistic inefficiency or shipping constraints.


-- 8. to Calculate the average shipping days per ship mode
select 
	ship_mode,
    ROUND(AVG(Shipping_Days), 2) AS Avg_Shipping_Days
from superstore
group by Ship_Mode
order by Avg_Shipping_Days asc;
--  this shows which shipping mode is most efficient.



-- 9. Determine the most profitable product in each region
SELECT 
    Region, 
    ROUND(SUM(Sales), 2) AS Total_Sales, 
    ROUND(SUM(Profit), 2) AS Total_Profit, 
    ROUND(SUM(Profit)/SUM(Sales) * 100, 2) AS Avg_Profit_Margin
FROM superstore
GROUP BY Region
ORDER BY Avg_Profit_Margin DESC;
-- this helps compare which regions yield the best returns relative to sales



-- 10. the customer segment brings in the most revenue but lowest profit margin
SELECT 
    Segment, 
    Category, 
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales) * 100, 2) AS Profit_Margin
FROM superstore
GROUP BY Segment, Category
ORDER BY Profit_Margin asc;
-- this reveals which customer segments perform best within each category and has the lowest profit margin.



-- 11. to List orders with discounts > 0.3 (30%) and their profit impact
SELECT 
    Order_ID,
    Customer_Name,
    Segment,
    Region,
    Product_Name,
    Category,
    Sales,
    Discount,
    Profit,
    round((Sales * Discount),2) AS Discount_Amount,
    round((Profit / Sales) * 100,2) AS Actual_Profit_Percentage
FROM superstore
WHERE Discount > 0.3
ORDER BY Discount DESC;


select * from superstore;