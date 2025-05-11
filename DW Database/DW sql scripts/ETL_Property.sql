USE DW_MARKETING
GO

if (object_id('vETLDimProperty') is not null) Drop View vETLDimProperty;
GO

CREATE VIEW vETLDimProperty
AS
SELECT DISTINCT	
	[Type] COLLATE Latin1_General_CI_AS AS [Type],
	CASE	
		WHEN [size] < 50 THEN '<50 and less) square meters' COLLATE Latin1_General_CI_AS
		WHEN [size] < 80 THEN '<50 - 80) square meters' COLLATE Latin1_General_CI_AS
		WHEN [size] < 120 THEN '<80 - 120) square meters' COLLATE Latin1_General_CI_AS
		WHEN [size] < 180 THEN '<120 - 180) square meters' COLLATE Latin1_General_CI_AS
		WHEN [size] < 300 THEN '<180 - 300) square meters' COLLATE Latin1_General_CI_AS
		ELSE '<300 and more) square meters' COLLATE Latin1_General_CI_AS
	END AS [Size],
    CASE
        WHEN [Price] < 100000 THEN '<100 000 and less) PLN' COLLATE Latin1_General_CI_AS
        WHEN [Price] < 400000 THEN '<100 000 - 400 000) PLN' COLLATE Latin1_General_CI_AS
        WHEN [Price] < 700000 THEN '<400 000 - 700 000) PLN' COLLATE Latin1_General_CI_AS
        WHEN [Price] < 1000000 THEN '<700 000 - 1 000 000) PLN' COLLATE Latin1_General_CI_AS
        ELSE '<1 000 000 and more) PLN' COLLATE Latin1_General_CI_AS
    END AS [Listing_Price],
	PropertyID AS Physical_property_id
FROM [RealEstate].dbo.[Property];
GO

MERGE INTO DW_MARKETING.dbo.Property as TT
	USING vETLDimProperty as ST
		ON TT.Physical_property_id = ST.Physical_property_id
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.[Type],
					ST.[Size],
					ST.[Listing_Price],
					St.Physical_property_id
					)
			WHEN Matched
				AND (ST.[Type] <> TT.[Type]
				OR ST.[Size] <> TT.[Size]
				OR ST.[Listing_Price] <> TT.[Listing_Price])
			THEN
				UPDATE SET
				    TT.[Type] = ST.[Type],
					TT.[Size] = ST.[Size],
					TT.[Listing_Price] = ST.[Listing_Price];

INSERT INTO DW_MARKETING.dbo.Property(
	[Type],
	[Size],
	[Listing_Price],
	[Physical_property_id]
	)
	SELECT
		[Type],
		[Size],
		[Listing_Price],
		[Physical_property_id]
FROM (
    SELECT [Type], [Size], [Listing_Price], [Physical_property_id]
    FROM vETLDimProperty
    EXCEPT
    SELECT [Type], [Size], [Listing_Price], [Physical_property_id]
    FROM DW_MARKETING.dbo.Property
) AS Diff;

DROP View vETLDimProperty