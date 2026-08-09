-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s7_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 7 - Turn the ad hoc script into a stored procedure
-- Purpose     : Encapsulates the Step 6 load logic so it can be
--               called on demand or from a larger ETL process.
-- =====================================================

DROP PROCEDURE IF EXISTS dbo.usp_Load_MyFC_PlayerCountByPosition;
GO

CREATE PROCEDURE dbo.usp_Load_MyFC_PlayerCountByPosition
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.tbl_MyFC_PlayerCountByPosition;

    INSERT INTO dbo.tbl_MyFC_PlayerCountByPosition (position_name, player_count)
    SELECT position_name, player_count
    FROM dbo.vw_MyFC_PlayerCountByPosition;
END;
GO
