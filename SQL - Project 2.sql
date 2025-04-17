CREATE SCHEMA skyBarrel
DROP SCHEMA skyBarrel
CREATE SCHEMA SKYBARREL
-----CREATE EMPLOYEES TABLE
CREATE TABLE SKYBARREL.EMPLOYEES
(
	Employee_id Int Not Null,
	First_Name Varchar (50) Not Null,
	Last_Name Varchar (50) Not Null,
	Department_id Int Not Null,
	Position Varchar (50) Not Null,
	Salary Decimal (10, 2) Not Null
);
--ADD EMPLOYEEID AS PRIMARY KEY
ALTER TABLE [SKYBARREL].[EMPLOYEES]
ADD CONSTRAINT PK_Employee_id PRIMARY KEY ([Employee_id]);

--CREATE DEPARTMENTS TABLE
CREATE TABLE SKYBARREL.DEPARTMENTS
(
	Department_id Int Not Null, 
	Department_Name Varchar (50) Not Null
	);

--DEPARTMENTID AS PRIMARY KEY (UNIQUE IDENTIFIER FOR EACH DEPARTMENT)
ALTER TABLE [SKYBARREL].[DEPARTMENTS]
ADD CONSTRAINT PK_Department_id PRIMARY KEY ([Department_id]);

--DEPARTMENTID AS FOREIGN KEY IN EMPLOYEES TABLE REFERNCING DEPARTMENTS TABLE
ALTER TABLE [SKYBARREL].[EMPLOYEES]
ADD CONSTRAINT FK_Employees_Department_id FOREIGN KEY ([Department_id]) REFERENCES [SKYBARREL].[DEPARTMENTS] ([Department_id]); 

--CREATE INVESTMENTS TABLE 
CREATE TABLE SKYBARREL.INVESTMENTS
(
	Investment_id Int Not Null, 
	Investment_Name Varchar (100) Not Null,
	Investment_Type Varchar (50) Not Null,
	Department_id Int Not Null,
	AmountInvested Decimal (15, 2) Not Null,
	StartDate Date Not Null
	);

ALTER TABLE [SKYBARREL].[INVESTMENTS]
ADD CONSTRAINT PK_Investment_id PRIMARY KEY ([Investment_id]); 

ALTER TABLE [SKYBARREL].[INVESTMENTS]
ADD CONSTRAINT FK_Investments_Department_id FOREIGN KEY ([Department_id]) REFERENCES [SKYBARREL].[DEPARTMENTS] ([Department_id]);

--POPULATE DATA INTO DEPARTMENTS TABLE
INSERT INTO [SKYBARREL].[DEPARTMENTS]
			([Department_id], [Department_Name])
		VALUES ( '1',  'Marketing'),
			   ( '2',  'Finance'),
			   ( '3',  'Engineering'),
			   ( '4',  'Risk Management'),
			   ( '5',  'Sales');

--POPULATE DATA INTO EMPLOYEES TABLE 		
INSERT INTO [SKYBARREL].[EMPLOYEES]
	([Employee_id], [First_Name], [Last_Name], [Department_id], [Position], [Salary])
VALUES 
	('1', 'John', 'Doe', '1', 'Marketing Manager', '120000.00'),
	('2', 'Jane', 'Smith', '2', 'Financial Analyst', '95000.00'),
	('3', 'Robert', 'Johnson', '3', 'Software Engineer', '105000.00'),
	('4', 'Emily', 'Davis', '1', 'Senior Marketing Strategist', '88000.00'),
	('5', 'Michael', 'Brown', '4', 'Risk Analyst', '85000.00'), 
	('6', 'Sarah', 'Wilson', '2', 'Senior Accountant', '115000.00'),
	('7', 'David', 'Lee', '3', 'Systems Architect', '125000.00'), 
	('8', 'Rachael', 'Kim', '5', 'Sales Manager', '110000.00'),
	('9', 'Daniel', 'Green', '2', 'Investment Manager', '130000.00'), 
	('10', 'Alex', 'Baker', '4', 'Risk Management Consultant', '94000.00');

--POPULATE DATA INTO INVESTMENTS TABLE
INSERT INTO [SKYBARREL].[INVESTMENTS]
	([Investment_id], [Investment_Name], [Investment_Type], [Department_id], [AmountInvested], [StartDate])

VALUES 
	('1', 'SkyFund Alpha', 'Equity', '1', '2000000.00', '2025-01-10'), 
	('2', 'SkyFund Beta', 'Bond', '2', '1500000.00', '2025-02-01'),
	('3', 'SkyFund Delta', 'Real Estate', '3', '3000000.00', '2025-03-01'),
	('4', 'SkyFund Omega', 'Stock', '4', '500000.00', '2025-01-20'),
	('5', 'SkyFund Gamma', 'Real Estate', '2', '1200000.00', '2025-04-15'),
	('6', 'SkyFund Zeta', 'Bond', '3', '2500000.00', '2025-02-28'), 
	('7', 'SkyFund Theta', 'Equity', '1', '3500000.00', '2025-03-10'),
	('8', 'SkyFund Kappa', 'Real Estate', '4', '800000.00', '2025-04-05'),
	('9', 'SkyFund Iota', 'Stock', '5', '2000000.00', '2025-05-01'); 

SELECT * FROM [SKYBARREL].[EMPLOYEES]

--SALARY ADJUSTMENT: 15% SALARY INCREASE FOR ALL EQUITY DEPARTMENT EMPLOYEES WITH SALARY BELOW 100,0000
--FIRST WROTE A SELECT STATEMENT TO RETURN EMPLOYEES IN THE EQUITY DEPARTMENT WHOSE SALARY ARE BELOW $100,000
SELECT SE.Department_id, Employee_Name = CONCAT_WS(' ',SE.First_Name, SE.Last_Name), 
	SI.Investment_Name, 
	SI.Investment_Type,
	SE.SALARY
	FROM [SKYBARREL].[EMPLOYEES] AS SE
	JOIN [SKYBARREL].[INVESTMENTS] AS SI
	ON SE.[Employee_id]= SI.[Department_id]
	WHERE SI.[Investment_Type] = 'EQUITY'
	AND SE.SALARY < $100000;

--UPDATE STATEMENT
UPDATE SE
SET SE.Salary = SE.Salary * 1.15
FROM [SKYBARREL].[EMPLOYEES] AS SE
	JOIN [SKYBARREL].[INVESTMENTS] AS SI
	ON SE.[Employee_id]= SI.[Department_id]
	WHERE SI.[Investment_Type] = 'EQUITY'
	AND SE.SALARY < $100000;

--DEPARTMENT CHANGE FOR EMPLOYEEID 4 FROM MARKETING TO ENGINEERING
UPDATE [SKYBARREL].[EMPLOYEES]
SET [Department_id] = '3'
WHERE [Employee_id] = 4 AND [Department_id] = 1;

SELECT * FROM [SKYBARREL].[EMPLOYEES]

--10% PERFORMANCE BONUS FOR EMPLOYEES OF RISK MANAGEMENT DEPARTMENT 
--1.  ADD A NEW COLUMN TO THE TABLE TO STORE THE BONUS
ALTER TABLE [SKYBARREL].[EMPLOYEES]
ADD BONUS DECIMAL(10,2);

--2. UPDATE THE BONUS AMOUNT
UPDATE [SKYBARREL].[EMPLOYEES]
SET BONUS = SALARY * 1.10
WHERE [Department_id] = 4;

SELECT * FROM [SKYBARREL].[EMPLOYEES]

--SALARY CORRECTION FOR EMPLOYEEID 6.
UPDATE [SKYBARREL].[EMPLOYEES]
SET SALARY = 60000
WHERE [Employee_id] = 6;

--INSERT NEW EMPLOYEE RECORD FOR JOHN THOMPSON 
INSERT INTO [SKYBARREL].[EMPLOYEES] 
			([Employee_id], [First_Name], [Last_Name],[Department_id],[Position], [Salary])
VALUES		('11', 'John', 'Thompson', '1', 'Senior Marketing Strategist', '95000.00');


--INSERT NEW INVESTMENT- SKYFUNDX
INSERT INTO [SKYBARREL].[INVESTMENTS]
			([Investment_id], [Investment_Name], [Investment_Type], [Department_id], [AmountInvested], [StartDate])
VALUES 
			('10', 'SkyFund X', 'Real Estate', '3', '2000000.00', '2025-02-15');
SELECT * FROM [SKYBARREL].[INVESTMENTS]

---ADD NEW EMPLOYEES TO EMPLOYEE TABLE
SELECT * FROM [SKYBARREL].[EMPLOYEES]
INSERT INTO [SKYBARREL].[EMPLOYEES]
	([Employee_id], [First_Name], [Last_Name], [Department_id], [Position], [Salary])
VALUES 
	('12', 'Alex', 'Baker', '2', ' ', '70000.00'),
	('13', 'Rachel', 'Kim', '2', ' ', '85000.00'),
	('14', 'Daniel', 'Green', '2', ' ', '90000.00');



---ADD NEW INVESTMENTS TO INVESTMENTS TABLE- SKYFUNDY, SKYFUNDZ, SKYFUNDW
INSERT INTO [SKYBARREL].[INVESTMENTS]
	([Investment_id], [Investment_Name], [Investment_Type], [Department_id], [AmountInvested], [StartDate])
VALUES 
	('11', 'SkyFund Y', 'Bond', '2', '1500000.00', '2025-03-01'),
	('12', 'SkyFund Z', 'Stock', '1', '800000.00', '2025-03-15'),
	('13', 'SkyFund W', 'Real Estate', '4', '3000000.00', '2025-04-01');
SELECT * FROM [SKYBARREL].[INVESTMENTS]

-- DELETE EMPLOYEE WITH EMPLOYEEID 10
DELETE FROM [SKYBARREL].[EMPLOYEES]
WHERE [Employee_id] = 10

---DELETE SALES DEPARTMENT (DEPARTMENTID 5)
-- 1. VERIFY THE DATA
--SELECT STATEMENT TO RETURN INVESTMENTS IN DEPARTMENTID 5
SELECT * FROM [SKYBARREL].[INVESTMENTS]
WHERE [Department_id] = 5;

---SELECT STATEMENT TO RETURN EMPLOYEES IN DEPARTMENTID 5
SELECT * FROM [SKYBARREL].[EMPLOYEES]
WHERE [Department_id] = 5;

----BEFORE WE DELETE DEPARTMENTID 5 FROM OUR DATABASE, WE NEED TO MAKE SURE THAT THE DATA OF EMPLOYEES IN DEPARTMENTID 5 WON'T BE DELETED TOO
 
--DROP FOREIGN KEY REFERENCING DEPARTMENTS TABLE AND EMPLOYEE TABLE
ALTER TABLE [SKYBARREL].[EMPLOYEES] 
DROP CONSTRAINT [FK_Employees_Department_id];

--ALTER DEPARTMENTID COLUMN IN THE EMPLOYEES TABLE TO TAKE NULL VALUES
ALTER TABLE [SKYBARREL].[EMPLOYEES]
ALTER COLUMN [Department_id] INT NULL;


