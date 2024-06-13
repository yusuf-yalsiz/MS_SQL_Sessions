

--session 12

---SQL Programming

--Begin ve End zorunlu deðil ancak procedure' un nerede baþlayýp nerede bittiðini görebilmek için önemli.

CREATE PROCEDURE sp_sample_1 AS

BEGIN
		SELECT 'HELLO WORLD' AS [MESSAGE]
END;


sp_sample_1

SELECT 'HELLO WORLD', 'HELLO'

EXEC sp_sample_1 -- sadece proc ismiyle çaðýrmak pek tercih edilmez.

EXECUTE sp_sample_1

----

ALTER PROCEDURE sp_sample_1 AS

BEGIN
		PRINT 'HELLO WORLD' -- sonucu print veya select ile aliriz. print ile mesaj olarak sonuçlar görünecektir.


END;


EXECUTE sp_sample_1


----------

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )




CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- gerçekleþen delivery date
);




INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


SELECT *
FROM ORDER_DELIVERY


----


CREATE PROC sp_order_cnt 
AS
BEGIN
		SELECT	COUNT(ORDER_ID) 
		FROM	ORDER_TBL
END;
	

EXEC sp_order_cnt


--proc içerisinde kullanýlan tablo güncellendikçe sonuç deðiþecektir.

INSERT ORDER_TBL VALUES	(9,9, 'Sam', getdate(), getdate()+2)


SELECT *
FROM ORDER_TBL



EXEC sp_order_cnt

----------------


---parametre yazarken @ karakteri ve veri tipini yazmak zorundayiz.

CREATE PROC sp_order_by_date (@tarih DATE)
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @tarih
END;

--proc parametre aldýðýnda bu þekilde yazýlýr. Tarih ve string deðerler týrnak içinde, numeric deðerler týrnaksýz yazýlýr.
EXEC sp_order_by_date '2024-05-10'



--iki parametreli proc
CREATE PROC sp_order_by_date_by_customer (@tarih DATE , @musteri VARCHAR(15))
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @tarih
		AND		customer_name = @musteri
END;


EXEC sp_order_by_date_by_customer  '2024-05-10', 'Sam'



--proc alter komutuyla güncellenir. parametre tanýmlandýðýnda atanýlan deðer default deðer olarak kabul edilir.

ALTER PROC sp_order_by_date_by_customer (@cust_name VARCHAR(15) , @ord_date DATE = '2024-05-10')
AS
BEGIN
		SELECT	COUNT(ORDER_ID) cnt_order
		FROM	ORDER_TBL
		WHERE	order_date = @ord_date
		AND		customer_name = @cust_name
END;



EXEC sp_order_by_date_by_customer 'Sam', '2024-05-10'

--default deðer tanimlanmis parametre, proc çaðýrýlýrken yazýlmayabilir. Yani @ord_date yazilmasa da olur

EXEC sp_order_by_date_by_customer 'Sam'

-----------------------

DECLARE @v1 int, @v2 int, @result int --degiskenleri tanimla

SELECT @v1 = 5.3  --deger ata (float ise int kismini alir)

SET @v2 = 6  --TEK deger icin select veya set yazilabilir

SET @result = @v1 * @v2 -- kullan

SELECT @result -- çagir

---------------------------

DECLARE @v1 int, @v2 int, @result int

SELECT @v1 = 5 , @v2 = 6  --iki deger select ile tanimlaniyor. set olmuyor

SET @result = @v1 * @v2  --BURASI DA SELECT DE OLABILIR

PRINT @result


-----

DECLARE @v1 int = 5.3 , @v2 int = 6 
DECLARE @result int = @v1 * @v2

SELECT @result

--
DECLARE @v1 int = 5 , @v2 int = 6 , @result int = @v1 * @v2
SELECT @result
--Must declare the scalar variable "@result".


DECLARE @cust_id int = 5

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_ID = @cust_id
-- W gibi birlikte calistirmak gerekiyor




DECLARE @CUST_NAME VARCHAR(10)

SET @CUST_NAME = (SELECT	CUSTOMER_NAME
					FROM	ORDER_TBL
					WHERE	ORDER_DATE = '2024-05-07'
					) --Subquery returned more than 1 value. This is not permitted!
--set ile sorgu sonucundaki degeri degiskene atama

/*SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_NAME = @CUST_NAME*/


SELECT @CUST_NAME

-------------



DECLARE @CUST_NAME VARCHAR(10)

--select ile sorgu sonucundaki deðeri deðiþkene atama

SELECT	@CUST_NAME = CUSTOMER_NAME
		FROM	ORDER_TBL
		WHERE	ORDER_DATE = '2024-05-07'
		

SELECT @CUST_NAME  --Jack i getir medi. Subquery den tek deger aldi

/*
Evet, bu durumda, alt sorgudan sadece bir değer atanır. SELECT ifadesi
bir atama işlemi gerçekleştirirken, alt sorgudan dönen tüm değerler yerine
sadece ilk değeri alır ve atama işlemini yapar. Bu durum, SQL'in davranışıdır ve beklenen bir sonuçtur.*/


SELECT	*
		FROM	ORDER_TBL

------



---IF ELSE

DECLARE @CUST_ID INT = 4

IF @CUST_ID = 5
	SELECT 'This is the customer'

ELSE IF @CUST_ID = 3
	SELECT 'The wrong customer'
		
ELSE PRINT 'No Customer'


------------

--IF EXISTS

DECLARE @CUST_ID INT = 5

IF EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUST_ID)
		 SELECT COUNT(ORDER_ID) AS CNT_ORDER
		 FROM ORDER_TBL
		 WHERE CUSTOMER_ID = @CUST_ID

ELSE PRINT 'There is no such a customer!'


------------------

--iki deðiþken tanýmlayýn
--1. deðiþken ikincisinden büyük ise iki deðiþkeni toplayýn
--2. deðiþken birincisinden büyük ise 2. deðiþkenden 1. deðiþkeni çýkarýn
--1. deðiþken 2. deðiþkene eþit ise iki deðiþkeni çarpýn


DECLARE @v1 int, @v2 int

SET @v1 = 5

SET @v2 = 5

IF @v1 > @v2
	SELECT @v1 + @v2 AS TOPLAM

ELSE IF @v1 < @v2
	SELECT @v2 - @v1 AS FARK

ELSE IF @v1 = @v2
	SELECT @v1 * @v2 CARPIM


----///////////////////////


---Istenilen tarihte verilen sipariþ sayýsý 2 ten küçükse 'lower than 2',
-- 2 ile 5 arasýndaysa sipariþ sayýsý, 5' den büyükse 'upper than 5' yazdýran bir sorgu yazýnýz.

SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = '2024-05-7' ; 




--(SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) bu sorgu deðiþkene tanýmlanabilirdi
--proc oluþtururken bunu yapacaðýz


DECLARE @ord_day DATE

SET @ord_day = '2024-05-7'

IF 2 > (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day)
	PRINT 'lower than 2'

ELSE IF (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) BETWEEN 2 AND 5
	SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day

ELSE IF 5 < (SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day)
	PRINT 'Upper than 5'



--(SELECT	COUNT(ORDER_ID)	FROM	ORDER_TBL WHERE	ORDER_DATE = @ord_day) bu sorgu deðiþkene tanýmlanabilirdi
--proc oluþtururken bunu yapacaðýz


exec sp_sample_ord_cnt '2024-05-10'


---yukarýdaki sorguyu procedure haline dönüþtürelim

CREATE PROC sp_sample_ord_cnt (@ord_date DATE)
AS
BEGIN
		DECLARE @ORD_CNT INT
	
		SELECT	@ORD_CNT = COUNT(ORDER_ID)	
		FROM	ORDER_TBL 
		WHERE	ORDER_DATE = @ord_date

IF @ORD_CNT < 2 
	PRINT 'lower than 2'

ELSE IF @ORD_CNT BETWEEN 2 AND 5
	SELECT @ORD_CNT AS count_of_order

ELSE IF @ORD_CNT > 5
	PRINT 'upper than 5'

END;

exec sp_sample_ord_cnt '2024-05-7'

---------------

----WHILE

--baþlangýç ve bitiþ deðeri belirlenmeli
--döngüyü saðlayacak iþlem yazýlmalý


DECLARE @NUM INT = 1 , @ENDPOINT INT = 50

WHILE @NUM <= @ENDPOINT
BEGIN
	PRINT @NUM
	SET @NUM = @NUM +1 -- @NUM+=1
END;


---- bir tabloya otomatik olarak deðer girilmesi

DECLARE @START_ID INT = 10

WHILE @START_ID <= 20
BEGIN
	INSERT ORDER_TBL 
	VALUES (@START_ID, @START_ID, NULL, NULL, NULL)

	SET @START_ID += 1
END;


SELECT *
FROM ORDER_TBL


---------------



----FUNCTIONS


--SCALAR-VALUED FUNCTIONS

--Fonksiyonlarda parametre olmasa da parantez yazýlýr. Parametre varsa içine tanýmlanýr.

CREATE FUNCTION fn_sample_1() 
RETURNS VARCHAR(MAX) -- dönecek deðerin veri tipini baþtan belirliyoruz.
AS
BEGIN
		RETURN UPPER('clarusway') -- return fonksiyonlarda sonucu döndürecek komut. Mutlaka yazýlmalý
END;


SELECT dbo.fn_sample_1()

------


CREATE FUNCTION fn_title (@string VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
		RETURN UPPER (LEFT (@string, 1)) + LOWER (RIGHT (@string, len (@string)-1))
END;


SELECT dbo.fn_title('commands complETED successfully.')



SELECT dbo.fn_title(CUSTOMER_NAME)
FROM	ORDER_TBL

--------------------


--Sipariþleri, tahmini teslim tarihleri ve gerçekleþen teslim tarihlerini kýyaslayarak
--'Late','Early' veya 'On Time' olarak sýnýflandýrmak istiyorum.
--Eðer sipariþin ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (gerçekleþen teslimat tarihi) küçükse
--Bu sipariþi 'LATE' olarak etiketlemek,
--Eðer EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipariþi 'EARLY' olarak etiketlemek,
--Eðer iki tarih birbirine eþitse de bu sipariþi 'ON TIME' olarak etiketlemek istiyorum.


ALTER FUNCTION fn_order_delivery_status (@order_id INT )
RETURNS VARCHAR(10)
AS
BEGIN
		DECLARE @DEL_DAY DATE
		DECLARE @EST_DEL_DAY DATE
		DECLARE @STATUS VARCHAR(10)

		SELECT @DEL_DAY = DELIVERY_DATE
		FROM	ORDER_DELIVERY
		WHERE	ORDER_ID = @order_id

		SELECT @EST_DEL_DAY = EST_DELIVERY_DATE
		FROM	ORDER_TBL
		WHERE	ORDER_ID = @order_id

		IF @EST_DEL_DAY < @DEL_DAY
			SET @STATUS = 'LATE'
		ELSE IF @EST_DEL_DAY = @DEL_DAY
			SET @STATUS = 'ON TIME'
		ELSE IF @EST_DEL_DAY > @DEL_DAY
			SET @STATUS = 'EARLY'

RETURN @STATUS
END;


SELECT dbo.fn_order_delivery_status(3)


SELECT *, dbo.fn_order_delivery_status(ORDER_ID) AS ORD_STATUS
FROM	ORDER_TBL


SELECT *, dbo.fn_order_delivery_status(A.ORDER_ID) AS ORD_STATUS
FROM	ORDER_TBL AS A
		INNER JOIN
		ORDER_DELIVERY AS B
		ON A.ORDER_ID = B.ORDER_ID
WHERE	dbo.fn_order_delivery_status(A.ORDER_ID) = 'ON TIME'



--------------//////////////


---TABLE-VALUED FUNCTIONS

CREATE FUNCTION fn_table_1 ()
RETURNS TABLE -- table valued fonksiyonlarda dönecek deðerin veri tipi table olarak belirtilir
AS 

-- table valued fonksiyonlarda dönecek tablo fonksiyonda deðiþken olarak tanýmlanan tablo deðilse
-- yani aþaðýdaki gibi mevcut bir tablonun belirli deðerlerini döndüren bir sorgu sonucunda oluþan tablo döndürülecekse
-- begin ve end yazýlmaz. sonucu döndürecek sorgu aþaðýdaki gibi RETURN komutu sonrasýnda yazýlýr.

RETURN	SELECT *
		FROM	ORDER_TBL
		WHERE	ORDER_DATE < '2024-05-07'
;


SELECT *
FROM	dbo.fn_table_1()


------

CREATE FUNCTION fn_table_2 (@day DATE)
RETURNS TABLE
AS 
RETURN	SELECT *
		FROM	ORDER_TBL
		WHERE	ORDER_DATE < @day


-- table valued fonksiyonlar tablo gibi kullanýlýr.
SELECT *
FROM	dbo.fn_table_2('2024-05-09')


-------------


-- Tablo deðiþkenini aþaðýdaki gibi oluþturup kullanabiliriz.

DECLARE @TBL1 TABLE (ID INT , NAME VARCHAR(10))

INSERT @TBL1 VALUES (10, 'Charlie')

SELECT *
FROM	@TBL1



----

--statusu on time olan sipariþlerin müþterilerinin id ve ismini döndüren bir fonksiyon oluþturun.

CREATE FUNCTION fn_ontime_orders(@ORDER_ID INT)
RETURNS @CUSTOMER TABLE (ID INT, [NAME] VARCHAR(25)) -- @customer isimli bir tablo deðiþkeni oluþturuyoruz, sütunlarýný belirliyoruz
AS
BEGIN -- yukarýdaki gibi fonksiyon sonucunda dönecek tablo deðiþken olarak tanýmlanmýþsa  fonksiyon içindeki komutlar begin ve end arasýna yazýlýr.


		INSERT @CUSTOMER
		SELECT CUSTOMER_ID, CUSTOMER_NAME
		FROM	ORDER_TBL
		WHERE	ORDER_ID = @ORDER_ID
		AND		dbo.fn_order_delivery_status(@ORDER_ID) = 'ON TIME'

RETURN
END;


SELECT *
FROM	dbo.fn_ontime_orders(7)






