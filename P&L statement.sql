# Team- 9 ( Profit & Loss Statement)
# H_Accounting database
USE H_Accounting;

#Dropping stored procedure 
DROP PROCEDURE IF EXISTS `garchaudhary2019_sp`;

#Creating  stored procedure
DELIMITER $$
CREATE PROCEDURE `garchaudhary2019_sp`(varCalendarYear YEAR)
BEGIN
    
    # declarations
    DECLARE varTotalRevenues DOUBLE DEFAULT 0;#Total Revenue
    DECLARE varCOGS DOUBLE DEFAULT 0;#Cost of Goods Sold
    DECLARE varGrossProfit DOUBLE DEFAULT 0;#Gross Profit
    DECLARE varGEXP DOUBLE DEFAULT 0;#Administrative Expenses
    DECLARE varSEXP DOUBLE DEFAULT 0;#Selling Expenses
    DECLARE varOEXP DOUBLE DEFAULT 0;#Other Expenses
    DECLARE varOPINC DOUBLE DEFAULT 0;#Operating Income
    DECLARE varOI DOUBLE DEFAULT 0;#Other Income
	DECLARE varRET DOUBLE DEFAULT 0;#Non-recurring Expenses
    DECLARE varEBIT DOUBLE DEFAULT 0;#Earnings before tax
    DECLARE varINCTAX DOUBLE DEFAULT 0;#Income Tax
    DECLARE varOTHTAX DOUBLE DEFAULT 0;#Other Taxes
	DECLARE varNETINC DOUBLE DEFAULT 0;#Net Income
   

    
    #Calculating Revenue
    SELECT SUM(jeli.credit) INTO varTotalRevenues
	FROM journal_entry_line_item AS jeli
	INNER JOIN account 						AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry 			AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "REV"
	AND YEAR(je.entry_date) = varCalendarYear;
    
	
    #calculating COGS
	SELECT SUM(jeli.debit) INTO varCOGS
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "COGS"
	AND YEAR(je.entry_date) = varCalendarYear;
    
    #calculating Administrative expense
    SELECT SUM(jeli.debit) INTO varGEXP
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "GEXP"
	AND YEAR(je.entry_date) = varCalendarYear;
    
   
    #calculating Selling expense
    SELECT SUM(jeli.debit) INTO varSEXP
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "SEXP"
	AND YEAR(je.entry_date) = varCalendarYear;
    
    
    #calculating other expense
    SELECT SUM(jeli.debit) INTO varOEXP
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OEXP"
	AND YEAR(je.entry_date) = varCalendarYear;
    
    
    #calculating income tax expense
    SELECT SUM(jeli.debit) INTO varINCTAX
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "INCTAX"
	AND YEAR(je.entry_date) = varCalendarYear;
    
    
    #calculating other taxes expense
    SELECT SUM(jeli.debit) INTO varOTHTAX
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OTHTAX"
	AND YEAR(je.entry_date) = varCalendarYear;
    
   
    #calculating non-recurring expenses
    SELECT SUM(jeli.debit) INTO varRET
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "RET"
	AND YEAR(je.entry_date) = varCalendarYear;
    
    
    #calculating other incomes
    SELECT SUM(jeli.credit) INTO varOI
	FROM journal_entry_line_item AS jeli
	INNER JOIN account AS ac ON ac.account_id = jeli.account_id
	INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OI"
	AND YEAR(je.entry_date) = varCalendarYear;
    
	#Dropping a table in case it already exists 
	DROP TABLE IF EXISTS tmp_garchaudhary2019_table;
  
	# Creating table with the columns that we need
	CREATE TABLE tmp_garchaudhary2019_table
		( profit_loss_line_number INT, 
		label VARCHAR(50), 
		amount VARCHAR(50)
		);
	
	#inserting the a header for the report
	INSERT INTO tmp_garchaudhary2019_table 
	 (profit_loss_line_number, label, amount)
	 VALUES (1, 'PROFIT AND LOSS STATEMENT', "In '000s of USD");
  
	#creating some space between the header and the line items
	INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (2, '', '');
    
	#inserting the values
	INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (3, 'Total Revenues', format(IFNULL(varTotalRevenues,0) / 1000, 2));
	
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (4, 'COGS', format(IFNULL(varCOGS, 0) / 1000, 2));
    
    
    SET varGrossProfit := (IFNULL(varTotalRevenues,0) - IFNULL(varCOGS, 0));
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (5, 'Gross Profit', format( IFNULL(varGrossProfit,0) / 1000, 2));
    
   INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (6, 'Administrative Expense', format( (IFNULL(varGEXP, 0)) / 1000, 2));
    
   INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (7, 'Selling Expense', format( IFNULL(varSEXP, 0) / 1000, 2));
    
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (8, 'Other Expense', format( IFNULL(varOEXP, 0) / 1000, 2));
    
    SET varOPINC := IFNULL(varGrossProfit,0) - (IFNULL(varGEXP, 0) + IFNULL(varSEXP,0) + IFNULL(varOEXP,0));
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (9, 'Operating Income', format( IFNULL(varOPINC, 0) / 1000, 2));
   
   INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (10, 'Other Income', format( IFNULL(varOI, 0) / 1000, 2));
    
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (11, 'Non Recurring Expenses', format( (IFNULL(varRET, 0)) / 1000, 2));
    
    SET varEBIT := (IFNULL(varOPINC,0) + IFNULL(varOI,0)) - IFNULL(varRET, 0);
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (12, 'EBIT', format( IFNULL(varEBIT, 0) / 1000, 2));
    
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (13, 'Income Tax Expense', format( (IFNULL(varINCTAX, 0)) / 1000, 2));
    
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (14, 'Other Taxes Expense', format( (IFNULL(varOTHTAX, 0)) / 1000, 2));
    
    SET varNETINC := IFNULL(varEBIT,0) - (IFNULL(varINCTAX,0) + IFNULL(varOTHTAX, 0));
    INSERT INTO tmp_garchaudhary2019_table 
	(profit_loss_line_number, label, amount)
	VALUES (15, 'Net Income', format( (IFNULL(varNETINC,0)) / 1000, 2));
    
END $$
DELIMITER ;
#End 

#Call the store procedure by running the code
#Change year to see the different years P&l statements
CALL `garchaudhary2019_sp` (2019);

#Run the code under to obtain the P&L for the selected year above:
SELECT * FROM tmp_garchaudhary2019_table; 