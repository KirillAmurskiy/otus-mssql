select
	si.StockItemID,
	si.StockItemName,
	FORMAT (i.InvoiceDate, 'yy-MM') as Month,
	SUM(il.UnitPrice * il.Quantity) as TotalSum,
	MIN(i.InvoiceDate) as FirstSale,
	SUM(il.Quantity) as TotalQuantity

from WideWorldImporters.Warehouse.StockItems as si

join WideWorldImporters.Sales.InvoiceLines as il
	on si.StockItemID = il.StockItemID

join WideWorldImporters.Sales.Invoices as i
	on il.InvoiceID = i.InvoiceID

group by 
	si.StockItemID,
	si.StockItemName,
	FORMAT (i.InvoiceDate, 'yy-MM')
	
having
	SUM(il.Quantity) < 50

order by si.StockItemID, Month
