
SELECT [StockItemID]
      ,[StockItemName]
      ,[UnitPrice]
FROM [WideWorldImporters].[Warehouse].[StockItems] as si
where si.UnitPrice = (
	select MIN(subSi.UnitPrice)
	from Warehouse.StockItems as subSi
	);


SELECT [StockItemID]
      ,[StockItemName]
      ,[UnitPrice]
FROM [WideWorldImporters].[Warehouse].[StockItems] as si
where si.UnitPrice = (
	select TOP(1) subSi.UnitPrice
	from Warehouse.StockItems as subSi
	order by subSi.UnitPrice asc
	);