CREATE DATABASE RealEstate1_Snaptesting
ON
(
    NAME = RealEstate,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\snapshot1'
)
AS SNAPSHOT OF RealEstate;
GO