SELECT [PersonID]
      ,[FullName]
      ,[IsSalesperson]
FROM [WideWorldImporters].[Application].[People] as p
WHERE p.IsSalesperson = 1
	  AND NOT EXISTS (
				  select *
				  from Sales.Orders as o
				  where o.SalespersonPersonID = p.PersonID);
