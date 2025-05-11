DECLARE  @Start datetime
		 ,@End  datetime
DECLARE @AllDates table
		(Date datetime)

SELECT @Start = '2000-01-01', @End = '2025-12-31';

WITH Nbrs_3( n ) AS ( SELECT 1 UNION SELECT 0 ),
     Nbrs_2( n ) AS ( SELECT 1 FROM Nbrs_3 n1 CROSS JOIN Nbrs_3 n2 ),
     Nbrs_1( n ) AS ( SELECT 1 FROM Nbrs_2 n1 CROSS JOIN Nbrs_2 n2 ),
     Nbrs_0( n ) AS ( SELECT 1 FROM Nbrs_1 n1 CROSS JOIN Nbrs_1 n2 ),
     Nbrs  ( n ) AS ( SELECT 1 FROM Nbrs_0 n1 CROSS JOIN Nbrs_0 n2 )

	SELECT @Start+n-1 as "Date", CAST(YEAR(@Start+n-1) AS VARCHAR(4)) as Year, month(@Start+n-1) as monthId, case month(@Start+n-1)
WHEN 1 THEN 'January'
WHEN 2 THEN 'February'
WHEN 3 THEN 'March'
WHEN 4 THEN 'April'
WHEN 5 THEN 'May'
WHEN 6 THEN 'June'
WHEN 7 THEN 'July'
WHEN 8 THEN 'August'
WHEN 9 THEN 'September'
WHEN 10 THEN 'October'
WHEN 11 THEN 'November'
WHEN 12 THEN 'December'
END as "Month", DATEPART("dw", @Start+n-1) as weekDayId,
DATEPART(dayofyear, @Start + n - 1) AS day,
CASE DATEPART("dw", @Start+n-1)
WHEN 1 THEN 'Sunday'
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
WHEN 7 THEN  'Saturday'
END as weekDay,
CASE MONTH(@Start + n - 1)
WHEN 12 THEN 'Winter' WHEN 1 THEN 'Winter' WHEN 2 THEN 'Winter'
WHEN 3 THEN 'Spring' WHEN 4 THEN 'Spring' WHEN 5 THEN 'Spring'
WHEN 6 THEN 'Summer' WHEN 7 THEN 'Summer' WHEN 8 THEN 'Summer'
WHEN 9 THEN 'Autumn' WHEN 10 THEN 'Autumn' WHEN 11 THEN 'Autumn'
END AS Season,
CASE DATEPART("dw", @Start+n-1)
WHEN 1 THEN 'day off'
WHEN 2 THEN 'working day'
WHEN 3 THEN 'working day'
WHEN 4 THEN 'working day'
WHEN 5 THEN 'working day'
WHEN 6 THEN 'working day'
WHEN 7 THEN 'day off'
END as workingDay
		FROM ( SELECT ROW_NUMBER() OVER (ORDER BY n)
			FROM Nbrs ) D ( n )
	WHERE n <= DATEDIFF(day,@Start,@End)+1 ;