USE RealEstate;
GO

-- 1. Insert into Person
INSERT INTO Person ([Name], Surname, ContactNumber, Email, Address)
VALUES 
    ('Alice', 'Smith', '555-1234', 'alice@example.com', '123 Elm Street'),
    ('Bob',   'Johnson', '555-5678', 'bob@example.com', '456 Maple Avenue'),
    ('Charlie','Brown', '555-7890', 'charlie@example.com', '789 Pine Road');
    
-- 2. Insert into Employee (linking to existing Person)
-- Let's say PersonID 1 is Alice, PersonID 2 is Bob, PersonID 3 is Charlie
INSERT INTO Employee (FK_Person, Position, Salary)
VALUES
    (1, 'Sales Manager', 6000.00), 
    (2, 'Sales Associate', 4000.00);

-- 3. Insert into Property
INSERT INTO Property (Amenities, Address, [Type], Price)
VALUES
    ('Furnished kitchen, 2 bedrooms', '1001 Walnut Street', 'Condo', 150000.00),
    ('3 bedrooms, 2 baths, backyard', '202 Main Street', 'House', 250000.00),
    ('1 bed, 1 bath, near downtown', '303 Center Avenue', 'Apartment', 120000.00);

-- 4. Insert into PropertySale
-- Suppose the "Salesman" is the Employee with EmployeeID=1 (Alice)
INSERT INTO PropertySale (FK_Property, FK_EmployeeID, SalePrice, SaleDate)
VALUES
    (1, 1, 145000.00, '2022-05-10'),  -- PropertyID=1 sold by EmployeeID=1
    (2, 1, 240000.00, '2022-06-15');  -- PropertyID=2 sold by EmployeeID=1

-- 5. Insert into PropertyAcquisition
-- Suppose the same Employee #1 also handled these acquisitions
INSERT INTO PropertyAcquisition (FK_Property, FK_EmployeeID, BuyingPrice, BuyingDate)
VALUES
    (1, 1, 130000.00, '2022-01-05'),  -- Employee #1 acquired property #1 
    (2, 1, 230000.00, '2022-03-20');  -- Employee #1 acquired property #2
GO


SELECT * FROM Property