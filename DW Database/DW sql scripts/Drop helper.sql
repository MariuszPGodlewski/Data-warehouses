USE helper;
DROP TABLE holidays;
IF OBJECT_ID('dbo.school_breaks', 'U') IS NOT NULL
DROP TABLE dbo.school_breaks;

USE helper;
DROP TABLE vacation;
USE master;

DROP DATABASE helper;

GO
