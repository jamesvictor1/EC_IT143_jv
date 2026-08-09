-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s5.1_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 5.1 - Turn the view into a table (quick first pass)
-- Purpose     : Uses SELECT...INTO to create the destination table
--               directly from the view. Step 5.2 replaces this with
--               a refined, hand-built table.
-- =====================================================

DROP TABLE IF EXISTS dbo.tbl_Simpsons_TotalAmountByCategory;
GO

SELECT *
INTO dbo.tbl_Simpsons_TotalAmountByCategory
FROM dbo.vw_Simpsons_TotalAmountByCategory;
GO

-- Quick test:
-- SELECT * FROM dbo.tbl_Simpsons_TotalAmountByCategory;
