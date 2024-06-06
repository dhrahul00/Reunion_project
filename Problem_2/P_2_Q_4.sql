WITH top5products AS (
	SELECT 
	pr.productid,
	pr.productname,
	ROUND(SUM(od.quantity*od.unitprice)::numeric,2) AS total_price
FROM public.orders AS o
INNER JOIN public.orderdetails AS od ON od.orderid = o.orderid
INNER JOIN public.productvariants AS pv ON pv.variantid = od.variantid
INNER JOIN public.products AS pr ON pr.productid = pv.productid
GROUP BY pr.productid,
	pr.productname
ORDER BY SUM(od.quantity*od.unitprice) DESC
LIMIT 5),
price_pr_var AS (
	SELECT 
	od.variantid,
	MAX(pv.variantname) AS variantname,
	pv.productid,
	SUM(od.unitprice*od.quantity) AS price_pr_var
	FROM public.orderdetails AS od
	INNER JOIN public.productvariants AS pv ON pv.variantid = od.variantid
	GROUP BY pv.productid,od.variantid
)
SELECT 
	tp.productid,
	tp.productname,
	ppv.variantid,
	ppv.variantname,
	ppv.price_pr_var
	FROM top5products AS tp
INNER JOIN price_pr_var AS ppv ON ppv.productid = tp.productid
ORDER BY tp.total_price DESC, ppv.price_pr_var DESC