-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s3_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 3 - Create an ad hoc SQL query
-- =====================================================

SELECT
    Category         AS category_name,
    SUM(Amount)       AS total_amount
FROM dbo.Planet_Express
GROUP BY Category
ORDER BY total_amount DESC;
