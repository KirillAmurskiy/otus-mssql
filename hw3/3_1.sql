/*1.Insert 5 Pumbas, for Timon's pleasure*/

DECLARE @idx INT = 0;

WHILE @idx < 5
BEGIN 

	insert into Sales.Customers
	([CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
	  ,[LastEditedBy])

	  OUTPUT inserted.CustomerID, inserted.CustomerName, inserted.LastEditedBy 
	  
	  values
	  ('Pumba' + CONVERT(varchar(10),@idx),
	  1, 
	  1,
	  1,
	  1,
	  1,
	  1,
	  1,
	  1, 
	  GETDATE(), 
	  0,
	  0,
	  0,
	  7,
	  '300', 
	  '300', 
	  '', 
	  '', 
	  'http://mickey.home',
	  'Shop 1', 
	  '15 Moon Alley', 
	  '300300',
	  0xE6100000010CE73F5A52A4BF444010638852B1A759C0,
	  'PostalAddress1', 
	  'PostalAddress2', 
	  '100',
	  1);
	
	SET @idx = @idx + 1;

END;

/*Read inserted*/

SELECT TOP (5) *
  FROM [Sales].[Customers]
  ORDER BY CustomerID DESC;


/*2. Delete Pumba0*/

DELETE FROM Sales.Customers
OUTPUT deleted.CustomerID, deleted.CustomerName
WHERE CustomerName = 'Pumba0';

/*3. Update Pumba2 -> Pumba22*/

UPDATE Sales.Customers
SET
	CustomerName = 'Pumba22'
OUTPUT deleted.CustomerName as OldName, inserted.CustomerName as NewName
WHERE
	CustomerName = 'Pumba2';

/*4. Add or Update Pumba5*/

declare @customerName varchar = 'Pumba5';

MERGE WideWorldImporters.Sales.Customers as target
USING (select @customerName as CustomerName) as source
  on target.CustomerName = source.CustomerName
WHEN MATCHED THEN
	UPDATE SET
		AccountOpenedDate = GETDATE()
WHEN NOT MATCHED THEN
	INSERT ([CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
	  ,[LastEditedBy])

	  VALUES (source.CustomerName,
	  1, 
	  1,
	  1,
	  1,
	  1,
	  1,
	  1,
	  1, 
	  GETDATE(), 
	  0,
	  0,
	  0,
	  7,
	  '300', 
	  '300', 
	  '', 
	  '', 
	  'http://mickey.home',
	  'Shop 1', 
	  '15 Moon Alley', 
	  '300300',
	  0xE6100000010CE73F5A52A4BF444010638852B1A759C0,
	  'PostalAddress1', 
	  'PostalAddress2', 
	  '100',
	  1)
OUTPUT $action, inserted.CustomerName, inserted.AccountOpenedDate;
	
