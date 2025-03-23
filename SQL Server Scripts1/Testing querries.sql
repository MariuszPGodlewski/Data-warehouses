------------------------------------------
-- Basic Queries
------------------------------------------
-- Get all people
USE RealEstate;

SELECT * FROM Person;

-- Get all employees (with Person info joined)
SELECT E.EmployeeID,
       P.[Name],
       P.Surname,
       E.Position,
       E.Salary
FROM Employee AS E
JOIN Person AS P
  ON E.FK_Person = P.PersonID;

-- Get all properties
SELECT * FROM Property;

-- Get all sales
SELECT * FROM PropertySale;

-- Get all acquisitions
SELECT * FROM PropertyAcquisition;


------------------------------------------
-- More Advanced Joins
------------------------------------------
-- Show each sale with property address and salesman name
SELECT PS.SaleID,
       PS.SalePrice,
       PS.SaleDate,
       PR.Address AS PropertyAddress,
       P.[Name] + ' ' + P.Surname AS SalesmanName
FROM PropertySale AS PS
JOIN Property AS PR
  ON PS.FK_Property = PR.PropertyID
JOIN Employee AS E
  ON PS.FK_EmployeeID = E.EmployeeID
JOIN Person AS P
  ON E.FK_Person = P.PersonID;

-- Show each acquisition with property address and employee name
SELECT PA.BoughtID,
       PA.BuyingPrice,
       PA.BuyingDate,
       PR.Address AS PropertyAddress,
       P.[Name] + ' ' + P.Surname AS SalesmanName
FROM PropertyAcquisition AS PA
JOIN Property AS PR
  ON PA.FK_Property = PR.PropertyID
JOIN Employee AS E
  ON PA.FK_EmployeeID = E.EmployeeID
JOIN Person AS P
  ON E.FK_Person = P.PersonID;
GO
