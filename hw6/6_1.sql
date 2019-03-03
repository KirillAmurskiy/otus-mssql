--set statistics time on

SELECT distinct(i.[InvoiceID])
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) over(partition by i.InvoiceID) as InvoiceSum
	  ,SUM(il.UnitPrice * il.Quantity) OVER(ORDER BY FORMAT (i.InvoiceDate, 'yy-MM')) AS InvoicesSum
	  
FROM [WideWorldImporters].[Sales].[Invoices] as i

join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID

join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID

where
	i.InvoiceDate >= '2015-01-01'

order by
	i.InvoiceDate,
	c.CustomerName

-- запрос, который не получился

--set statistics time on
--так он не выполняется, надо добавить group by
--елси добавить group by, то он затребует добавить туда UnitPrice и Quantity
--если добавить туда UnitPrice и Quantity, то Sum(агрегатная) будет бессмыселнна
SELECT distinct(i.[InvoiceID])
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) as InvoiceSum
	  ,SUM(il.UnitPrice * il.Quantity) OVER(ORDER BY FORMAT (i.InvoiceDate, 'yy-MM')) AS InvoicesSum
	  
FROM [WideWorldImporters].[Sales].[Invoices] as i

join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID

join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID

where
	i.InvoiceDate >= '2015-01-01'

order by
	i.InvoiceDate,
	c.CustomerName

-- without window functions

SELECT i.[InvoiceID]
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) as InvoiceSum
	  ,(select SUM(il2.UnitPrice * il2.Quantity)
	    from WideWorldImporters.Sales.Invoices as i2
		join WideWorldImporters.Sales.InvoiceLines as il2
			on i2.InvoiceID = il2.InvoiceID
		where i2.InvoiceDate <= i.InvoiceDate) 
		AS InvoicesSum
	  
FROM [WideWorldImporters].[Sales].[Invoices] as i

join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID

join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID

where
	i.InvoiceDate >= '2015-01-01'

group by
	i.InvoiceID,
	i.InvoiceDate,
	c.CustomerName

order by
	i.InvoiceDate,
	c.CustomerName

select SUM(il2.UnitPrice * il2.Quantity)
	    from WideWorldImporters.Sales.Invoices as i2
		join WideWorldImporters.Sales.InvoiceLines as il2
			on i2.InvoiceID = il2.InvoiceID
		where i2.InvoiceDate <= '2016-08-01';