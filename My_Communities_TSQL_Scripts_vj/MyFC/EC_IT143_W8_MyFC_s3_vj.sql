-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s3_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 3 - Create an ad hoc SQL query
-- =====================================================

SELECT
    pos.p_name      AS position_name,
    COUNT(pl.pl_id) AS player_count
FROM dbo.tblPlayerDim AS pl
INNER JOIN dbo.tblPositionDim AS pos
    ON pl.p_id = pos.p_id
GROUP BY pos.p_name
ORDER BY player_count DESC;
