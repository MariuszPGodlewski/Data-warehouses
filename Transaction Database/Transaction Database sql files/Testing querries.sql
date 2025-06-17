
USE RealEstate;

SELECT * FROM Property;

SELECT E.EmployeeID,
       P.[Name],
       P.Surname,
       E.Position,
       E.Salary
FROM Employee AS E
JOIN Person AS P
  ON E.FK_Person = P.PersonID;

SELECT * FROM Property;

SELECT * FROM PropertySale;

SELECT * FROM PropertyAcquisition;

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
