/*****************************************************************************
NAME:           EC_IT143_W3.4_xx.sql
PURPOSE:        AdventureWorks 2022 (OLTP) - Question & Answer SQL Script
                 Answers 8 questions submitted during W3.3 (2 mine, 6 from
                 classmates), 2 questions per required category.

MODIFICATION LOG:
Ver     Date            Author          Description
------  ----------      ------------    ----------------------------------
1.0     2026-08-04       xx              Initial script for W3.4 deliverable

RUNTIME:        < 5s (all queries combined, on local AdventureWorks2022)

NOTES:
Replicates answers to questions submitted in the W3.3 discussion board:
https://byupw.instructure.com/courses/50503/discussion_topics/440359
Question sources are noted individually below each question header.
*****************************************************************************/

USE AdventureWorks2022;
GO


/*****************************************************************************
CATEGORY:   Business User question - Marginal complexity
QUESTION 1  (Source: Classmate A)
Which product has the highest standard cost in the Production.Product table?
*****************************************************************************/
-- Answer: Return the product with the single highest StandardCost value.
SELECT TOP 1
    Name,
    StandardCost
FROM Production.Product
ORDER BY StandardCost DESC;
GO


/*****************************************************************************
CATEGORY:   Business User question - Marginal complexity
QUESTION 2  (Source: Classmate B)
How many products are listed in the Production.Product table?
*****************************************************************************/
-- Answer: Simple row count of the Production.Product table.
SELECT
    COUNT(*) AS TotalProducts
FROM Production.Product;
GO


/*****************************************************************************
CATEGORY:   Business User question - Moderate complexity
QUESTION 3  (Source: Classmate A)
As CEO, I need to evaluate our top individual customer. Who is the customer
with the highest total spend across all completed sales orders?
NOTE: "Completed" interpreted as any order present in SalesOrderHeader
(Status = 5 / Shipped). Adjust WHERE clause if a different definition of
"completed" is intended.
*****************************************************************************/
-- Answer: Join Customer, Person, and SalesOrderHeader; sum TotalDue per
-- customer; return the single highest spender among individual (non-store)
-- customers.
SELECT TOP 1
    c.CustomerID,
    p.FirstName,
    p.LastName,
    SUM(soh.TotalDue) AS TotalSpend
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
WHERE soh.Status = 5
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalSpend DESC;
GO


/*****************************************************************************
CATEGORY:   Business User question - Moderate complexity
QUESTION 4  (Source: Classmate B)
Which sales territory generated the highest total sales? Use the
Sales.SalesOrderHeader and Sales.SalesTerritory tables to determine the
answer.
NOTE: "Total sales" interpreted as SubTotal (product sales, excluding tax
and freight), across all order history.
*****************************************************************************/
-- Answer: Join SalesOrderHeader to SalesTerritory; sum SubTotal per
-- territory; return the highest-performing territory.
SELECT TOP 1
    st.Name AS TerritoryName,
    SUM(soh.SubTotal) AS TotalSales
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY TotalSales DESC;
GO


/*****************************************************************************
CATEGORY:   Business User question - Increased complexity
QUESTION 5  (Source: Me)
I'm preparing a report for our product team. We want to understand how road
bike sales performed by color in Europe during 2013. Please tell me the
total quantity sold, average list price, and total revenue for each color,
broken out by month.
*****************************************************************************/
-- Answer: Join SalesOrderDetail, SalesOrderHeader, Product,
-- ProductSubcategory, and SalesTerritory; filter to Road Bikes, Europe,
-- and calendar year 2013; group by month and color.
SELECT
    MONTH(soh.OrderDate)   AS OrderMonth,
    p.Color,
    SUM(sod.OrderQty)      AS TotalQuantitySold,
    AVG(p.ListPrice)       AS AvgListPrice,
    SUM(sod.LineTotal)     AS TotalRevenue
FROM Sales.SalesOrderDetail AS sod
JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE psc.Name = 'Road Bikes'
    AND st.[Group] = 'Europe'
    AND YEAR(soh.OrderDate) = 2013
GROUP BY MONTH(soh.OrderDate), p.Color
ORDER BY OrderMonth, p.Color;
GO


/*****************************************************************************
CATEGORY:   Business User question - Increased complexity
QUESTION 6  (Source: Classmate B)
Adventure Works is planning next quarter's production schedule and wants to
focus on its strongest-performing products. Identify the product with the
highest total sales revenue by combining sales and product information from
the appropriate tables. Explain which product should receive priority.
NOTE: Revenue calculated as SUM(LineTotal) across all-time order history.
*****************************************************************************/
-- Answer: Join SalesOrderDetail to Product; sum LineTotal per product;
-- return the single highest-revenue product.
SELECT TOP 1
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail AS sod
JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;
GO
-- Recommendation: The product returned above generated the highest
-- cumulative revenue in the company's order history, making it the
-- strongest candidate for production priority next quarter, assuming
-- demand trends have remained stable.


/*****************************************************************************
CATEGORY:   Metadata question
QUESTION 7  (Source: Me)
Using INFORMATION_SCHEMA.COLUMNS, can you list every table in AdventureWorks
that contains a column named ProductID?
*****************************************************************************/
-- Answer: Query INFORMATION_SCHEMA.COLUMNS filtered to the target column
-- name, returning schema and table name for each match.
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO


/*****************************************************************************
CATEGORY:   Metadata question
QUESTION 8  (Source: Classmate A)
How many user-defined tables inside the entire database contain a column
named BusinessEntityID according to the INFORMATION_SCHEMA.COLUMNS view?
*****************************************************************************/
-- Answer: Count distinct tables in INFORMATION_SCHEMA.COLUMNS where the
-- column name matches BusinessEntityID.
SELECT
    COUNT(DISTINCT TABLE_SCHEMA + '.' + TABLE_NAME) AS TableCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'BusinessEntityID';
GO