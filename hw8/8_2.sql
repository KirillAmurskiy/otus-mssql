use WideWorldImporters;

set statistics time on;

select CustomerName,
	   DeliveryAddressLine1 as addr
from Sales.Customers
union
select CustomerName,
	   DeliveryAddressLine2 as addr
from Sales.Customers

SELECT CustomerName, addr
FROM (
	SELECT DeliveryAddressLine1, 
		   DeliveryAddressLine2, 
		   CustomerName
	FROM Sales.Customers
) T UNPIVOT(addr FOR dich IN(DeliveryAddressLine1,
                             DeliveryAddressLine2)) AS upvt;
