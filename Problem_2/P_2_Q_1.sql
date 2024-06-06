WITH lastorder AS (
	SELECT 
	customerid, 
	MAX(orderdate) AS lastorderdate
	FROM public.orders
	GROUP BY customerid
)
SELECT 
	MAX(cs.firstname),
	MAX(cs.lastname),
	MAX(cs.email),
	MAX(cs.phonenumber),
	AVG(od.unitprice*od.quantity) AS avg_price
FROM lastorder AS lo 
INNER JOIN public.customers AS cs ON cs.customerid = lo.customerid
INNER JOIN public.orders AS o ON o.customerid = cs.customerid
INNER JOIN public.orderdetails AS od ON od.orderid = o.orderid
WHERE o.orderdate >=  lo.lastorderdate - INTERVAL '6 months' 
GROUP BY cs.customerid
ORDER BY AVG(od.unitprice*od.quantity) DESC
LIMIT 5

	