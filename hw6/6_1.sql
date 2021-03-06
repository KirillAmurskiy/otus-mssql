set statistics time on

SELECT distinct(i.[InvoiceID])
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
-- Тут и без любого анализа планов и чего угодно понятно, что это
-- на мноооооого ресурсозатратнее. Даже моя бабушка сказала, что этот
-- запрос совершенно неоптимален.
-- 
-- Очевидно почему, т.к. на каждую строчку оригинального запроса (которых много)
-- выполняется еще один запрос, достаточно сложный. При этом, каждый следующий
-- дополнительный запрос дублирует вычисления предыдущего, т.о. выполняются лишние,
-- просто ненужные вычисления. Оконные функции этого не делают и работают в данном
-- случае в 100-1000 раз быстрее.
-- 
-- Хм... Интересно, что с точки зрения плана резница не очень большая, а фактическая
-- разница в затраченном времени - огронмая:
-- С оконными : 34% план,   1946 мс, 
-- Без оконных: 66% план, 272778 мс, в 140 раз дольше
-- Видимо, это говорит о том, что я вообще не понимаю что такое план и с какой стороны на
-- него смотреть. Обсудил с бабушкой, она тоже не в курсе.
-- 
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


-- запрос, который не получился

--set statistics time on
--так он не выполняется, надо добавить group by
--елси добавить group by, то он затребует добавить туда UnitPrice и Quantity
--если добавить туда UnitPrice и Quantity, то Sum(агрегатная) будет бессмыселнна
SELECT distinct(i.[InvoiceID])
      ,i.[InvoiceDate]
	  ,c.CustomerName
	  ,SUM(il.UnitPrice * il.Quantity) as InvoiceSum
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