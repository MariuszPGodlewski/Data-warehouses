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

BULK INSERT dbo.MarketingTemp
    --FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\Lab 2 - Data generator\Data generated\marketing_data.csv'
    FROM 'C:\Data DW\marketing_data.csv'
	WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )



/*
CREATE TABLE CampaignMethods (
    Campaign_ID INT FOREIGN KEY REFERENCES MarketingCampaign(Campaign_ID),
    Method_ID INT FOREIGN KEY REFERENCES Method(Method_ID),
	[Views] INT,
    PRIMARY KEY (Campaign_ID, Method_ID)
);
*/
If (object_id('vMarketingTemp') is not null) Drop view vMarketingTemp;
GO 
CREATE VIEW vMarketingTemp
AS
SELECT 
    m.PropertyID AS [Physical_property_id],
    m.Views_Competition_Website + m.Views_Social_Media + m.Views_Our_website AS Views,
    LTRIM(RTRIM(value)) COLLATE Latin1_General_CI_AS AS Method_Name 
FROM MarketingTemp AS m
CROSS APPLY STRING_SPLIT(
    REPLACE(REPLACE(REPLACE(m.Methods, '(''', ''), ''',)', ''), '"', ''), 
    ','
)
GO



If (object_id('vETLCampaignMethod') is not null) Drop view vETLCampaignMethod;
GO 
CREATE VIEW vETLCampaignMethod
AS
SELECT
	Campaign_ID,
	Method_ID,
	[Views]
FROM 
	(SELECT
		mc.Campaign_ID as Campaign_ID,
		m.Method_ID as Method_ID,
		v.[Views] as [Views]
	FROM vMarketingTemp v
	JOIN DW_MARKETING.dbo.Method as m on m.Method_Name = v.Method_Name
	LEFT JOIN DW_MARKETING.dbo.Property as p on p.Physical_property_id = v.Physical_property_id
	JOIN DW_MARKETING.dbo.MarketingCampaign as mc on mc.Property_ID = p.Property_ID
	) as x;
GO	


MERGE INTO CampaignMethods AS TT
USING vETLCampaignMethod AS ST
	ON 
		TT.Campaign_ID = ST.Campaign_ID
	AND	TT.Method_ID = ST.Method_ID
WHEN NOT MATCHED
	THEN 
		INSERT (
			Campaign_ID,
			Method_ID,
			[Views]
			)
			VALUES (
				ST.Campaign_ID,
				ST.Method_ID,
				ST.[Views]
			);

DROP VIEW vETLCampaignMethod

DROP TABLE dbo.MarketingTemp;