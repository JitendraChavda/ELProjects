-- Create Database
CREATE DATABASE Sales

-- Create Table
CREATE TABLE financials (
    Segment VARCHAR(50),
    Country VARCHAR(50),
    Product VARCHAR(50),
    DiscountBand VARCHAR(20),
    UnitsSold DECIMAL(10,2),
    ManufacturingPrice DECIMAL(10,2),
    SalePrice DECIMAL(10,2),
    GrossSales DECIMAL(15,2),
    Discounts DECIMAL(15,2),
    Sales DECIMAL(15,2),
    Profit DECIMAL(15,2),
    Date DATE,
    MonthName VARCHAR(20),
    Year INT
);

-- Showing Table financials
SELECT * FROM financials;

-- Import Data from file in SQL
COPY
financials(Segment,Country,Product,DiscountBand,UnitsSold,ManufacturingPrice,SalePrice,GrossSales,Discounts,Sales,Profit,Date,MonthName,Year)
FROM 'D:\01 Yamraj\02 books\03 Internships\01 Elevate Labs\Projects\01 Retail Business Performance & Profitability Analysis\Sales.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- For checking Missing/null values in financials
SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN DiscountBand IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN UnitsSold IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN ManufacturingPrice IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN GrossSales IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN Discounts IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS null_country,
	   SUM(CASE WHEN MonthName IS NULL THEN 1 ELSE 0 END) AS null_segment,
       SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS null_country
FROM financials;

-- Delete Null Valuves
DELETE FROM financials
WHERE UnitsSold IS NULL
   OR GrossSales IS NULL
   OR Profit IS NULL
   OR Product IS NULL
   OR Segment IS NULL;

-- 1. profit margins by category & subcategory wise also create separate table for it
CREATE TABLE IF NOT EXISTS profit_margins AS
SELECT
    Segment AS Category,
    Product AS SubCategory,
    SUM(Profit) AS TotalProfit,
    SUM(GrossSales) AS TotalGrossSales,
    (SUM(Profit) / NULLIF(SUM(GrossSales), 0)) * 100 AS ProfitMarginPercentage
FROM
    financials
GROUP BY
    Segment,
    Product
ORDER BY
	ProfitMarginPercentage DESC;
-- Showing Table profit_margins
SELECT * FROM profit_margins;

-- 2. seasonal wise trends also create separate table for it
CREATE TABLE IF NOT EXISTS seasonal_trends AS
SELECT 
  monthname,
  AVG(sales) AS avg_sales_per_month
FROM financials
GROUP BY monthname
ORDER BY 
	CASE monthname
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
    ELSE 13
  END, avg_sales_per_month DESC;
-- Showing Table seasonal_trends
SELECT * FROM seasonal_trends;

-- 3. Slow moving overstocked Items also create separate table for it
CREATE TABLE IF NOT EXISTS slow_moving_items AS
SELECT category, subcategory,
SUM(unitssold) AS total_units_sold
FROM financials
GROUP BY category, subcategory
ORDER BY total_units_sold DESC
HAVING SUM(unitssold) > 5000;
-- Showing Table slow_moving_items
SELECT * FROM slow_moving_items;


-- some needed column add in financials datatable
ALTER TABLE financials
ADD COLUMN Category VARCHAR(50),
ADD COLUMN SubCategory VARCHAR(50),

-- some valvues are change as per needs
UPDATE financials
SET category = Segment 
WHERE category IS NULL;


ALTER TABLE financials
DROP COLUMN ``;


-- store datatables in CSV files
copy public."slow_moving_items" to 'D:\01 Yamraj\02 books\03 Internships\01 Elevate Labs\Projects\01 Retail Business Performance & Profitability Analysis\Update data\slow_moving_items.CSV' DELIMITER ',' CSV HEADER;



