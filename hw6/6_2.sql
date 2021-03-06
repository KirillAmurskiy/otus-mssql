/****** Script for SelectTopNRows command from SSMS  ******/
with StockItemsWithQuantityByMonthes
as
(
	SELECT distinct(si.[StockItemID])
	      ,si.[StockItemName]
		  ,format(i.InvoiceDate, 'yy-MM') as Month
		  ,SUM(il.Quantity) as TotalQuantity
	FROM [WideWorldImporters].[Warehouse].[StockItems] as si
	join WideWorldImporters.Sales.InvoiceLines as il
		on si.StockItemID = il.StockItemID
	join WideWorldImporters.Sales.Invoices as i
		on il.InvoiceID = i.InvoiceID
	where
		i.InvoiceDate >= '2016-01-01'
		and i.InvoiceDate < '2017-01-10'
	group by
		si.StockItemID,
		si.StockItemName,
		format(i.InvoiceDate, 'yy-MM')
),

StockItemsWithRaitingByMonthes
as
(
	select
		si.StockItemID,
		si.StockItemName,
		si.Month,
		si.TotalQuantity,
		row_number() over (partition by si.Month order by si.TotalQuantity desc) as Raiting 
	from StockItemsWithQuantityByMonthes as si
)

select 
	si.Month,
	si.Raiting,
	si.StockItemID,
	si.StockItemName,
	si.TotalQuantity
from StockItemsWithRaitingByMonthes as si
where si.Raiting < 3
order by
	si.Month,
	si.Raiting
