--CREATE DATABASE RealEstate;
--GO

USE RealEstate;
GO

CREATE TABLE Person (
    PersonID        INT		PRIMARY KEY,
    [Name]          VARCHAR(30)     NOT NULL,
    Surname         VARCHAR(30)     NOT NULL,
    ContactNumber   VARCHAR(15),
    Email           VARCHAR(50),
    Address         VARCHAR(200),
);
GO


CREATE TABLE Employee (
    EmployeeID      INT		PRIMARY KEY,
    FK_Person       INT     NOT NULL,
    Position        VARCHAR(50),
    Salary          DECIMAL(10,2),
    FOREIGN KEY (FK_Person) REFERENCES Person(PersonID)
);
GO

CREATE TABLE Property (
    PropertyID      INT		PRIMARY KEY NOT NULL,
    Amenities       VARCHAR(1000),
    Address         VARCHAR(100),
	District		VARCHAR(20),
    [Type]          VARCHAR(20),
	size			INT,
    Price           DECIMAL(10,2),
);
GO


CREATE TABLE PropertySale (
    SaleID          INT	PRIMARY KEY NOT NULL,
    FK_Property     INT             NOT NULL,
	FK_Person       INT             NOT NULL,
    FK_EmployeeID   INT             NOT NULL,
    SalePrice       DECIMAL(10,2),
    SaleDate        DATE,
	FOREIGN KEY (FK_Property) REFERENCES Property(PropertyID),
	FOREIGN KEY (FK_Person) REFERENCES Person(PersonID),
	FOREIGN KEY (FK_EmployeeID) REFERENCES Employee(EmployeeID)
);
GO


CREATE TABLE PropertyAcquisition (
    BoughtID        INT	PRIMARY KEY,  
    FK_Property     INT NOT NULL,
	FK_Person       INT NOT NULL,
    FK_EmployeeID   INT NOT NULL,
    BuyingPrice     DECIMAL(10,2),
    BuyingDate      DATE,
    FOREIGN KEY (FK_Property) REFERENCES Property(PropertyID),
    FOREIGN KEY (FK_Person) REFERENCES Person(PersonID),
    FOREIGN KEY (FK_EmployeeID) REFERENCES Employee(EmployeeID)
);
GO



