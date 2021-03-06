/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [StockItemID]
      ,[StockItemName]
      ,[Brand]
      ,[UnitPrice]
	  ,row_number() over (partition by left(si.StockItemName, 1) order by si.StockItemName)
	  ,sum(1) over() as TotalCount
	  ,sum(1) over(partition by left(si.StockItemName, 1)) as TotalCountWithFirstChar
	  ,lead(si.StockItemID) over (order by si.StockItemName) as NextId
	  ,lag(si.StockItemID) over (order by si.StockItemName) as PrevId
	  ,lag(si.StockItemName, 2, 'No items') over (order by si.StockItemName) as PrevPrevName
	  ,si.TypicalWeightPerUnit
	  ,ntile(30) over (order by si.TypicalWeightPerUnit) as GroupByWeight
FROM [WideWorldImporters].[Warehouse].[StockItems] as si
order by GroupByWeight