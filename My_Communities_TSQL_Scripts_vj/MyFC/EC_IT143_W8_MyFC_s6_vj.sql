-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s6_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 6 - Load the table from the view (ad hoc script)
-- =====================================================

TRUNCATE TABLE dbo.tbl_MyFC_PlayerCountByPosition;

INSERT INTO dbo.tbl_MyFC_PlayerCountByPosition (position_name, player_count)
SELECT position_name, player_count
FROM dbo.vw_MyFC_PlayerCountByPosition;

-- Quick test:
-- SELECT * FROM dbo.tbl_MyFC_PlayerCountByPosition;
