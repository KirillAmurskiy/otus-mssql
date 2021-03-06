set statistics time on

-- Краткий анализ результатов
--             Plan     CPU time     Elapsed time
-- Temp table:   4%       453 сек.       74 сек. (хорошо распараллелил)
-- Table var:    ?        Infinity       Infinity
-- Window func: 33%         1 сек.        7 сек.
-- Without all: 63%       252 сек.      280 сек.

-- В принципе почти все логично. 
-- Быстрее всего оконные.
-- Вариант с временной дольше, т.к. все равно выполняет лишние действия.
-- Оконные считаеют нарастающий итог за O(n), а с временной таблицей 
-- мы считаем за O(n2).
-- Разница итогового времени между решением с временной таблицей и без
-- тоже понятно, мы избавились от повторяющийся join и один раз рассчитываем
-- сумму для Invoice.
-- Дождаться окончания выполнения Table var, не удалось (компьютер работал час),
-- т.о. очевидно, что на много порядков дольше, чем остальные.

-- !!! Но не уверен, что понятна разница в CPU time между временными таблицами
-- и без ничего. Могу предположить, что с временной таблицей SqlServer умудряется
-- распараллелить, а без нее уже не может. Но тогда получается, что для
-- варианта с временной таблицей ему все же приходиться выполнять почти в 2 раза
-- больше вычислений, чем без ничего, а вот это уже мне не ясно.
-- temporary table

drop table if exists #InvoicesSum;

create table #InvoicesSum
(
    InvoiceID int primary key, 
    InvoiceDate Date, 
	CustomerName nvarchar(100),
    InvoiceSum decimal(18,2)
);

insert into #InvoicesSum
select 
	i.InvoiceID,
	i.InvoiceDate,
	c.CustomerName,
	SUM(il.UnitPrice * il.Quantity)
from WideWorldImporters.Sales.Invoices as i
join WideWorldImporters.Sales.InvoiceLines as il
	on i.InvoiceID = il.InvoiceID
join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID
where i.InvoiceDate >= '2015-01-01'
group by
	i.InvoiceID,
	i.InvoiceDate,
	c.CustomerName
order by
	i.InvoiceDate,
	c.CustomerName;
 
SELECT i.InvoiceID
      ,i.InvoiceDate
	  ,i.CustomerName
	  ,i.InvoiceSum
	  ,(select SUM(i2.InvoiceSum)
	    from #InvoicesSum as i2
		where FORMAT (i2.InvoiceDate, 'yy-MM') <= FORMAT (i.InvoiceDate, 'yy-MM')
		) AS InvoicesSum
FROM #InvoicesSum as i
order by
	i.InvoiceDate,
	i.CustomerName


-- with table variable

--declare @InvoicesSum table
--(
--    InvoiceID int primary key, 
--    InvoiceDate Date, 
--	CustomerName nvarchar(100),
--    InvoiceSum decimal(18,2)
--);

--insert into @InvoicesSum
--select 
--	i.InvoiceID,
--	i.InvoiceDate,
--	c.CustomerName,
--	SUM(il.UnitPrice * il.Quantity)
--from WideWorldImporters.Sales.Invoices as i
--join WideWorldImporters.Sales.InvoiceLines as il
--	on i.InvoiceID = il.InvoiceID
--join WideWorldImporters.Sales.Customers as c
--	on i.CustomerID = c.CustomerID
--where i.InvoiceDate >= '2015-01-01'
--group by
--	i.InvoiceID,
--	i.InvoiceDate,
--	c.CustomerName
--order by
--	i.InvoiceDate,
--	c.CustomerName;
 
--SELECT i.InvoiceID
--      ,i.InvoiceDate
--	  ,i.CustomerName
--	  ,i.InvoiceSum
--	  ,(select SUM(i2.InvoiceSum)
--	    from @InvoicesSum as i2
--		where FORMAT (i2.InvoiceDate, 'yy-MM') <= FORMAT (i.InvoiceDate, 'yy-MM')
--		) AS InvoicesSum
--FROM @InvoicesSum as i
--order by
--	i.InvoiceDate,
--	i.CustomerName


-- with window functions

SELECT distinct i.[InvoiceID]
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) over(partition by i.InvoiceID) as InvoiceSum
	  ,SUM(il.UnitPrice * il.Quantity) OVER(ORDER BY FORMAT (i.InvoiceDate, 'yy-MM')) AS InvoicesSum
FROM [WideWorldImporters].[Sales].[Invoices] as i
join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID
join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID
where
	i.InvoiceDate >= '2015-01-01'
order by
	i.InvoiceDate,
	c.CustomerName


-- without window functions
 
SELECT i.[InvoiceID]
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) as InvoiceSum
	  ,(select SUM(il2.UnitPrice * il2.Quantity)
	    from WideWorldImporters.Sales.Invoices as i2
		join WideWorldImporters.Sales.InvoiceLines as il2
			on i2.InvoiceID = il2.InvoiceID
		where FORMAT (i2.InvoiceDate, 'yy-MM') <= FORMAT (i.InvoiceDate, 'yy-MM')
			  and i2.InvoiceDate >= '2015-01-01')
		AS InvoicesSum
FROM [WideWorldImporters].[Sales].[Invoices] as i
join WideWorldImporters.Sales.Customers as c
	on i.CustomerID = c.CustomerID
join WideWorldImporters.Sales.InvoiceLines as il
	on il.InvoiceID = i.InvoiceID
where
	i.InvoiceDate >= '2015-01-01'
group by
	i.InvoiceID,
	i.InvoiceDate,
	c.CustomerName
order by
	i.InvoiceDate,
	c.CustomerName
