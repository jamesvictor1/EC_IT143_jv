-- =====================================================
-- Script Name : EC_IT143_W8_Simpsons_s5.2_vj.sql
-- Author      : vj
-- Date        : 2026-08-08
-- Database    : EC_IT143_DA / Simpsons
-- Step        : 5.2 - Refine the table architecture
-- Purpose     : Drops the quick-pass table from Step 5.1 and rebuilds it
--               with an explicit primary key, NOT NULL constraints,
--               a default value, and a refined decimal data type for
--               currency amounts.
-- =====================================================

DROP TABLE IF EXISTS dbo.tbl_Simpsons_TotalAmountByCategory;
GO

CREATE TABLE dbo.tbl_Simpsons_TotalAmountByCategory (
    category_name  VARCHAR(100)     NOT NULL PRIMARY KEY,
    total_amount   DECIMAL(12,2)    NOT NULL DEFAULT (0.00)
);
GO
