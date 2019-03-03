EXEC sp_configure 'show advanced options', 1;

GO
RECONFIGURE;

GO
EXEC sp_configure 'xp_cmdshell', 1;

GO
RECONFIGURE;

SELECT @@SERVERNAME;

exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.InvoiceLines" out "C:\tmp\InvoiceLines.txt" -T -w -t"@eu&$1&" -S localhost';

select top 1 *
into WideWorldImporters.Sales.InvoiceLines_BulkDemo
from WideWorldImporters.Sales.InvoiceLines;


truncate table WideWorldImporters.[Sales].[InvoiceLines_BulkDemo];

BULK INSERT [WideWorldImporters].[Sales].[InvoiceLines_BulkDemo]
				   FROM "c:\tmp\InvoiceLines.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@eu&$1&',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );

select top(100) *
from [WideWorldImporters].[Sales].[InvoiceLines_BulkDemo];