USE master;
GO

-- Set the database to SINGLE_USER mode, kill others
ALTER DATABASE helper
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

-- Now drop it
DROP DATABASE helper;
GO

USE DW_MARKETING
SELECT * FROM DimDate