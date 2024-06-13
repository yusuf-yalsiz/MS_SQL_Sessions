
WITH T1 AS (
    SELECT DISTINCT  
        product_id, 
        discount,
        SUM(quantity) OVER (PARTITION BY product_id, discount) total_order
    FROM  
        sale.order_item
),
T2 AS  (
		SELECT *,
		AVG(total_order) OVER(PARTITION BY product_id) avg
		FROM T1
		),
T3 AS (
    SELECT *,
           FIRST_VALUE(total_order) OVER (PARTITION BY product_id ORDER BY product_id, discount) first,
           LAST_VALUE(total_order) OVER (PARTITION BY product_id ORDER BY product_id, discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last
    FROM T2
)

SELECT DISTINCT product_id,
       CASE
           WHEN last - first > 0 AND last > avg THEN 'positive'
           WHEN last - first < 0 AND first < avg THEN 'negative'
           ELSE 'normal'
       END AS change_type
FROM T3
ORDER BY product_id;


/*In addition to looking at the difference in the number of sales of the product with the highest discount compared to the product with the lowest discount
    At the same time, it is higher than the average of different discount rates, indicating that the high discount application is really
    I thought it would show that it had a positive effect.*/


/* En yuksek indirim uygulanan urunun satis sayisinin en dusuk indirim uygulanandan farkina bakmanin yaninda
   ayni zamanda farkli indirim oranlarin ortalamasindan da yuksek olmasi, yuksek indirim uygulamasinin gercekten 
   pozitif etki yaptigini gosterir diye dusundum. */




	

