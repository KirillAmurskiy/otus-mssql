/****** Script for SelectTopNRows command from SSMS  ******/
use WideWorldImporters;
SELECT Customers.CustomerID
      ,Customers.CustomerName
	  ,Customers.PhoneNumber
	  ,StockItemName

  FROM Sales.Customers
  INNER JOIN WideWorldImporters.Sales.Orders
	ON Orders.CustomerID = Customers.CustomerID
  INNER JOIN Sales.OrderLines
	ON OrderLines.OrderID = Orders.OrderID
  INNER JOIN Warehouse.StockItems
	ON StockItems.StockItemID = OrderLines.StockItemID

WHERE StockItems.StockItemName = 'Chocolate frogs 250g'