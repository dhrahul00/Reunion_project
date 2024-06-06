WITH T AS (
	SELECT cs.customerid,
		MAX(cs.firstname),
		MAX(cs.lastname),
		MAX(cs.email),
		MAX(cs.phonenumber),
		DATE_PART('year',o.orderdate) AS orderyear,
		SUM(od.quantity*od.unitprice) AS total_price
FROM customers AS cs
INNER JOIN orders AS o ON o.customerid = cs.customerid
INNER JOIN orderdetails AS od ON od.orderid = o.orderid

GROUP BY cs.customerid,DATE_PART('year',o.orderdate)
),
T1 AS (
	SELECT *,
		total_price - LAG(total_price) OVER( PARTITION BY customerid ORDER BY orderyear) AS delta_price
FROM T)
SELECT * FROM T1
WHERE orderyear = EXTRACT(YEAR FROM NOW()) AND delta_price < 0
