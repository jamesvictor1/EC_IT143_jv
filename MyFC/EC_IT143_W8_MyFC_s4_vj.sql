-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s4_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 4 - Turn the ad hoc query into a view
-- Purpose     : Returns the count of MyFC players per position.
-- Sources     : dbo.tblPlayerDim (players), dbo.tblPositionDim (position lookup)
-- Join Key    : tblPlayerDim.p_id = tblPositionDim.p_id
-- =====================================================

DROP VIEW IF EXISTS dbo.vw_MyFC_PlayerCountByPosition;
GO

CREATE VIEW dbo.vw_MyFC_PlayerCountByPosition
AS
    SELECT
        pos.p_name      AS position_name,
        COUNT(pl.pl_id) AS player_count
    FROM dbo.tblPlayerDim AS pl
    INNER JOIN dbo.tblPositionDim AS pos
        ON pl.p_id = pos.p_id
    GROUP BY pos.p_name;
GO

-- Quick test:
-- SELECT * FROM dbo.vw_MyFC_PlayerCountByPosition;
