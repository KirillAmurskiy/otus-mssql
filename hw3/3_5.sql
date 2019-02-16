EXEC sp_configure 'show advanced options', 1;

GO
RECONFIGURE;

GO
EXEC sp_configure 'xp_cmdshell', 1;

GO
RECONFIGURE;

SELECT @@SERVERNAME;

exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.InvoiceLines" out "C:\tmp\InvoiceLines.txt" -T -w -t, -S localhost\MSSQLSERVER';