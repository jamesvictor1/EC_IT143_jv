-- =====================================================
-- Script Name : EC_IT143_W8_MyFC_s2_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / MyFC
-- Step        : 2 - Begin creating an answer
-- =====================================================

-- WHERE I AM:
-- The tblPlayerDim table holds one row per player, including a p_id column
-- that is a foreign key to tblPositionDim, which holds the readable
-- position name (Goalkeeper, Defender, Midfielder, Forward).

-- NEXT LOGICAL STEP:
-- Join tblPlayerDim to tblPositionDim on p_id, then count player rows
-- grouped by position name.

-- SUB-ANSWER MAP:
-- Step 1 (sub-answer): Identify the two tables involved and the shared
--   join column (p_id).
-- Step 2 (sub-answer): Group and count players per position name.
-- (Steps 3-5 not yet finalized -- will confirm once the query is tested.)
