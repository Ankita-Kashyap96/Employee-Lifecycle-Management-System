/*Ankita Amarnath Kashyap- Final Project|| Student ID: 02010214 */

/* Creating Database Infosys_Employee_Management */
DROP DATABASE IF EXISTS Infosys_Employee_Management;
CREATE DATABASE IF NOT EXISTS Infosys_Employee_Management;
USE Infosys_Employee_Management;

-- Creating tables 
/*Development Center Table*/
CREATE TABLE IF NOT EXISTS DevelopmentCenter ( 
DevelopmentCenterID		INT 		NOT NULL AUTO_INCREMENT,
DCName 					VARCHAR(25) NOT NULL,
Location				VARCHAR(45) NOT NULL,
NumberOfEmployees		INT 		NOT NULL,
AreaInSqYards			INT 		NOT NULL,
CONSTRAINT 		DC_PK			PRIMARY KEY(DevelopmentCenterID),
CONSTRAINT 		DC_UNIQUE		UNIQUE(DCName),
CONSTRAINT 		DC_EMPLOYEE		CHECK ( NumberOfEmployees > 0)
);

/*Unit Table*/
CREATE TABLE IF NOT EXISTS Unit ( 
UnitID					INT 		NOT NULL AUTO_INCREMENT,
UnitName 				VARCHAR(15) NOT NULL,
NumberOfUnitMembers		INT 		NOT NULL ,
NumberOfProjects		INT 		NOT NULL,
CONSTRAINT 				UNIT_PK			PRIMARY KEY(UnitID),
CONSTRAINT 				UNIT_UNIQUE		UNIQUE(UnitName)
);

/*Employee Table*/
CREATE TABLE IF NOT EXISTS Employee ( 
EmployeeID 				INT 		NOT NULL AUTO_INCREMENT,
FirstName 				VARCHAR(15) NOT NULL,
LastName 				VARCHAR(15) NOT NULL,
EmailID					VARCHAR(45) NOT NULL,
DateOfBirth				DATE 		NOT NULL,
Designation				VARCHAR(45) NOT NULL,
DateOfJoining 			DATE 		NOT NULL,
DevelopmentCenterID		INT 		NOT NULL,
UnitID					INT 		NOT NULL,
CONSTRAINT 		EMPLOYEE_PK			PRIMARY KEY(EmployeeID),
CONSTRAINT 		EMPLOYEE_UNIQUE		UNIQUE(FirstName, LastName),
/* This constraint is implemented using Triggers 
CONSTRAINT 		EMPLOYEE_BIRTH		CHECK ( DateOfBirth < DateOfJoining), */
CONSTRAINT 		EMPLOYEE_FK1		FOREIGN KEY(DevelopmentCenterID)
									REFERENCES DevelopmentCenter(DevelopmentCenterID)
									ON UPDATE CASCADE
									ON DELETE CASCADE ,
CONSTRAINT 		EMPLOYEE_FK2		FOREIGN KEY(UnitID)
									REFERENCES Unit(UnitID)
									ON UPDATE CASCADE
									ON DELETE CASCADE								
);

/*Project Table*/
CREATE TABLE IF NOT EXISTS Project ( 
ProjectCode 			VARCHAR(15) NOT NULL,
ProjectName				VARCHAR(25) NOT NULL,
NumberOfProjectMembers  INT         NOT NULL,
BillableAmountDollars	INT         NOT NULL,
ProfitDollars			INT         NOT NULL,
StartDate				DATE 		NOT NULL,
EndDate		 			DATE 		NULL,
UnitID					INT 		NOT NULL,
CONSTRAINT 		PROJECT_PK			PRIMARY KEY(ProjectCode),
CONSTRAINT 		PROJECT_UNIQUE		UNIQUE(ProjectName),
CONSTRAINT 		PROJECT_FK			FOREIGN KEY(UnitID)
									REFERENCES Unit(UnitID)
									ON UPDATE CASCADE
									ON DELETE CASCADE								
);

/*Activity Table*/
CREATE TABLE IF NOT EXISTS Activity ( 
ActivityID 				INT 		NOT NULL AUTO_INCREMENT,
ActivityName			VARCHAR(25) NOT NULL,
Category 				VARCHAR(15) NOT NULL,
NumberOfParticipants	INT 		NOT NULL,
Date					DATE 		NOT NULL,
DevelopmentCenterID		INT 		NOT NULL,
CONSTRAINT 		ACTIVITY_PK			PRIMARY KEY(ActivityID),
CONSTRAINT 		ACTIVITY_UNIQUE		UNIQUE(ActivityName),
CONSTRAINT 		ACTIVITY_FK1		FOREIGN KEY(DevelopmentCenterID)
									REFERENCES DevelopmentCenter(DevelopmentCenterID)
									ON UPDATE CASCADE
									ON DELETE CASCADE 							
);

-- INTERSECTION TABLES
/*Employee_has_Activity Table*/
CREATE TABLE IF NOT EXISTS Employee_has_Activity (
EmployeeID 				INT 		NOT NULL,
ActivityID 				INT 		NOT NULL,
CONSTRAINT 				EA_PK		PRIMARY KEY(EmployeeID, ActivityID),
CONSTRAINT 				EA_FK1		FOREIGN KEY(EmployeeID)
									REFERENCES Employee(EmployeeID)
									ON UPDATE CASCADE
									ON DELETE CASCADE,
CONSTRAINT 				EA_FK2		FOREIGN KEY(ActivityID)
									REFERENCES Activity(ActivityID)
									ON UPDATE CASCADE
									ON DELETE CASCADE
);

/*Employee_has_Project Table*/
CREATE TABLE IF NOT EXISTS Employee_has_Project (
EmployeeID 				INT 		NOT NULL,
ProjectCode 			VARCHAR(15) NOT NULL,
CONSTRAINT 				EP_PK		PRIMARY KEY(EmployeeID, ProjectCode),
CONSTRAINT 				EP_FK1		FOREIGN KEY(EmployeeID)
									REFERENCES Employee(EmployeeID)
									ON UPDATE CASCADE
									ON DELETE CASCADE,
CONSTRAINT 				EP_FK2		FOREIGN KEY(ProjectCode)
									REFERENCES Project(ProjectCode)
									ON UPDATE CASCADE
									ON DELETE CASCADE
);


-- INSERT statements
/* 1. Development Center Table*/
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Pune Phase 1 DC', 'Pune', '600', '400' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Pune Phase 2 DC', 'Pune', '700', '600' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Mumbai DC', 'Mumbai', '50', '100' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Hyderabad SEZ DC', 'Hyderabad', '1000', '1200' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Chandigadh DC', 'Chandigadh', '500', '300' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Bangalore DC', 'Bangalore', '800', '1000' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Chennai DC', 'Chennai', '800', '1000' );
INSERT INTO DevelopmentCenter(DCName, Location, NumberOfEmployees, AreaInSqYards)
VALUES('Mysore DC', 'Mysore', '400', '1500' );

/* 2. Unit Table*/
INSERT INTO Unit(UnitID, UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('1001', 'Java', '50', '10');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('C#', '50', '5');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('DotNet', '100', '4');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('SAP ABAP', '150', '4');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('SAP FICO', '100', '4');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('Python', '200', '5');
INSERT INTO Unit(UnitName, NumberOfUnitMembers, NumberOfProjects)
VALUES('Full Stack', '100', '5');

-- Trigger before insert
DROP TRIGGER IF EXISTS before_insert_employee;
DELIMITER //
CREATE TRIGGER before_insert_employee BEFORE INSERT
ON Employee
FOR EACH ROW
BEGIN 
	IF NEW.DateOfBirth > NEW.DateOfJoining 
    THEN
		SET NEW.EmailID = 'ERROR!! CHANGE DATE OF BIRTH OR JOINING';
	END IF;
END//
DELIMITER ;

/* 3. Employee Table*/
INSERT INTO Employee (EmployeeID, FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('1001000', 'Ankita', 'Kashyap', 'ankita.kashyap@infosys.com', '1996-03-25', 'Senior Systems Engineer', '2018-06-11', '2', '1004');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Nitin', 'Chintakayala', 'nitin.chintakayala@infosys.com', '1981-04-05', 'Team Lead', '2012-06-11', '4', '1005');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Megha', 'Biradar', 'megha.biradar@infosys.com', '1992-04-05', 'Technology Analyst', '2020-06-11', '5', '1001');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Subodh', 'Dongre', 'subodh.dongre@infosys.com', '1990-07-05', 'Technology Analyst', '2019-06-11', '1', '1002');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Kanchan', 'Maurya', 'kanchan.maurya@infosys.com', '1995-02-28', 'Systems Engineer', '2017-11-11', '2', '1007');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Lakshmi', 'Ashok', 'lakshmi.ashok@infosys.com', '1995-02-28', 'Technology Analyst', '2017-11-11', '2', '1003');
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Neha', 'Bhushan', 'neha.bhushan@infosys.com', '1997-01-23', 'Systems Engineer', '2020-11-11', '2', '1001');

-- Below data is inserted for triggering a Trigger Before Insert statement for designation
INSERT INTO Employee (FirstName, LastName, EmailID, DateOfBirth, Designation, DateOfJoining, DevelopmentCenterID, UnitID)
VALUES('Vidhi', 'Bhushan', 'vidhi.bhushan@infosys.com', '1997-01-23', 'Systems Engineer', '1995-11-11', '2', '1002');

/* 4. Project Table*/
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, UnitID)
VALUES('Mck1', 'ABC', '80', '60000000', '40000000', '2010-06-11', '1004');
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, EndDate, UnitID)
VALUES('Nv1', 'DEF', '50', '30000000', '10000000', '2010-06-11', '2025-06-11', '1005');
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, UnitID)
VALUES('CC1', 'GHI', '100', '80000000', '50000000', '2020-06-11', '1007');
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, UnitID)
VALUES('Lz1', 'JKL', '20', '2000000', '1000000', '2020-06-11', '1001');
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, UnitID)
VALUES('MNO1', 'MNO', '20', '2000000', '1000000', '2020-06-11', '1002');
INSERT INTO Project (ProjectCode, ProjectName, NumberOfProjectMembers, BillableAmountDollars, ProfitDollars, StartDate, UnitID)
VALUES('PQR1', 'PQR', '20', '2000000', '1000000', '2020-06-11', '1003');

/* 5. Activity Table*/
INSERT INTO Activity (ActivityID, ActivityName, Category, NumberOfParticipants, Date, DevelopmentCenterID)
VALUES('2000', 'Basketball', 'Tournament', '30', '2022-06-11', '8');
INSERT INTO Activity (ActivityName, Category, NumberOfParticipants, Date, DevelopmentCenterID)
VALUES('Bowling','FunGame', '6', '2022-05-25', '8');
INSERT INTO Activity (ActivityName, Category, NumberOfParticipants, Date, DevelopmentCenterID)
VALUES('Volleyball','Tournament', '30', '2022-08-20', '4');
INSERT INTO Activity (ActivityName, Category, NumberOfParticipants, Date, DevelopmentCenterID)
VALUES('CSR Mumbai','CSR Activity', '50', '2022-07-20', '3');
INSERT INTO Activity (ActivityName, Category, NumberOfParticipants, Date, DevelopmentCenterID)
VALUES('CSR Chandigadh','CSR Activity', '50', '2022-07-20', '5');

/* 6. Employee_has_Activity Table*/
INSERT INTO Employee_has_Activity(EmployeeID, ActivityID)
VALUES('1001000', '2001');
INSERT INTO Employee_has_Activity(EmployeeID, ActivityID)
VALUES('1001000', '2003');
INSERT INTO Employee_has_Activity(EmployeeID, ActivityID)
VALUES('1001001', '2004');
INSERT INTO Employee_has_Activity(EmployeeID, ActivityID)
VALUES('1001002', '2003');
INSERT INTO Employee_has_Activity(EmployeeID, ActivityID)
VALUES('1001004', '2002');

/* 7. Employee_has_Project Table*/
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001000', 'Mck1');
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001001', 'Nv1');
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001004', 'CC1');
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001002', 'Lz1');
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001003', 'MNO1');
INSERT INTO Employee_has_Project(EmployeeID, ProjectCode)
VALUES('1001005', 'PQR1');



-- Queries 
/* 1. Using Employee table, show EmployeeID, First Name, Last Name, EmailID of 
all the employees with designation 'Technology Analyst' */
/* This query helps to list employees based on their designation */
/* Stored Procedures with variables */
DROP PROCEDURE IF EXISTS GetTAEmployees;
DELIMITER //
CREATE PROCEDURE GetTAEmployees()
BEGIN
DECLARE post VARCHAR(45);
SET post = 'Technology Analyst';
SELECT EmployeeID, FirstName, LastName, EmailID FROM Employee
WHERE Designation = post;
END //
DELIMITER ;
CALL GetTAEmployees();

/* 2. Using Project table, list all the projects in decreasing order of their profit amounts. Also list their start and end dates */
/* This query helps Managers to track the profit earned by all the projects and to decide 
which project is most profitable and which one needs to be focused on, so that more profits can be earned */
SELECT ProjectCode, ProjectName, ProfitDollars, StartDate, EndDate
  FROM Project
ORDER BY ProfitDollars DESC;

/* 3. Using Project table, check the total Billable Amount in Dollars from all the projects */
/* This Query helps Managers to know the total Billable Amount from all the projects */
SELECT SUM(BillableAmountDollars) AS TotalBillableAmount
FROM Project;

/* 4. List all the activities taking place at Mysore DC */
/* This Query helps keep a track of activities taking place at different Locations */
SELECT ActivityID, ActivityName
FROM Activity
WHERE DevelopmentCenterID IN
							(SELECT DevelopmentCenterID
							FROM DevelopmentCenter
							WHERE DCName = 'Mysore DC');
                            
/* 5. List all the employees taking part in Activity named CSR Mumbai. Also list their following details 
EmployeeID, FirstName, LastName, EmailID, DateOfBirth, Designation */
/* This Query helps Managers to know which employees are taking part in a particular Activity */

SELECT EmployeeID, FirstName, LastName, EmailID, DateOfBirth, Designation
FROM Employee 
WHERE EmployeeID IN
					(SELECT EmployeeID 
					FROM Employee_has_Activity 
					WHERE ActivityID IN 
										(SELECT ActivityID 
										FROM Activity 
										WHERE ActivityName = 'CSR Mumbai'));
                                        
/* 6. Write a query to show the project name and project code for which Employee 'Ankita Kashyap' works */
/* This Query helps find out the project details for any particular employee */
SELECT ProjectName, ProjectCode FROM Project
   WHERE ProjectCode IN
				(SELECT ProjectCode FROM Employee_has_Project 
					WHERE EmployeeID IN 
										(SELECT EmployeeID FROM Employee
											WHERE FirstName = 'Ankita' AND LastName  = 'Kashyap'));
                                            
/* 7. List all the employees and all their details who belong to Unit named 'Java' */
/* This Query helps get data of all the employees belonging to a specific Unit */
SELECT EmployeeID, FirstName, LastName, EmailID, DateOfBirth, 
Designation, DateOfJoining, DevelopmentCenterID, UnitID
FROM Employee WHERE UnitID IN 
							(SELECT UnitID FROM Unit
							WHERE UnitName = 'Java');
                            



