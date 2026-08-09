-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s6_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 6 - Load the table from the view (ad hoc script)
-- =====================================================

TRUNCATE TABLE dbo.tbl_Simpsons_TotalAmountByCategory;

INSERT INTO dbo.tbl_Simpsons_TotalAmountByCategory (category_name, total_amount)
SELECT category_name, total_amount
FROM dbo.vw_Simpsons_TotalAmountByCategory;

-- Quick test:
-- SELECT * FROM dbo.tbl_Simpsons_TotalAmountByCategory;
