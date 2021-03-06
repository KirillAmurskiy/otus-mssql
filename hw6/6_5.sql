/****** Script for SelectTopNRows command from SSMS  ******/
with CustomersStockItemsWithExpensiveNumber
as
(
SELECT  c.CustomerID
       ,c.[CustomerName]
	   ,si.StockItemID
	   ,si.StockItemName
	   ,si.UnitPrice
	   ,max(i.InvoiceDate) as LastInvoiceDate
	   ,row_number() over (partition by c.CustomerID order by si.UnitPrice desc) as ExpensiveNumber
FROM [WideWorldImporters].[Sales].[Customers] as c
join WideWorldImporters.Sales.Invoices as i
	on i.CustomerID = c.CustomerID
join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID
join WideWorldImporters.Warehouse.StockItems as si
	on si.StockItemID = il.StockItemID
group by
	c.CustomerID
    ,c.[CustomerName]
	,si.StockItemID
	,si.StockItemName
	,si.UnitPrice
)

select
	si.CustomerID,
	si.CustomerName,
	si.StockItemID,
	si.StockItemName,
	si.UnitPrice,
	si.LastInvoiceDate
from CustomersStockItemsWithExpensiveNumber as si
where si.ExpensiveNumber < 3
order by si.CustomerID, si.ExpensiveNumber

