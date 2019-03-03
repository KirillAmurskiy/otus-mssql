select
	FORMAT (i.InvoiceDate, 'yy-MM') as Month,
	SUM(il.UnitPrice * il.Quantity) as TotalSum,
	AVG(il.UnitPrice) as AvgUnitPrice

from WideWorldImporters.Warehouse.StockItems as si

join WideWorldImporters.Sales.InvoiceLines as il
	on si.StockItemID = il.StockItemID

join WideWorldImporters.Sales.Invoices as i
	on il.InvoiceID = i.InvoiceID

group by 
	FORMAT (i.InvoiceDate, 'yy-MM')

order by Month



