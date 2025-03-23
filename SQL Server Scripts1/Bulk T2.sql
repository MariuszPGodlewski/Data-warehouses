USE RealEstate;
GO

BULK INSERT Person FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\T2_person.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);


BULK INSERT Employee FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\T2_employees.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);


BULK INSERT Property FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\T2_property.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);


BULK INSERT PropertySale FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\T2_sale.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);

BULK INSERT PropertyAcquisition FROM 'C:\Users\mgodl\OneDrive\Pulpit\Code\Sem 4\Data warehouses\T2_acquisitions.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a' 
);