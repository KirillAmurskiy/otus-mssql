set statistics time on;

SELECT [CountryID]
      ,[CountryName]
      ,convert(varchar(200), [IsoAlpha3Code]) as Code
FROM [WideWorldImporters].[Application].[Countries]
union
SELECT [CountryID]
      ,[CountryName]
	  ,convert(varchar(200), IsoNumericCode) as Code
FROM [WideWorldImporters].[Application].[Countries]

select CountryID
	  ,CountryName
	  ,mickey
from (
	select CountryID
		  ,CountryName
		  ,convert(varchar(20), IsoAlpha3Code) as IsoAlpha3
		  ,convert(varchar(20), IsoNumericCode) as IsoNumeric
	from Application.Countries
) T UNPIVOT (mickey for mouse in (IsoAlpha3,
								 IsoNumeric)) as upvt;
