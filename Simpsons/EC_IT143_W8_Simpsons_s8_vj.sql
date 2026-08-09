-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s8_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 8 - Call the stored procedure
-- =====================================================

EXEC dbo.usp_Load_Simpsons_TotalAmountByCategory;

-- Verify the result:
SELECT * FROM dbo.tbl_Simpsons_TotalAmountByCategory;
