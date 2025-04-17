Create Database Union_Bank;
Use Union_Bank;
Create Schema Borrower;
Create Schema Loan;

Create Table Borrower.Borrower
(
	BorrowerID int Not null,
	BorrowerFirstName Varchar (255) Not null,
	BorrowerMiddleInitial Char (1) Not null,
	BorrowerLastName Varchar (255) Not null, 
	DoB Datetime Not null,
	Gender Char (1) Null,
	TaxPayerID_SSN Varchar (9)  Not null,
	PhoneNumber Varchar (10) Not null,
	Email Varchar (255) Not null,
	Citizenship Varchar (255) Null,
	BeneficiaryName Varchar (255) Null,
	IsUScitizen bit Null, 
	CreateDate datetime Not null
); 

Create Table Borrower.BorrowerAddress
(
	AddressID int Not null, 
	BorrowerID int Not null,
	StreetAddress Varchar (255) Not null,
	ZIP Varchar (5) Not null,
	CreateDate datetime Not null,
);

Create Table Calendar 
(
	CalendarDate datetime Null
); 

Create Table State 
(
	StateID Char (2) Not null, 
	StateName Varchar (255) Not null,
	CreateDate datetime Not null
);

Create Table US_ZipCodes
(
	IsSurrogateKey int Not null, 
	ZIP Varchar (5) Not null,
	Latitude float Null,
	Longitude float Null,
	City Varchar (255) Null,
	State_id Char(2) Null, 
	Population int Null,
	Density decimal Null, 
	County_fips Varchar (10) Null,
	County_name Varchar (255) Null,
	County_names_all Varchar (255) Null,
	County_fips_all Varchar (50) Null, 
	Timezone Varchar (255) Null, 
	CreateDate datetime Not null
); 
Alter Table [dbo].[US_ZipCodes]
Alter column [Density] decimal (18,0) Null;

Create Table Loan.LoanSetupInfromation
(
	IsSurrogateKey int Not null, 
	LoanNumber Varchar (10) Not null, 
	PurchaseAmount numeric (18, 2) Not null, 
	PurchaseDate datetime Not null, 
	LoanTerm int not null, 
	BorrowerID int Not null, 
	UnderwriterID int Not null, 
	ProductID Char (2) Not null, 
	InterestRate decimal (3, 2) Not null,
	PaymentFrequency int Not null,
	AppraisalValue numeric (18, 2) Not null, 
	CreateDate datetime Not null,
	LTV decimal (4, 2) Not null,
	FirstInterestPaymentDate datetime Null,
	MaturityDate datetime Not null
	); 

Create Table Loanperiodic
( 
	Issurrogatekey int Not null, 
	LoanNumber Varchar (10) Not null, 
	Cycledate datetime Not null, 
	Extramonthlypayment numeric (18, 2) Not null, 
	Unpaidprincipalbalance numeric (18, 2) Not null, 
	Beginningschedulebalance numeric (18, 2) Not null, 
	Paidinstallment numeric (18, 2) Not null, 
	Interestportion numeric (18, 2) Not null, 
	Principalportion numeric (18, 2) Not null, 
	Endschedulebalance numeric (18,2) Not null, 
	Actualschedulebalance numeric (18, 2) Not null,
	Totalinterestaccrued numeric (18, 2) Not null, 
	Totalprincipalaccrued numeric (18, 2) Not null, 
	Defaultpenalty numeric (18, 2) Not null, 
	Delinquencycode int Not null, 
	CreateDate datetime Not null
	); 

Create Table LU_Delinquency
(
	DelinquencyCode int Not null, 
	Delinquency Varchar (255) Not null, 
	);

Create Table LU_PaymentFrequency
(
	PaymentFrequency int Not null,
	PaymentIsMadeEvery int Not null, 
	PaymentFrequency_Description Varchar (255) Not null
	);

Create Table Underwriter
(
	UnderwriterID int Not null, 
	UnderwriterFirstName Varchar (255) Null, 
	UnderwriterMiddleInitial Char (1) Null, 
	UnderwriterLastName Varchar (255) Not null, 
	PhoneNumber Varchar (14) Null, 
	Email Varchar (255) Not null, 
	CreateDate datetime Not null
	);

Alter Table [Borrower].[Borrower]
ADD Constraint Chk_Borrower_DoB Check ([DoB]<= DateAdd(Year, -18, GetDate()));

Alter Table [Borrower].[Borrower]
ADD Constraint chk_Borrower_email check (email like '%_@__%.__%');

Alter Table [Borrower].[Borrower]
ADD Constraint chk_Borrower_PhoneNumber check (Len(PhoneNumber) = 10);

Alter Table [Borrower].[Borrower]
ADD Constraint chk_Borrower_TaxPayerID_SSN check (Len([TaxPayerID_SSN]) = 9);

Alter Table [Borrower].[Borrower]
ADD Constraint PK_Borrower_BorrowerID Primary key (BorrowerID);

SELECT GETDATE()
Alter Table [Borrower].[Borrower]
ADD Constraint Df_Borrower_CreateDate Default GetDate() for [CreateDate]; 

Alter Table [BORROWER].[BORROWER]
ADD CONSTRAINT UC_BORROWER_BORROWERID UNIQUE (BORROWERID); 

Alter Table [Borrower].[BorrowerAddress]
ADD Constraint Df_BorrowerAddress_CreateDate Default GetDate() for [CreateDate] ; 

ALTER TABLE [Borrower].[BorrowerAddress]
ADD CONSTRAINT fk_BorrowerAddress_BorrowerID FOREIGN KEY(BorrowerID) REFERENCES [Borrower].[Borrower](BorrowerID);

--ADDRESSID AND BORROWER ID AS UNIQUE IDENTIFIER OF RECORD
ALTER TABLE [Borrower].[BorrowerAddress]
ADD CONSTRAINT UC_BorrowerAddress_AddressID_BorrowerID UNIQUE ([AddressID],[BorrowerID]);

--ZIP- RELATIONSHIP BETWEEN BORROWER.BORROWERADDRESS AND DBO.USZIPCODES
--FIRST CREATE A PRIMARY KEY ON ZIP COLUMN
ALTER TABLE [dbo].[US_ZipCodes]
ADD CONSTRAINT PK_DBO_USZipCodes Primary Key (ZIP);

ALTER TABLE [Borrower].[BorrowerAddress]
ADD CONSTRAINT fk_BorrowerAddress_ZIP Foreign Key(ZIP) REFERENCES [dbo].[US_ZipCodes](ZIP);

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT Chk_Loanperiodic_PaidInstallment Check([Interestportion] + [Principalportion] = [Paidinstallment]);

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT Df_Loanperiodic_Createdate Default GetDate() For [CreateDate];

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT Df_Loanperiodic_Extramonthlypayment Default 0 For [Extramonthlypayment];

ALTER TABLE [Loan].[LoanSetupInfromation]
ADD CONSTRAINT Pk_LoanSetupInformation_Loannumber Primary Key ([LoanNumber]);

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT fk_Loanperiodic_Loannumber Foreign Key (Loannumber) REFERENCES [Loan].[LoanSetupInfromation]([LoanNumber]);

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT Pk_Loanperiodic_Delinquencycode PRIMARY KEY ([Delinquencycode]);

ALTER TABLE [dbo].[Loanperiodic]
DROP CONSTRAINT Pk_Loanperiodic_Delinquencycode;

ALTER TABLE [dbo].[LU_Delinquency]
ADD CONSTRAINT PK_LU_Delinquency_Delinquencycode PRIMARY KEY ([DelinquencyCode]);

ALTER TABLE [dbo].[Loanperiodic]
ADD CONSTRAINT FK_LU_Delinquency_Delinquencycode FOREIGN KEY ([Delinquencycode]) REFERENCES [dbo].[LU_Delinquency]([DelinquencyCode]);