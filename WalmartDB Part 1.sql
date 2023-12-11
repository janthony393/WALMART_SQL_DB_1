select *
from dbo.[WalmartSalesData.csv]

--Feature Engineering
----time_of_day

select 
  time,
   (CASE
   WHEN time Between '00:00:00' and '12:00:00' THEN 'Morning'
   WHEN time Between '12:01:00' and '16:00:00' THEN 'Afternoon'
   ELSE 'Evening'
   END 
   ) AS Time_of_date
 from [WalmartSalesData.csv]; 

ALTER TABLE [WalmartSalesData.csv] ADD Time_of_date varchar(20)

UPDATE [WalmartSalesData.csv]
SET Time_of_date = (
CASE
   WHEN time Between '00:00:00' and '12:00:00' THEN 'Morning'
   WHEN time Between '12:01:00' and '16:00:00' THEN 'Afternoon'
   ELSE 'Evening'
   END 
   );

-- day_name

select 
     date,
	 DATENAME(DW, date) AS day_name
From [WalmartSalesData.csv];

ALTER TABLE [WalmartSalesData.csv] ADD day_name varchar(10);


UPDATE [WalmartSalesData.csv]
SET day_name = DATENAME(DW, date)

--Month_name

select 
     date,
	 DATENAME(M, date) AS month_name
From [WalmartSalesData.csv];

ALTER TABLE [WalmartSalesData.csv] ADD month_name varchar(10);

UPDATE [WalmartSalesData.csv]
SET month_name = DATENAME(M, date)

--How many unique cities does the data have?

select
DISTINCT City
FROM [WalmartSalesData.csv]

--In which city is each branch?

select
DISTINCT City,
Branch
FROM [WalmartSalesData.csv]

--PRODUCT QUESTIONS

-- How many unique product lines does the data have?
select 
  COUNT(DISTINCT Product_line) AS #PRODUCTLINES
  from [WalmartSalesData.csv]

  --What is the most common payment method?

  select payment,
  COUNT(Payment) as CNT
  from [WalmartSalesData.csv]
  GROUP BY Payment
  ORDER BY CNT DESC

  --What is the product line most selling?

select Product_line, COUNT(Product_line) as cnt
from [WalmartSalesData.csv]
group by Product_line
order by cnt

-- Total Revenue by month?

select month_name as month_name,
CAST(SUM(total) AS decimal (10, 2)) as total_sales
from [WalmartSalesData.csv]
group by month_name
Order by total_sales desc;

--What month had the largest COGS?

select
 month_name as month_name,
 CAST(SUM(cogs) AS decimal (10, 2)) as cogs
 from [WalmartSalesData.csv]
 group by month_name
 order by cogs

 --What product line had the largest revenue?
 select
 Product_line,
 CAST(SUM(total) AS decimal (10, 2)) as total_revenue
 from [WalmartSalesData.csv]
 GROUP BY Product_line
 Order by total_revenue desc

 -- What is the City with the largest revenue?
 
 select City,
 CAST(SUM(total) AS Decimal (10, 2)) as total_revenue
from [WalmartSalesData.csv]
GROUP BY City
Order by total_revenue desc

--- Which branch sold more products than average product sold?

select Branch,
sum(Quantity) as qty
from [WalmartSalesData.csv]
Group by branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) from [WalmartSalesData.csv]);

--- What is the most common product line by Gender?

select gender,
product_line,
COUNT(gender) as total_cnt
from [WalmartSalesData.csv]
GROUP BY Gender, Product_line
order by total_cnt desc

--WHAT IS THE AVG Rating for each Product line?

select
CAST(AVG(rating) AS decimal (10, 2)) as AVG,
Product_line
from [WalmartSalesData.csv]
GROUP BY Product_line
order by AVG(rating) desc