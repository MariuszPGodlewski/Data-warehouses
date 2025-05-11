USE DW_MARKETING

GO

INSERT INTO DimDate (Full_Date, Year, Month, Month_Number, Day, Day_Of_Week_n, Day_Of_Week, Season, WorkingDay, Vacation, Holiday, BeforeHolidayDay, AfterHolidayDay)
VALUES 
('2024-03-21', 2024, 'March', 3, 21, 4, 'Thursday', 'Spring', 'working day', 'non-holiday', 'no holiday', 'no holiday', 'no holiday'),
('2024-06-01', 2024, 'June', 6, 1, 6, 'Saturday', 'Summer', 'day off', 'non-holidayy', 'no holiday', 'no holiday', 'no holiday'),
('2024-11-11', 2024, 'November', 11, 11, 1, 'Monday', 'Autumn', 'working day', 'non-holiday', 'no holiday', 'no holiday', 'no holiday'),
('2024-12-24', 2024, 'December', 12, 24, 2, 'Tuesday', 'Winter', 'working day', 'non-holiday', 'no holiday', 'no holiday', 'no holiday'),
('2024-12-26', 2024, 'December', 12, 26, 4, 'Thursday', 'Winter', 'working day', 'non-holiday', 'no holiday', 'no holiday', 'no holiday');

INSERT INTO Property (Type, Size, Listing_Price)
VALUES 
('Apartment', '<50 and less) square meters', '<100 000 and less) PLN'),
('Detached House', '<50 and less) square meters', '<100 000 and less) PLN'),
('Studio', '<50 and less) square meters', '<100 000 and less) PLN'),
('Semi-detached', '<50 and less) square meters', '<100 000 and less) PLN'),
('Townhouse', '<50 and less) square meters', '<100 000 and less) PLN');

INSERT INTO Junk (Days_to_Sale)
VALUES 
('Less then 6 months'),
('Less then 6 months'),
('Less then 6 months'),
('6 months or more'),
('6 months or more');

INSERT INTO Method (Method_Name)
VALUES 
('Video'),
('Photos'),
('Social Media'),
('Paid Ads'),
('Influencer Marketing');

INSERT INTO MarketingCampaign 
(Property_ID, Campaign_Start_Date_ID, Campaign_End_Date_ID, Acquisition_Date, Sale_Date, 
 Views_our_website, Views_competition_website, Views_Social_Media, 
 Money_Spent_Competition_website, Money_Spent_Social_Media, 
 Junk_ID, Was_sold, Physical_property_id)
VALUES 
(1, 1, 2, 1, 2, 120, 80, 200, 300.00, 400.00, 1, 1, 1001),
(2, 2, 3, 2, 4, 90, 70, 160, 200.00, 350.00, 2, 1, 1002),
(3, 3, 4, 3, 5, 60, 50, 130, 150.00, 200.00, 3, 0, 1003),
(4, 4, 5, 4, 5, 40, 30, 90, 100.00, 150.00, 4, 0, 1004),
(5, 1, 5, 1, 5, 100, 90, 220, 250.00, 370.00, 5, 1, 1005);


USE DW_MARKETING

GO
INSERT INTO CampaignMethods (Campaign_ID, Method_ID, Views)
VALUES 
(1, 1, 1000),
(1, 3, 1000),
(2, 2, 3000),
(3, 4, 3000),
(4, 5, 4000);
