/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	FORMAT (i.InvoiceDate, 'yy-MM') as Month,
	SUM (il.Quantity * il.UnitPrice) as TotalSum

FROM [WideWorldImporters].[Sales].[Invoices] as i

join WideWorldImporters.Sales.InvoiceLines as il
	on i.InvoiceID = il.InvoiceID

group by
	FORMAT (i.InvoiceDate, 'yy-MM')

having
	SUM (il.Quantity * il.UnitPrice) > 10000