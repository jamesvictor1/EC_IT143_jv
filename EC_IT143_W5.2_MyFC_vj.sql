/*****************************************************************************************************************
NAME: EC_IT143_W5.2_MyFC_vj.sql
PURPOSE: Answer four My Communities questions about the MyFC (fantasy/roster & player salary) data set by
         translating each natural-language business question into a T-SQL SELECT statement.

MODIFICATION LOG:
Ver     Date            Author          Description
1.0     08/13/2026      VJ              1. Built this script for EC IT143 W5.2 assignment

RUNTIME: <1s

NOTES: This script answers 4 questions about the MyFC database, covering team payroll totals, roster counts
       by position versus target, monthly salary spending trends, and each player's salary share of their
       team's total payroll. All 4 questions in this script were authored by me (Victor James).

       Schema note: tblTeamDim only exposes t_id and t_code (no dedicated team-name column), so t_code is
       used below as the team identifier/name.
******************************************************************************************************************/

-- Q1: Which team is currently spending the most on player salaries this month? I'd like to see team name,
--     player names, and month-to-date salary totals to help plan next season's budget. (Author: Me)
-- A1: Pulls each player's most recent month-to-date salary snapshot, alongside a running team total
--     (via a window function), so teams can be compared and ranked by total MTD payroll.
;WITH LatestDate AS (
    SELECT MAX(as_of_date) AS as_of_date
    FROM tblPlayerFact
)
SELECT
    t.t_code AS Team,
    p.pl_name AS PlayerName,
    f.mtd_salary AS PlayerMTDSalary,
    SUM(f.mtd_salary) OVER (PARTITION BY t.t_code) AS TeamMTDSalaryTotal
FROM tblPlayerFact f
JOIN tblPlayerDim p ON f.pl_id = p.pl_id
JOIN tblTeamDim t ON p.t_id = t.t_id
CROSS JOIN LatestDate ld
WHERE f.as_of_date = ld.as_of_date
ORDER BY TeamMTDSalaryTotal DESC, PlayerMTDSalary DESC;


-- Q2: How many players are we carrying at each position compared to our position targets? Please show
--     position name, target count, and actual player count so I can spot roster gaps. (Author: Me)
-- A2: Joins the position dimension (which holds each position's target headcount) to the pre-built
--     player-count-by-position view, and calculates the variance so gaps/surpluses are easy to spot.
SELECT
    pos.p_name AS PositionName,
    pos.p_target AS TargetCount,
    ISNULL(v.player_count, 0) AS ActualPlayerCount,
    ISNULL(v.player_count, 0) - pos.p_target AS Variance
FROM tblPositionDim pos
LEFT JOIN vw_MyFC_PlayerCountByPosition v ON pos.p_name = v.position_name
ORDER BY Variance ASC;


-- Q3: How has total monthly salary spending changed across the season so far? I want to see the month
--     name and total salary paid across all players to track spending trends over time. (Author: Me)
-- A3: Since mtd_salary is a running month-to-date figure, this first finds each player's LAST snapshot
--     within each calendar month (so amounts aren't double-counted), then sums those across all players
--     per month to build the spending trend.
;WITH MonthlyMax AS (
    SELECT
        f.pl_id,
        d.year_number,
        d.month_number,
        d.month_name,
        MAX(f.as_of_date) AS last_as_of_date
    FROM tblPlayerFact f
    JOIN DateDim d ON f.as_of_date = d.day_date
    GROUP BY f.pl_id, d.year_number, d.month_number, d.month_name
)
SELECT
    mm.month_name AS MonthName,
    mm.month_number AS MonthNumber,
    mm.year_number AS YearNumber,
    SUM(f.mtd_salary) AS TotalSalaryPaid
FROM MonthlyMax mm
JOIN tblPlayerFact f ON f.pl_id = mm.pl_id AND f.as_of_date = mm.last_as_of_date
GROUP BY mm.month_name, mm.month_number, mm.year_number
ORDER BY mm.year_number, mm.month_number;


-- Q4: Which players are earning the highest salaries relative to their team's overall payroll? I need
--     player name, team name, and their salary compared to the team total to evaluate contract fairness.
--     (Author: Me)
-- A4: Uses the latest MTD salary snapshot and a window function to calculate each player's percentage
--     share of their team's total payroll, ranked highest share first.
SELECT
    p.pl_name AS PlayerName,
    t.t_code AS Team,
    f.mtd_salary AS PlayerSalary,
    SUM(f.mtd_salary) OVER (PARTITION BY t.t_code) AS TeamTotalSalary,
    CAST(f.mtd_salary AS FLOAT) / SUM(f.mtd_salary) OVER (PARTITION BY t.t_code) AS PctOfTeamPayroll
FROM tblPlayerFact f
JOIN tblPlayerDim p ON f.pl_id = p.pl_id
JOIN tblTeamDim t ON p.t_id = t.t_id
WHERE f.as_of_date = (SELECT MAX(as_of_date) FROM tblPlayerFact)
ORDER BY PctOfTeamPayroll DESC;
