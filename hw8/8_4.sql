use WideWorldImporters;
SELECT c.CustomerID
	   ,c.CustomerName
	   ,inv.StockItemID
	   ,inv.UnitPrice
	   ,inv.InvoiceDate
FROM Sales.Customers c
CROSS APPLY (SELECT TOP 2 
				il.StockItemID,
				il.UnitPrice,
				i.InvoiceDate
             FROM Sales.Invoices i
             join Sales.InvoiceLines as il on il.InvoiceID = i.InvoiceID
			 WHERE i.CustomerID = c.CustomerID
			 ORDER BY il.UnitPrice DESC) AS inv
ORDER BY C.CustomerName;