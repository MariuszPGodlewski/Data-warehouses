--CREATE DATABASE DW_MARKETING
--GO
SELECT * FROM Property
USE DW_MARKETING
GO

CREATE TABLE DimDate (
    Date_ID INT IDENTITY(1,1) PRIMARY KEY,
    Full_Date DATE,
    [Year] INT,
    [Month] VARCHAR(10),
    Month_Number INT,
    [Day] INT,
    Day_Of_Week_n INT,
    Day_Of_Week VARCHAR(10),
    Season VARCHAR(10),
    WorkingDay VARCHAR(15),
    Vacation VARCHAR(20),
    Holiday VARCHAR(50),
    BeforeHolidayDay VARCHAR(62),
    AfterHolidayDay VARCHAR(62)
);

CREATE TABLE Property (
    Property_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Type] VARCHAR(25),
    Size VARCHAR(30), -- Range
    Listing_Price VARCHAR(30), -- Range
	Physical_property_id INT
);

CREATE TABLE Junk (
    Junk_ID INT IDENTITY(1,1) PRIMARY KEY,
    Days_to_Sale VARCHAR(20) -- Range
);

CREATE TABLE Method (
    Method_ID INT IDENTITY(1,1) PRIMARY KEY,
    Method_Name VARCHAR(50),
);


CREATE TABLE MarketingCampaign (
    Campaign_ID INT IDENTITY(1,1) PRIMARY KEY,
    Property_ID INT FOREIGN KEY REFERENCES Property(Property_ID),
    Campaign_Start_Date_ID INT FOREIGN KEY REFERENCES DimDate(Date_ID),
    Campaign_End_Date_ID INT FOREIGN KEY REFERENCES DimDate(Date_ID),
    Acquisition_Date INT FOREIGN KEY REFERENCES DimDate(Date_ID),
    Sale_Date INT FOREIGN KEY REFERENCES DimDate(Date_ID),
    Views_our_website INT,
    Views_competition_website INT,
    Views_Social_Media INT,
    Money_Spent_Competition_website NUMERIC(18,2),
    Money_Spent_Social_Media NUMERIC(18,2),
    Junk_ID INT FOREIGN KEY REFERENCES Junk(Junk_ID),
    Was_sold BIT
    --Physical_property_id INT
);

USE DW_MARKETING
GO
CREATE TABLE CampaignMethods (
    Campaign_ID INT FOREIGN KEY REFERENCES MarketingCampaign(Campaign_ID),
    Method_ID INT FOREIGN KEY REFERENCES Method(Method_ID),
	[Views] INT,
    PRIMARY KEY (Campaign_ID, Method_ID)
);


USE  DW_MARKETING
ALTER TABLE DimDate ALTER COLUMN [Month] VARCHAR(10) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN Day_Of_Week VARCHAR(10) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN Season VARCHAR(10) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN WorkingDay VARCHAR(15) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN Vacation VARCHAR(20) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN Holiday VARCHAR(50) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN BeforeHolidayDay VARCHAR(62) COLLATE Latin1_General_CI_AS;
ALTER TABLE DimDate ALTER COLUMN AfterHolidayDay VARCHAR(62) COLLATE Latin1_General_CI_AS;

ALTER TABLE Property ALTER COLUMN Type VARCHAR(25) COLLATE Latin1_General_CI_AS;
ALTER TABLE Property ALTER COLUMN Size VARCHAR(30) COLLATE Latin1_General_CI_AS;
ALTER TABLE Property ALTER COLUMN Listing_Price VARCHAR(30) COLLATE Latin1_General_CI_AS;

ALTER TABLE Junk ALTER COLUMN Days_to_Sale VARCHAR(20) COLLATE Latin1_General_CI_AS;

ALTER TABLE Method ALTER COLUMN Method_Name VARCHAR(50) COLLATE Latin1_General_CI_AS;
