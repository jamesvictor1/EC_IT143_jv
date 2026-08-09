-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s5.1_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 5.1 - Turn the view into a table (quick first pass)
-- Purpose     : Uses SELECT...INTO to create the destination table
--               directly from the view. This is the fast, simple version.
--               Step 5.2 replaces this with a refined, hand-built table.
-- =====================================================

DROP TABLE IF EXISTS dbo.tbl_MyFC_PlayerCountByPosition;
GO

SELECT *
INTO dbo.tbl_MyFC_PlayerCountByPosition
FROM dbo.vw_MyFC_PlayerCountByPosition;
GO

-- Quick test:
-- SELECT * FROM dbo.tbl_MyFC_PlayerCountByPosition;
