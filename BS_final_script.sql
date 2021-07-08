############################# BALANCE SHEET ###########################################

USE H_Accounting; # Using the Accounting data to create a balance sheet

DROP PROCEDURE `mtaggar2019_bs`;

DELIMITER $$

CREATE PROCEDURE  `mtaggar2019_bs` (varCalenderYear YEAR)
#Creating a procedure 

BEGIN 
SELECT 
    statement_section AS Statement,
    FORMAT(((IFNULL(SUM(debit),0)) - IFNULL(SUM(credit),0)),0) as Amount_$,
    YEAR(entry_date) AS Year_
    
FROM journal_entry_line_item as jel

JOIN `account`  ac  USING (account_id)
JOIN  statement_section ss ON ss.statement_section_id = ac.balance_sheet_section_id
JOIN  journal_entry  je USING(journal_entry_id)

WHERE is_balance_sheet_section = 1
   AND cancelled = 0
   AND debit_credit_balanced = 1
   AND YEAR(je.entry_date) = varCalenderYear
GROUP BY statement_section_order, Year_, statement_section_code, Statement
ORDER BY statement_section_order;
END $$

DELIMITER ;

CALL  mtaggar2019_bs (2015);