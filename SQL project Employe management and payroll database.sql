
-- Task 1: Database and Table Creation
CREATE DATABASE EmployeePayrollDB;

-- Use the database
USE EmployeePayrollDB;

-- Create Employees table
CREATE TABLE Employe (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,
    HireDate DATE ,
    Salary DECIMAL(10, 2) NOT NULL
);

-- Create Departments table
CREATE TABLE Departmen (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- Create Payroll table
CREATE TABLE Payro (
    PayrollID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayPeriod DATE NOT NULL,
    BasicSalary DECIMAL(10, 2) NOT NULL,
    Bonus DECIMAL(10, 2) DEFAULT 0.00,
    Deductions DECIMAL(10, 2) DEFAULT 0.00,
    NetSalary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Inserting Data into dep
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(1, 'HR', 'Pakistan'),
(2, 'IT', 'Saudi Arabia'),
(3, 'Finance', 'Dubai');

select *from Departmen;

INSERT INTO Employe (EmployeeID, FirstName, LastName, DateOfBirth, Email, DepartmentID, HireDate, Salary) VALUES
(101, 'Nayab', 'Munir', '1985-06-15', 'nayab.munir@example.com', 1, '2010-03-01', 5000.00),
(102, 'Hira', 'Khan', '1990-07-20', 'hira.shahid@example.com', 2, '2012-05-15', 7000.00),
(103, 'Amara', 'Shakoor', '1988-09-10', 'amara.shakoor@example.com', 2, '2015-09-01', 6500.00),
(104, 'Saba', 'Zafar', '1992-11-25', 'saba.zafar@example.com', 3, '2018-01-10', 5500.00),
(105, 'Nadia', 'Najeeb', '1995-03-05', 'nadia.najeeb@example.com', 1, '2020-06-20', 4800.00);
select*from Employe;


INSERT INTO Payro (PayrollID, EmployeeID, PayPeriod, BasicSalary, Bonus, Deductions, NetSalary)
VALUES 
(1, 101, '2025-01-01', 5000.00, 500.00, 200.00, 5300.00),
(2, 101, '2025-01-15', 5000.00, 400.00, 100.00, 5300.00),
(3, 102, '2025-01-01', 7000.00, 700.00, 300.00, 7400.00),
(4, 102, '2025-01-15', 7000.00, 600.00, 200.00, 7400.00),
(5, 103, '2025-01-01', 6500.00, 600.00, 250.00, 6850.00),
(6, 103, '2025-01-15', 6500.00, 500.00, 150.00, 6850.00);


--Select Data from Payro Table

SELECT * FROM Payro;
-- Task 3: Data Updates and Deletions 
UPDATE Employe SET Salary = 8500.00 WHERE EmployeeID = 102;
select *from Employe;

DELETE FROM Payro WHERE EmployeeID = 102;
DELETE FROM Employe WHERE EmployeeID = 103;
select *from Payro;
select *from Employe;
select * from departmen;
UPDATE Employe SET DepartmentID = 2 WHERE EmployeeID = 101;
select *from Employe;

--Task 4: Querying Data
SELECT * FROM Employe WHERE DepartmentID = 2;

SELECT e.Salary, p.Bonus  FROM Employe e JOIN Payro p ON e.EmployeeID = p.EmployeeID;


SELECT * FROM Employe WHERE Salary > 5000.00;


--Task 5: Aggregate Functions and Grouping

SELECT d.DepartmentName, SUM(e.Salary) AS TotalSalaryExpense
FROM Employe e
JOIN Departmen d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

SELECT d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM Employe e
JOIN Departmen d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

SELECT d.DepartmentName, COUNT(e.EmployeeID) AS NumberOfEmployees
FROM Employe e
JOIN Departmen d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
---Task 6: Joins and Relationships
SELECT e.FirstName, e.LastName, d.DepartmentName, e.Salary
FROM Employe e
INNER JOIN Departmen d ON e.DepartmentID = d.DepartmentID;



SELECT e.FirstName, e.LastName,p.BasicSalary
FROM Employe e
LEFT JOIN Payro p ON e.EmployeeID = p.EmployeeID;



SELECT d.DepartmentName, e.FirstName, e.LastName
FROM Departmen d
RIGHT JOIN Employe e ON d.DepartmentID = e.DepartmentID;


--Task 7: Advanced SQL Functions
CREATE PROCEDURE CalculateNetSalary  @empID INT  
AS
BEGIN
    SELECT EmployeeID, BasicSalary, Bonus, Deductions, 
           (BasicSalary + Bonus - Deductions) AS NetSalary
    FROM Payroll 
    WHERE EmployeeID = @empID;
END;
exec CalculateNetSalary @empid=1;


-- Using CASE 
SELECT FirstName, LastName, Salary,
    CASE 
        WHEN Salary < 5000 THEN 'Low Salary'
        WHEN Salary >5000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS SalaryCategory
FROM Employe;

-- Use EXISTS 
SELECT EmployeeID, FirstName, LastName
FROM Employe e
WHERE EXISTS (SELECT *FROM Payro where Bonus >0);

--Task 8: View Creation and Reporting
-- Create a view
CREATE VIEW EmployePayview AS
SELECT e.FirstName, e.LastName, d.DepartmentName, p.PayPeriod, p.NetSalary
FROM Employe e
JOIN Departmen d ON e.DepartmentID = d.DepartmentID
JOIN Payro p ON e.EmployeeID = p.EmployeeID;

-- Query the view to generate a report
SELECT * FROM EmployePayview
ORDER BY Departmentname;
