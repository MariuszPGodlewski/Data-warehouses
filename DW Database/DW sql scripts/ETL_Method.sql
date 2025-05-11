USE DW_MARKETING
GO

If (object_id('dbo.MarketingTemp') is not null) DROP TABLE dbo.MarketingTemp;
CREATE TABLE dbo.MarketingTemp(
PropertyID int,
Money_Marketing int, 
Views_Our_Website int, 
Views_Competition_Website int, 
Money_Competition_Website int, 
Views_Social_Media int,
Money_Social_Media int,
Starting_date date,
Ending_date date,
Methods varchar(200)
);

go

BULK INSERT dbo.MarketingTemp
    --FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\marketing_data.csv'
    FROM 'C:\Data DW\marketing_data.csv'
	WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    TABLOCK
    )


If (object_id('vETLMethod') is not null) Drop view vETLMethod;
GO 
USE DW_MARKETING;
GO

CREATE VIEW vETLMethod
AS
SELECT DISTINCT 
    LTRIM(RTRIM(value)) COLLATE Latin1_General_CI_AS AS Method_Name 
FROM MarketingTemp AS m
CROSS APPLY STRING_SPLIT(
    REPLACE(REPLACE(REPLACE(m.Methods, '(''', ''), ''',)', ''), '"', ''), 
    ','
)
GO


MERGE INTO Method AS m
USING vETLMethod AS v_ETL
    ON m.Method_Name = v_ETL.Method_Name
WHEN NOT MATCHED
    THEN
        INSERT (Method_Name)
        VALUES (v_ETL.Method_Name);
GO

DROP VIEW vETLMethod
DROP TABLE MarketingTemp
