/*****************************************************************************************************************
NAME: EC_IT143_W5.2_Simpsons_vj.sql
PURPOSE: Answer four My Communities questions about the Simpsons (family employment & credit card spending)
         data set by translating each natural-language business question into a T-SQL SELECT statement.

MODIFICATION LOG:
Ver     Date            Author          Description
1.0     08/13/2026      VJ              1. Built this script for EC IT143 W5.2 assignment

RUNTIME: <1s

NOTES: This script answers 4 questions about the Simpsons database, covering credit card spending by job
       title/department, Planet Express spending by category, combined spending across both accounts, and
       whether department correlates with credit card spending. Questions 1-2 (Q5-Q6 overall) were authored
       by me (Victor James); Questions 3-4 (Q7-Q8 overall) were authored by another classmate.
******************************************************************************************************************/

-- Q1: How much has each employed family member spent on their credit card compared to their job title and
--     department? I want member name, department, job title, and total debit amount to review household
--     spending by role. (Author: Me)
-- A1: Joins the family roster to the FBS Viza Costmo credit card table on member name, then totals debit
--     charges per person alongside their department and job title.
SELECT
    fd.Name AS MemberName,
    fd.Department,
    fd.Job_Title,
    SUM(cc.Debit) AS TotalDebitAmount
FROM Family_Data fd
JOIN FBS_Viza_Costmo cc ON fd.Name = cc.Member_Name
GROUP BY fd.Name, fd.Department, fd.Job_Title
ORDER BY TotalDebitAmount DESC;


-- Q2: Which family members have the highest total charges on the Planet Express account, and what
--     categories are they spending in most? I need card member name, category, and amount to identify
--     spending patterns worth budgeting around. (Author: Me)
-- A2: Groups Planet Express charges by card member and category, summing the amount so the biggest
--     spending patterns per person/category surface at the top.
SELECT
    pe.Card_Member,
    pe.Category,
    SUM(pe.Amount) AS TotalAmount
FROM Planet_Express pe
GROUP BY pe.Card_Member, pe.Category
ORDER BY pe.Card_Member, TotalAmount DESC;


-- Q3: Across both the credit card and Planet Express accounts, which family members have the highest
--     combined total spending? I want member name, job title, and combined debit/amount totals to see
--     who is driving most of the household expenses. (Author: Another classmate)
-- A3: Combines totals from both spending sources (FBS Viza Costmo debits and Planet Express amounts) using
--     a UNION ALL, then joins to Family_Data to add job title and produce one combined ranked total per person.
;WITH CombinedSpend AS (
    SELECT Member_Name AS MemberName, SUM(Debit) AS TotalAmount
    FROM FBS_Viza_Costmo
    GROUP BY Member_Name
    UNION ALL
    SELECT Card_Member AS MemberName, SUM(Amount) AS TotalAmount
    FROM Planet_Express
    GROUP BY Card_Member
)
SELECT
    fd.Name AS MemberName,
    fd.Job_Title,
    SUM(cs.TotalAmount) AS CombinedTotalSpending
FROM CombinedSpend cs
JOIN Family_Data fd ON fd.Name = cs.MemberName
GROUP BY fd.Name, fd.Job_Title
ORDER BY CombinedTotalSpending DESC;


-- Q4: Is there a relationship between an employee's department and how much they've charged on the
--     family's credit card? I need department, member name, and total debit amount to see if job-related
--     spending patterns differ across departments. (Author: Another classmate)
-- A4: Joins Family_Data to the credit card table and totals debit charges per member, grouped and sorted
--     by department so spending patterns across departments can be visually compared.
SELECT
    fd.Department,
    fd.Name AS MemberName,
    SUM(cc.Debit) AS TotalDebitAmount
FROM Family_Data fd
JOIN FBS_Viza_Costmo cc ON fd.Name = cc.Member_Name
GROUP BY fd.Department, fd.Name
ORDER BY fd.Department, TotalDebitAmount DESC;
