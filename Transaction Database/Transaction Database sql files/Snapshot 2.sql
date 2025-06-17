CREATE DATABASE RealEstate1_Snaptesting2
ON
(
    NAME = RealEstate,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\snapshot2'
)
AS SNAPSHOT OF RealEstate;
GO