USE DW_MARKETING;
GO

-- Declare variables
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;

-- Set the range
SELECT @StartDate = '2015-01-01', @EndDate = '2025-12-31';

-- Declare a variable for looping
DECLARE @DateInProcess DATE = @StartDate;

-- Inserting null values 
INSERT INTO dbo.DimDate (
    Full_Date,
    Year,
    Month,
    Month_Number,
    Day,
    Day_Of_Week_n,
    Day_Of_Week,
    Season,
    WorkingDay,
    Vacation,
    Holiday,
    BeforeHolidayDay,
    AfterHolidayDay
)
VALUES (
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

-- Loop to insert dates

WHILE @DateInProcess <= @EndDate
BEGIN
    INSERT INTO dbo.DimDate (
        Full_Date,
        Year,
        Month,
        Month_Number,
        Day,
        Day_Of_Week_n,
        Day_Of_Week,
        Season,
        WorkingDay,
        Vacation,
        Holiday,
        BeforeHolidayDay,
        AfterHolidayDay
    )
    VALUES (
        @DateInProcess, -- Full_Date
        YEAR(@DateInProcess), -- Year
        DATENAME(MONTH, @DateInProcess), -- Month
        MONTH(@DateInProcess), -- Month_Number
        DAY(@DateInProcess), -- Day
        DATEPART(WEEKDAY, @DateInProcess), -- Day_Of_Week_n
        DATENAME(WEEKDAY, @DateInProcess), -- Day_Of_Week
        CASE 
            WHEN MONTH(@DateInProcess) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(@DateInProcess) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(@DateInProcess) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(@DateInProcess) IN (9, 10, 11) THEN 'Autumn'
        END, -- Season
        CASE 
            WHEN DATEPART(WEEKDAY, @DateInProcess) IN (1, 7) THEN 'Day off' -- Sunday(1) or Saturday(7)
            ELSE 'Working day'
        END, -- WorkingDay
        'non holiday', -- will update later
        'no holiday', -- will update later
        'no holiday', -- will update later
        'no holiday'  -- will update later
    );

    -- Move to next day
    SET @DateInProcess = DATEADD(DAY, 1, @DateInProcess);
END;
GO

-----------------------------------------------------------------------------------------
-- Step 2: Create a View to join with helper holiday and vacation data
-----------------------------------------------------------------------------------------

IF OBJECT_ID('vETLDimDatesData', 'V') IS NOT NULL
    DROP VIEW vETLDimDatesData;
GO



CREATE VIEW vETLDimDatesData
AS
SELECT 
    dd.Full_Date,
    dd.Year,
    dd.Month,
    dd.Month_Number,
    dd.Day,
    dd.Day_Of_Week_n,
    dd.Day_Of_Week,
    dd.Season,
    CASE 
        WHEN h.bank_holiday = 1 THEN 'Day off'
        WHEN v.type IS NOT NULL THEN 'Day off'
        WHEN dd.Day_Of_Week_n IN (1, 7) THEN 'Day off'
        ELSE 'Working day'
    END AS WorkingDay,

    ISNULL(v.type, 'No vacation') AS Vacation, 
    ISNULL(h.holiday, 'Non-holiday') AS Holiday,
    ISNULL(bh.BeforeHoliday, 'Not before holiday') AS BeforeHolidayDay,
    ISNULL(ah.AfterHoliday, 'Not after holiday') AS AfterHolidayDay
FROM dbo.DimDate dd
LEFT JOIN helper.dbo.holidays h ON dd.Full_Date = CAST(h.[date] AS [DATE])
LEFT JOIN ( 
    SELECT DATEADD(DAY, -1, CAST([date]AS [DATE])) AS DateBefore, 'Day before ' + holiday AS BeforeHoliday
    FROM helper.dbo.holidays
) bh ON dd.Full_Date = bh.DateBefore
LEFT JOIN ( 
    SELECT DATEADD(DAY, 1, CAST([date] AS [DATE])) AS DateAfter, 'Day after ' + holiday AS AfterHoliday
    FROM helper.dbo.holidays
) ah ON dd.Full_Date = ah.DateAfter
LEFT JOIN helper.dbo.vacation v 
    ON dd.Full_Date BETWEEN v.begining AND v.[end];
GO


-----------------------------------------------------------------------------------------
-- Step 3: Merge the updated data into the DimDate table
-----------------------------------------------------------------------------------------

MERGE INTO dbo.DimDate AS Target
USING vETLDimDatesData AS Source
ON Target.Full_Date = Source.Full_Date
WHEN MATCHED THEN
    UPDATE SET 
        Target.WorkingDay = Source.WorkingDay,
        Target.Vacation = Source.Vacation,
        Target.Holiday = Source.Holiday,
        Target.BeforeHolidayDay = Source.BeforeHolidayDay,
        Target.AfterHolidayDay = Source.AfterHolidayDay;
GO

-----------------------------------------------------------------------------------------
-- Step 4: Clean up
-----------------------------------------------------------------------------------------

DROP VIEW vETLDimDatesData;
GO
