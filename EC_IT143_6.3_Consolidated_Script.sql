-- =========================================================
-- EC_IT143 6.3 — User-Defined Functions and Triggers
-- Consolidated working script
-- Run in a query tab connected to: DESKTOP-L11599R\MSSQLSERVER01
-- Database: EC_IT143_DA
-- =========================================================

-- Confirm you're on the correct server/database before running anything
SELECT @@SERVERNAME AS ServerInstance, DB_NAME() AS CurrentDatabase;
-- Expect: MSSQLSERVER01 and EC_IT143_DA. If not, reconnect before continuing.
GO

-- =========================================================
-- STEP 0: One-time table setup
-- Skip this block if LastModifiedDate / LastModifiedBy already exist
-- (you'll get "column names in each table must be unique" if so — that's fine, ignore it)
-- =========================================================
ALTER TABLE dbo.t_w3_schools_customers
ADD LastModifiedDate DATETIME NULL,
    LastModifiedBy    VARCHAR(128) NULL;
GO

-- =========================================================
-- STEP 1: Turn off recursive triggers
-- Prevents the trigger from re-firing itself when it updates its own table
-- (this fixes the "Maximum stored procedure, function, trigger, or view
-- nesting level exceeded" error)
-- =========================================================
ALTER DATABASE EC_IT143_DA SET RECURSIVE_TRIGGERS OFF;
GO

-- =========================================================
-- STEP 2: Drop existing objects first (safe re-run)
-- Only needed if you're re-running this whole script from scratch.
-- If the objects don't exist yet, these will just show a harmless error — ignore it.
-- =========================================================
DROP FUNCTION IF EXISTS dbo.fn_GetFirstName;
DROP FUNCTION IF EXISTS dbo.fn_GetLastName;
DROP TRIGGER IF EXISTS dbo.trg_UpdateLastModifiedDate;
DROP TRIGGER IF EXISTS dbo.trg_UpdateLastModifiedBy;
GO

-- =========================================================
-- STEP 3: Create the FirstName scalar function
-- Purpose: returns everything before the first space in ContactName.
-- If there's no space (e.g. "Zbyszek"), returns the whole string.
-- =========================================================
CREATE FUNCTION dbo.fn_GetFirstName (@ContactName VARCHAR(100))
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @FirstName VARCHAR(50);
    IF CHARINDEX(' ', @ContactName) = 0
        SET @FirstName = @ContactName;
    ELSE
        SET @FirstName = SUBSTRING(@ContactName, 1, CHARINDEX(' ', @ContactName) - 1);
    RETURN @FirstName;
END;
GO

-- =========================================================
-- STEP 4: Create the LastName scalar function
-- Purpose: returns everything after the first space in ContactName.
-- If there's no space, returns an empty string (no last name to extract).
-- =========================================================
CREATE FUNCTION dbo.fn_GetLastName (@ContactName VARCHAR(100))
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @LastName VARCHAR(50);
    IF CHARINDEX(' ', @ContactName) = 0
        SET @LastName = '';
    ELSE
        SET @LastName = SUBSTRING(@ContactName, CHARINDEX(' ', @ContactName) + 1, LEN(@ContactName));
    RETURN @LastName;
END;
GO

-- =========================================================
-- STEP 5: Create the LastModifiedDate trigger
-- Purpose: stamps the current date/time whenever a row is updated.
-- =========================================================
CREATE TRIGGER dbo.trg_UpdateLastModifiedDate
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t
    SET t.LastModifiedDate = GETDATE()
    FROM dbo.t_w3_schools_customers t
    INNER JOIN inserted i ON t.CustomerID = i.CustomerID;
END;
GO

-- =========================================================
-- STEP 6: Create the LastModifiedBy trigger
-- Purpose: stamps the current server login whenever a row is updated.
-- =========================================================
CREATE TRIGGER dbo.trg_UpdateLastModifiedBy
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t
    SET t.LastModifiedBy = SUSER_NAME()
    FROM dbo.t_w3_schools_customers t
    INNER JOIN inserted i ON t.CustomerID = i.CustomerID;
END;
GO

-- =========================================================
-- STEP 7: Verify everything works
-- =========================================================

-- 7a. Test the functions directly
SELECT dbo.fn_GetFirstName('Maria Anders') AS FirstNameTest,
       dbo.fn_GetLastName('Maria Anders')  AS LastNameTest,
       dbo.fn_GetFirstName('Zbyszek')      AS FirstNameEdgeCase,
       dbo.fn_GetLastName('Zbyszek')       AS LastNameEdgeCase;
-- Expect: Maria | Anders | Zbyszek | (empty)

-- 7b. Test the functions against the whole table
SELECT
    ContactName,
    dbo.fn_GetFirstName(ContactName) AS FirstName,
    dbo.fn_GetLastName(ContactName)  AS LastName
FROM dbo.t_w3_schools_customers;

-- 7c. Trigger the update to test both triggers
UPDATE dbo.t_w3_schools_customers
SET City = City   -- trivial change just to fire the triggers
WHERE CustomerID = 1;

-- 7d. Confirm both LastModifiedDate and LastModifiedBy populated
SELECT CustomerID, ContactName, City, LastModifiedDate, LastModifiedBy
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;
-- Expect: a real date/time and your login name, not NULL

-- =========================================================
-- STEP 8: "0 results expected" validation tests
-- Proves the functions match manual ad hoc logic across all rows
-- =========================================================

-- First name validation — should return 0 rows
WITH FirstNameCheck AS (
    SELECT
        ContactName,
        CASE
            WHEN CHARINDEX(' ', ContactName) = 0 THEN ContactName
            ELSE SUBSTRING(ContactName, 1, CHARINDEX(' ', ContactName) - 1)
        END AS AdHoc_FirstName,
        dbo.fn_GetFirstName(ContactName) AS UDF_FirstName
    FROM dbo.t_w3_schools_customers
)
SELECT * FROM FirstNameCheck WHERE AdHoc_FirstName <> UDF_FirstName;

-- Last name validation — should return 0 rows
WITH LastNameCheck AS (
    SELECT
        ContactName,
        CASE
            WHEN CHARINDEX(' ', ContactName) = 0 THEN ''
            ELSE SUBSTRING(ContactName, CHARINDEX(' ', ContactName) + 1, LEN(ContactName))
        END AS AdHoc_LastName,
        dbo.fn_GetLastName(ContactName) AS UDF_LastName
    FROM dbo.t_w3_schools_customers
)
SELECT * FROM LastNameCheck WHERE AdHoc_LastName <> UDF_LastName;
