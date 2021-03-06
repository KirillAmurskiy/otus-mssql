/****** Script for SelectTopNRows command from SSMS  ******/
with InvoicesWithSum
as
(
SELECT p.[PersonID] as SalesPersonId
      ,p.[FullName] as SalesPersonName
	  ,c.CustomerID
	  ,c.CustomerName
	  ,i.InvoiceDate
	  ,sum(il.UnitPrice * il.Quantity) as InvoiceSum
	  ,row_number() over (partition by p.PersonID order by i.InvoiceDate desc) as SalesPersonInvoiceNumber
FROM [WideWorldImporters].[Application].[People] as p
join WideWorldImporters.Sales.Invoices as i
	on i.SalespersonPersonID = p.PersonID
join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID
join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID
group by
	p.[PersonID]
	,p.[FullName]
	,c.CustomerID
	,c.CustomerName
	,i.InvoiceDate
)

select
	i.SalesPersonId,
	i.SalesPersonName,
	i.CustomerID,
	i.CustomerName,
	i.InvoiceSum
from InvoicesWithSum as i
where i.SalesPersonInvoiceNumber = 1
