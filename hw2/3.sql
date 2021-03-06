/****** Script for SelectTopNRows command from SSMS  ******/
USE WideWorldImporters
SELECT Orders.OrderID
      ,Orders.OrderDate
      ,Orders.ExpectedDeliveryDate
	  ,Orders.PickingCompletedWhen
      ,DATEPART(quarter, Orders.OrderDate) as Quarter
	  ,(MONTH(Orders.OrderDate) - 1)/4 + 1 as Third
  FROM Sales.Orders
  INNER JOIN Sales.OrderLines
	ON Orders.OrderID = OrderLines.OrderID
  WHERE (Orders.PickingCompletedWhen is not null)
		AND (OrderLines.UnitPrice > 100
			 OR OrderLines.Quantity > 20)
  GROUP BY Orders.OrderID, Orders.OrderDate, Orders.ExpectedDeliveryDate,
		   Orders.PickingCompletedWhen
  ORDER BY Quarter, Third, Orders.OrderDate, Orders.OrderID
  OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY