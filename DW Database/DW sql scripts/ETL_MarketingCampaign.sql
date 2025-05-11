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
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )


If (object_id('vETLMarketingCampaign') is not null) Drop view vETLMarketingCampaign;
GO 

CREATE VIEW vETLMarketingCampaign
AS
SELECT
	Property_ID,
	Campaign_Start_Date_ID,
	Campaign_End_Date_ID,
	Acquisition_Date,
	Sale_Date,
	Views_our_website,
	Views_competition_website,
	Views_Social_Media,
	Money_Spent_Competition_website,
	Money_Spent_Social_Media,
	Junk_ID,
	Was_sold
FROM
	(SELECT 
		pd.Property_ID AS Property_ID,
		ISNULL(dms.Date_ID, 1) AS Campaign_Start_Date_ID,
		ISNULL(dme.Date_ID, 1) AS Campaign_End_Date_ID,
		ISNULL(da.Date_ID, 1) AS Acquisition_Date,
		ISNULL(ds.Date_ID, 1) AS Sale_Date,
		Views_our_website,
		Views_competition_website,
		Views_Social_Media,
		Money_Competition_Website AS Money_Spent_Competition_website,
		Money_Social_Media AS Money_Spent_Social_Media,
		CASE 
			WHEN s.SaleDate IS NULL THEN 3
            WHEN DATEDIFF(MONTH, a.BuyingDate, s.SaleDate) <= 6 THEN 1
            ELSE 2
		END AS Junk_ID,
		CASE
			WHEN s.SaleDate IS NULL THEN 0
			WHEN s.SaleDate IS NOT NULL THEN 1
		END AS Was_sold

	FROM RealEstate.dbo.Property AS p
	LEFT JOIN RealEstate.dbo.PropertySale AS s ON p.PropertyID = s.FK_Property
	LEFT JOIN RealEstate.dbo.PropertyAcquisition as a on p.PropertyID = a.FK_Property
	LEFT JOIN DW_MARKETING.dbo.DimDate AS ds ON ds.Full_Date = s.SaleDate
	LEFT JOIN DW_MARKETING.dbo.DimDate AS da ON da.Full_Date = a.BuyingDate
	JOIN DW_MARKETING.dbo.Property AS pd ON pd.Physical_property_id = p.PropertyID
	JOIN DW_MARKETING.dbo.MarketingTemp AS m ON m.PropertyID = pd.Physical_property_id 
	LEFT JOIN DW_MARKETING.dbo.DimDate AS dms ON dms.Full_Date = m.Starting_date
	LEFT JOIN DW_MARKETING.dbo.DimDate AS dme ON dme.Full_Date = m.Ending_date
	) AS x;
GO



MERGE INTO MarketingCampaign AS TT
USING vETLMarketingCampaign AS ST
    ON 
        TT.Property_ID = ST.Property_ID
    AND TT.Campaign_Start_Date_ID = ST.Campaign_Start_Date_ID
    AND TT.Campaign_End_Date_ID = ST.Campaign_End_Date_ID
    AND TT.Acquisition_Date = ST.Acquisition_Date
    AND TT.Sale_Date = ST.Sale_Date
    AND TT.Junk_ID = ST.Junk_ID
    AND TT.Was_sold = ST.Was_sold
WHEN NOT MATCHED
    THEN
        INSERT (
            Property_ID, 
            Campaign_Start_Date_ID, 
            Campaign_End_Date_ID,
            Acquisition_Date,
            Sale_Date,
            Views_our_website, 
            Views_competition_website,
            Views_Social_Media, 
            Money_Spent_Competition_website,
            Money_Spent_Social_Media,
            Junk_ID,
            Was_sold
        )
        VALUES (
            ST.Property_ID, 
            ST.Campaign_Start_Date_ID, 
            ST.Campaign_End_Date_ID,
            ST.Acquisition_Date,
            ST.Sale_Date,
            ST.Views_our_website, 
            ST.Views_competition_website,
            ST.Views_Social_Media, 
            ST.Money_Spent_Competition_website,
            ST.Money_Spent_Social_Media,
            ST.Junk_ID,
            ST.Was_sold
        );

        
DROP VIEW vETLMarketingCampaign;
DROP TABLE dbo.MarketingTemp;
