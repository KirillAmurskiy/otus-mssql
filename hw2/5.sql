/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [OrderID]
      ,Orders.CustomerID
      ,Customers.CustomerName
	  ,[SalespersonPersonID]
	  ,Salesperson.FullName as SalespersonName
      ,[OrderDate]
  FROM [WideWorldImporters].[Sales].[Orders] as Orders
  INNER JOIN WideWorldImporters.Sales.Customers as Customers
	ON Customers.CustomerID = Orders.CustomerID
  INNER JOIN WideWorldImporters.Application.People as Salesperson
	ON Salesperson.PersonID = Orders.SalespersonPersonID
  ORDER BY OrderDate DESC