-- Data preparation for the Power BI inventory report (Microsoft SQL Server / T-SQL)
-- Tested first on the smaller test-environment dataset, then applied to the production dataset.

CREATE DATABASE TEST_ENV;
GO
USE TEST_ENV;
GO

-- 1. Check the two source tables (loaded from the CSV files in /data)
SELECT * FROM [dbo].[Products];
SELECT * FROM [dbo].[Test+Environment+Inventory+Dataset];

-- 2. Combine inventory with product details.
--    SELECT * returns Product_ID twice, so list the columns explicitly.
SELECT a.[Order_Date_DD_MM_YYYY],
       a.[Product_ID],
       a.[Availability],
       a.[Demand],
       b.[Product_Name],
       b.[Unit_Price]
FROM [dbo].[Test+Environment+Inventory+Dataset] AS a
LEFT JOIN [dbo].[Products] AS b
       ON a.[Product_ID] = b.[Product_ID];

-- 3. Save the combined result as a new table so Power BI can load one clean table
SELECT * INTO New_table
FROM (
    SELECT a.[Order_Date_DD_MM_YYYY],
           a.[Product_ID],
           a.[Availability],
           a.[Demand],
           b.[Product_Name],
           b.[Unit_Price]
    FROM [dbo].[Test+Environment+Inventory+Dataset] AS a
    LEFT JOIN [dbo].[Products] AS b
           ON a.[Product_ID] = b.[Product_ID]
) AS x;

-- 4. Check the final table
SELECT * FROM New_table;
