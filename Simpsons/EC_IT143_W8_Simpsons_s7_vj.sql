-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s7_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 7 - Turn the ad hoc script into a stored procedure
-- Purpose     : Encapsulates the Step 6 load logic so it can be
--               called on demand or from a larger ETL process.
-- =====================================================

DROP PROCEDURE IF EXISTS dbo.usp_Load_Simpsons_TotalAmountByCategory;
GO

CREATE PROCEDURE dbo.usp_Load_Simpsons_TotalAmountByCategory
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.tbl_Simpsons_TotalAmountByCategory;

    INSERT INTO dbo.tbl_Simpsons_TotalAmountByCategory (category_name, total_amount)
    SELECT category_name, total_amount
    FROM dbo.vw_Simpsons_TotalAmountByCategory;
END;
GO
