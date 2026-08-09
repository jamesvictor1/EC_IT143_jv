DROP PROCEDURE IF EXISTS dbo.usp_hello_world_load;
GO

CREATE PROCEDURE dbo.usp_hello_world_load
AS

/**********************************************************************
NAME:       dbo.usp_hello_world_load
PURPOSE:    Load the Hello World table from the Hello World view

MODIFICATION LOG:
Ver     Date            Author      Description
-----   ----------      ------      -----------
1.0     08/08/2026      VJ          1. Built this script for EC IT143

RUNTIME:
1s

NOTES:
This script exists to help me learn step 7 of 8 in the Answer Focused Approach for T-SQL Data Manipulation

**********************************************************************/

BEGIN
    SET NOCOUNT ON;

    -- 1) Reload data
    TRUNCATE TABLE dbo.t_hello_world;

    INSERT INTO dbo.t_hello_world
            SELECT v.my_message
                 , v.current_date_time
              FROM dbo.v_hello_world_load AS v;
END;
GO