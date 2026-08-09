-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s8_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 8 - Call the stored procedure
-- =====================================================

EXEC dbo.usp_Load_MyFC_PlayerCountByPosition;

-- Verify the result:
SELECT * FROM dbo.tbl_MyFC_PlayerCountByPosition;
