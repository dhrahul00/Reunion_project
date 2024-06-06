WITH T1 as (
	SELECT 
	o.customerid,
	o.orderid,
	o.orderdate,
	ROUND((od.quantity*od.unitprice)::numeric,2) AS total_price,
	pr.category
	FROM
public.orders AS o
INNER JOIN public.orderdetails AS od ON o.orderid = od.orderid
INNER JOIN public.productvariants AS pv ON od.variantid = pv.variantid
INNER JOIN public.products AS pr ON pr.productid = pv.productid
)
SELECT 
	cs.customerid,
	CONCAT(cs.firstname , ' ', cs.lastname) AS full_name,
	cs.email,
	cs.phonenumber,
	T1.orderdate,
	T1.total_price,
	T1.category,
	ROUND(SUM(total_price::numeric) OVER(
							PARTITION BY T1.customerid , T1.category 
							ORDER BY T1.orderdate 
							ROWS BETWEEN UNBOUNDED PRECEDING 
										 AND 
										 CURRENT ROW
						),2) AS cumulative_price
FROM T1
INNER JOIN public.customers AS cs ON cs.customerid = T1.customerid
