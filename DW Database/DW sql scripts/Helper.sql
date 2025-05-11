USE master;
GO

IF NOT EXISTS (
    SELECT name FROM sys.databases WHERE name = 'helper'
)
BEGIN
    CREATE DATABASE helper COLLATE Latin1_General_CI_AS;
END
GO

USE helper;
GO

IF OBJECT_ID('dbo.holidays', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.holidays (
        date DATETIME PRIMARY KEY,
        holiday VARCHAR(500),
        bank_holiday BIT
    );
END
GO

IF OBJECT_ID('dbo.vacation', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.vacation (
        begining DATETIME,
        "end" DATETIME,
        type VARCHAR(500),
        PRIMARY KEY (begining, "end")
    );
END
GO

USE master;
GO


USE helper
SELECT * From holidays

