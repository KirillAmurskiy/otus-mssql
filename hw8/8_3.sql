SELECT [CountryID]
      ,[CountryName]
      ,convert(varchar(200), [IsoAlpha3Code]) as Code
FROM [WideWorldImporters].[Application].[Countries]
union
SELECT [CountryID]
      ,[CountryName]
	  ,convert(varchar(200), IsoNumericCode) as Code
FROM [WideWorldImporters].[Application].[Countries]

