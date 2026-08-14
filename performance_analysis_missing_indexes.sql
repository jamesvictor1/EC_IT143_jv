/*
================================================================================
 Performance Analysis - Missing Index Recommendations
 Database: AdventureWorks2022
 Description: This script demonstrates identifying and resolving missing
 index recommendations on two different tables in AdventureWorks2022.
 For each example: run the SELECT with "Include Actual Execution Plan"
 turned on (Ctrl+M) to see the missing index recommendation, then run
 the corresponding CREATE INDEX statement to resolve it.
================================================================================
*/

-- ================================================================
-- EXAMPLE 1: Person.Person table
-- ================================================================

-- Step 1: Run this query with Actual Execution Plan on.
-- Before the index is created, this produces a Clustered Index Scan
-- (cost: 100%) and a missing index recommendation on [MiddleName].
SELECT BusinessEntityID, FirstName, LastName, MiddleName
FROM Person.Person
WHERE MiddleName = 'A';

-- Step 2: Create the recommended index (name customized from the
-- SQL Server-generated script).
CREATE NONCLUSTERED INDEX [IX_Person_MiddleName]
ON [Person].[Person] ([MiddleName])
INCLUDE (
    [PersonType],
    [NameStyle],
    [Title],
    [FirstName],
    [LastName],
    [Suffix],
    [EmailPromotion],
    [AdditionalContactInfo],
    [Demographics]
);

-- Step 3: Re-run the Step 1 query. The missing index banner is gone
-- and the plan now uses the new index instead of scanning the table.


-- ================================================================
-- EXAMPLE 2: Sales.SalesOrderHeader table
-- ================================================================

-- Step 1: Run this query with Actual Execution Plan on.
-- Before the index is created, this produces a Clustered Index Scan
-- (cost: 100%) and a missing index recommendation on
-- [PurchaseOrderNumber], with an estimated impact of ~99%.
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE PurchaseOrderNumber = 'PO348186007';

-- Step 2: Create the recommended index.
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_PurchaseOrderNumber]
ON [Sales].[SalesOrderHeader] ([PurchaseOrderNumber]);

-- Step 3: Re-run the Step 1 query. The plan now shows an Index Seek
-- + Key Lookup instead of a full Clustered Index Scan, and the
-- missing index banner is gone.
