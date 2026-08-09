-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s4_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 4 - Turn the ad hoc query into a view
-- Purpose     : Returns total transaction amount per spending category.
-- Source      : dbo.Planet_Express
-- =====================================================

DROP VIEW IF EXISTS dbo.vw_Simpsons_TotalAmountByCategory;
GO

CREATE VIEW dbo.vw_Simpsons_TotalAmountByCategory
AS
    SELECT
        Category    AS category_name,
        SUM(Amount) AS total_amount
    FROM dbo.Planet_Express
    GROUP BY Category;
GO

-- Quick test:
-- SELECT * FROM dbo.vw_Simpsons_TotalAmountByCategory;
