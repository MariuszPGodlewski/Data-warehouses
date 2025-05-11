USE DW_MARKETING
SELECT * FROM Method


USE DW_MARKETING;
GO

-- Disable foreign key constraints temporarily
ALTER TABLE CampaignMethods NOCHECK CONSTRAINT ALL;
ALTER TABLE MarketingCampaign NOCHECK CONSTRAINT ALL;

-- Delete child table data first to respect FK constraints
DELETE FROM CampaignMethods;
DELETE FROM MarketingCampaign;
DELETE FROM Method;
DELETE FROM Junk;
DELETE FROM Property;
DELETE FROM DimDate;

-- Re-enable foreign key constraints
ALTER TABLE CampaignMethods CHECK CONSTRAINT ALL;
ALTER TABLE MarketingCampaign CHECK CONSTRAINT ALL;
