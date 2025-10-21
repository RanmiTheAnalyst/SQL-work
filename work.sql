create database superstore;


select * from sample_superstore;


-- to get total sales, profit, and quantity sold for each category
select category, sum(sales) as Total_Sales, sum(profit) as Total_Profit, sum(Quantity) as Total_Quantity
from sample_superstore
group by Category;


-- the top 5 customers by total sales
select Customer_Name, sum(sales) as Total_Sales 
from sample_superstore
group by Customer_Name
order by Total_sales desc
limit 5;


-- the average discount offered per region
select Region, avg(discount) as Avg_Discount
from sample_superstore
group by region;


-- monthly sales totals for the year 2017
SELECT 
    YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS Order_date,
    SUM(Sales) AS Total_Sales
FROM sample_superstore
WHERE YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')) = (
    SELECT MAX(YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')))
    FROM sample_superstore)
GROUP BY YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y'));


alter table sample_superstore
add column Profit_Margin int;


update sample_superstore
set Profit_Margin = (Profit/Sales) * 100;


select * from sample_superstore;



alter table sample_superstore
add column Shipping_Days int;


update sample_superstore
set Shipping_Days = Ship_Date-Order_Date;

UPDATE sample_superstore
SET Shipping_Days = DATEDIFF(Ship_Date, Order_Date);

DESCRIBE sample_superstore;

UPDATE sample_superstore
SET Shipping_Days = DATEDIFF(STR_TO_DATE(Ship_Date, '%m/%d/%Y'), STR_TO_DATE(Order_Date, '%m/%d/%Y'));

UPDATE sample_superstore
SET Shipping_Days = DATEDIFF(
    STR_TO_DATE(Ship_Date, '%m/%d/%Y'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y')
);


select * from sample_superstore;



-- Which state generated the lowest profit margin? 
select state, profit_margin
from sample_superstore
order by profit_margin asc;



-- to find all orders that took more than 5 days to ship
SELECT *
FROM sample_superstore
WHERE Shipping_Days > 5;


-- to Calculate the average shipping days per ship mode
select ship_mode, avg(shipping_days) as Avg_shipping_days
from sample_superstore
group by Ship_Mode
order by avg(shipping_days) asc;


select * from sample_superstore;


-- Determine the most profitable product in each region
SELECT 
    s.Region,
    s.Product_Name,
    s.Profit
FROM 
    sample_superstore s
JOIN (
    SELECT 
        Region,
        MAX(Profit) AS MaxProfit
    FROM 
        sample_superstore
    GROUP BY 
        Region
) r 
ON s.Region = r.Region AND s.Profit = r.MaxProfit;


-- the customer segment brings in the most revenue but lowest profit margin
SELECT Segment,
    SUM(Sales) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Avg_Profit_Margin
FROM sample_superstore
GROUP BY Segment
ORDER BY Total_Revenue DESC, Avg_Profit_Margin ASC
LIMIT 1;



-- to List orders with discounts > 0.3 (30%) and their profit impact
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
    (Sales * Discount) AS Discount_Amount,
    (Profit / Sales) * 100 AS Actual_Profit_Percentage
FROM sample_superstore
WHERE Discount > 0.3
ORDER BY Discount DESC;

