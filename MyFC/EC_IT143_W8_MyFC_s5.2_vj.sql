-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s5.2_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 5.2 - Refine the table architecture
-- Purpose     : Drops the quick-pass table from Step 5.1 and rebuilds it
--               with an explicit primary key, NOT NULL constraints,
--               a default value, and refined data types.
-- =====================================================

DROP TABLE IF EXISTS dbo.tbl_MyFC_PlayerCountByPosition;
GO

CREATE TABLE dbo.tbl_MyFC_PlayerCountByPosition (
    position_name  VARCHAR(50)  NOT NULL PRIMARY KEY,
    player_count   INT          NOT NULL DEFAULT (0)
);
GO
