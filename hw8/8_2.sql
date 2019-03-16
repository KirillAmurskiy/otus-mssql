use WideWorldImporters;

SELECT distinct concat(c.DeliveryAddressLine1, c.DeliveryAddressLine2) as Address
	FROM Sales.Customers AS c
	where c.CustomerName like '%Tailspin Toys%'
