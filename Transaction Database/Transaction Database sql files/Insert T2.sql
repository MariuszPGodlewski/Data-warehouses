USE RealEstate;
GO

----------------
-- PERSON --
----------------
IF OBJECT_ID('TempPerson') IS NOT NULL
    DROP TABLE TempPerson;

CREATE TABLE TempPerson (
    PersonID        INT PRIMARY KEY,
    [Name]          VARCHAR(30),
    Surname         VARCHAR(30),
    ContactNumber   VARCHAR(15),
    Email           VARCHAR(50),
    Address         VARCHAR(200)
);

BULK INSERT TempPerson
FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\T2_person.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

INSERT INTO Person (PersonID, [Name], Surname, ContactNumber, Email, Address)
SELECT TP.PersonID, TP.[Name], TP.Surname, TP.ContactNumber, TP.Email, TP.Address
FROM TempPerson TP
LEFT JOIN Person P ON TP.PersonID = P.PersonID
WHERE P.PersonID IS NULL;

SELECT * FROM Person;

DROP TABLE TempPerson;
GO

----------------
-- EMPLOYEE --
----------------
IF OBJECT_ID('TempEmployee') IS NOT NULL
    DROP TABLE TempEmployee;

CREATE TABLE TempEmployee (
    EmployeeID  INT PRIMARY KEY,
    FK_Person   INT,
    Position    VARCHAR(50),
    Salary      DECIMAL(10,2)
);

BULK INSERT TempEmployee
FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\T2_employees.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

INSERT INTO Employee (EmployeeID, FK_Person, Position, Salary)
SELECT TE.EmployeeID, TE.FK_Person, TE.Position, TE.Salary
FROM TempEmployee TE
LEFT JOIN Employee E ON TE.EmployeeID = E.EmployeeID
WHERE E.EmployeeID IS NULL;

SELECT * FROM Employee;

DROP TABLE TempEmployee;
GO

----------------
-- PROPERTY --
----------------
IF OBJECT_ID('TempProperty') IS NOT NULL
    DROP TABLE TempProperty;

CREATE TABLE TempProperty (
    PropertyID  INT PRIMARY KEY,
    Amenities   VARCHAR(1000),
    Address     VARCHAR(100),
    District    VARCHAR(20),
    [Type]      VARCHAR(20),
    size        INT,
    Price       DECIMAL(10,2)
);

BULK INSERT TempProperty
FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\T2_property.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

UPDATE P
SET 
    P.Amenities = TP.Amenities,
    P.Address = TP.Address,
    P.District = TP.District,
    P.[Type] = TP.[Type],
    P.size = TP.size,
    P.Price = TP.Price
FROM Property P
INNER JOIN TempProperty TP ON P.PropertyID = TP.PropertyID
WHERE 
    (ISNULL(P.Amenities, '') <> ISNULL(TP.Amenities, '')) OR
    (ISNULL(P.Address, '') <> ISNULL(TP.Address, '')) OR
    (ISNULL(P.District, '') <> ISNULL(TP.District, '')) OR
    (ISNULL(P.[Type], '') <> ISNULL(TP.[Type], '')) OR
    (ISNULL(P.size, 0) <> ISNULL(TP.size, 0)) OR
    (ISNULL(P.Price, 0.00) <> ISNULL(TP.Price, 0.00));

-- Insert new rows that don't exist
INSERT INTO Property (PropertyID, Amenities, Address, District, [Type], size, Price)
SELECT TP.PropertyID, TP.Amenities, TP.Address, TP.District, TP.[Type], TP.size, TP.Price
FROM TempProperty TP
LEFT JOIN Property P ON TP.PropertyID = P.PropertyID
WHERE P.PropertyID IS NULL;

-- Clean up
DROP TABLE TempProperty;
GO

SELECT * FROM Property
-----------------------
-- PROPERTY SALE --
-----------------------
IF OBJECT_ID('TempPropertySale') IS NOT NULL
    DROP TABLE TempPropertySale;

CREATE TABLE TempPropertySale (
    SaleID          INT PRIMARY KEY,
    FK_Property     INT,
    FK_Person       INT,
    FK_EmployeeID   INT,
    SalePrice       DECIMAL(10,2),
    SaleDate        DATE
);

BULK INSERT TempPropertySale
FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\T2_sale.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

INSERT INTO PropertySale (SaleID, FK_Property, FK_Person, FK_EmployeeID, SalePrice, SaleDate)
SELECT TS.SaleID, TS.FK_Property, TS.FK_Person, TS.FK_EmployeeID, TS.SalePrice, TS.SaleDate
FROM TempPropertySale TS
LEFT JOIN PropertySale PS ON TS.SaleID = PS.SaleID
WHERE PS.SaleID IS NULL;

SELECT * FROM PropertySale;

DROP TABLE TempPropertySale;
GO

-----------------------------
-- PROPERTY ACQUISITION --
-----------------------------
IF OBJECT_ID('TempPropertyAcquisition') IS NOT NULL
    DROP TABLE TempPropertyAcquisition;

CREATE TABLE TempPropertyAcquisition (
    BoughtID        INT PRIMARY KEY,
    FK_Property     INT,
    FK_Person       INT,
    FK_EmployeeID   INT,
    BuyingPrice     DECIMAL(10,2),
    BuyingDate      DATE
);

BULK INSERT TempPropertyAcquisition
FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\T2_acquisitions.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

INSERT INTO PropertyAcquisition (BoughtID, FK_Property, FK_Person, FK_EmployeeID, BuyingPrice, BuyingDate)
SELECT TPA.BoughtID, TPA.FK_Property, TPA.FK_Person, TPA.FK_EmployeeID, TPA.BuyingPrice, TPA.BuyingDate
FROM TempPropertyAcquisition TPA
LEFT JOIN PropertyAcquisition PA ON TPA.BoughtID = PA.BoughtID
WHERE PA.BoughtID IS NULL;

SELECT * FROM PropertyAcquisition;

DROP TABLE TempPropertyAcquisition;
GO
