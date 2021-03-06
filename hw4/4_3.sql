SELECT [CustomerID]
      ,[CustomerName]
FROM [WideWorldImporters].[Sales].[Customers] as c
where c.CustomerID in (
	select TOP(5) t.CustomerId
	from Sales.CustomerTransactions as t
	order by t.TransactionAmount desc);


with Top5LargestTransactions(CustomerID)
AS  
(  
    select TOP(5) t.CustomerID
	from Sales.CustomerTransactions as t
	order by t.TransactionAmount desc
)

SELECT [CustomerID]
      ,[CustomerName]
FROM [WideWorldImporters].[Sales].[Customers] as c
where c.CustomerID in (select CustomerID from Top5LargestTransactions);

SELECT TOP(5)
	   c.CustomerID
      ,c.CustomerName
FROM [WideWorldImporters].[Sales].[Customers] as c
join Sales.CustomerTransactions as t
	on c.CustomerID = t.CustomerID
order by t.TransactionAmount desc;
