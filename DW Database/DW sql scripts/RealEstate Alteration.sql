USE RealEstate;
GO

-- Person table
ALTER TABLE Person ALTER COLUMN [Name] VARCHAR(30) COLLATE Latin1_General_CI_AS;
ALTER TABLE Person ALTER COLUMN Surname VARCHAR(30) COLLATE Latin1_General_CI_AS;
ALTER TABLE Person ALTER COLUMN ContactNumber VARCHAR(15) COLLATE Latin1_General_CI_AS;
ALTER TABLE Person ALTER COLUMN Email VARCHAR(50) COLLATE Latin1_General_CI_AS;
ALTER TABLE Person ALTER COLUMN Address VARCHAR(200) COLLATE Latin1_General_CI_AS;
GO

-- Employee table
ALTER TABLE Employee ALTER COLUMN Position VARCHAR(50) COLLATE Latin1_General_CI_AS;
GO

-- Property table
ALTER TABLE Property ALTER COLUMN Amenities VARCHAR(1000) COLLATE Latin1_General_CI_AS;
ALTER TABLE Property ALTER COLUMN Address VARCHAR(100) COLLATE Latin1_General_CI_AS;
ALTER TABLE Property ALTER COLUMN District VARCHAR(20) COLLATE Latin1_General_CI_AS;
ALTER TABLE Property ALTER COLUMN [Type] VARCHAR(20) COLLATE Latin1_General_CI_AS;
GO

-- No need to alter PropertySale or PropertyAcquisition
-- (their columns are all INT, DECIMAL, DATE — no VARCHAR columns)


USE DW_MARKETING
SELECT * FROM Property