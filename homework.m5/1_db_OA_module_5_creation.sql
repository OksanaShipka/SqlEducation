USE master
GO

CREATE DATABASE OA_module_5
GO

USE OA_module_5
GO

/* Create suppliers table */
DROP TABLE IF EXISTS suppliers
GO

CREATE TABLE suppliers (
	supplierid integer PRIMARY KEY,
	[name] VARCHAR(20),
	rating integer,
	city VARCHAR(20)
)
GO

/* Create details table */
DROP TABLE IF EXISTS details
GO

CREATE TABLE details (
	detailid integer PRIMARY KEY,
	[name] VARCHAR(20),
	color VARCHAR(20),
	[weight] integer,
	city VARCHAR(20)
)
GO

/* Create products table */
DROP TABLE IF EXISTS products
GO

CREATE TABLE products (
	productid integer PRIMARY KEY,
	[name] VARCHAR(20),
	city VARCHAR(20)
)
GO

/* Create supplies table */
DROP TABLE IF EXISTS supplies
GO

CREATE TABLE supplies (
	supplierid integer,
	detailid integer,
	productid integer,
	quantity integer
	CONSTRAINT supplierid_fk FOREIGN KEY (supplierid) REFERENCES suppliers(supplierid),
	CONSTRAINT detailid_fk FOREIGN KEY (detailid) REFERENCES details(detailid),
	CONSTRAINT productid_fk FOREIGN KEY (productid) REFERENCES products(productid) 
)
GO


INSERT INTO suppliers (supplierid, [name], rating, city) 
VALUES 
	(1, 'Smith', 20, 'London'),
	(2, 'Jonth', 10, 'Paris'),
	(3, 'Blacke', 30, 'Paris'),
	(4, 'Clarck', 20, 'London'),
	(5, 'Adams', 30, 'Athens');

INSERT INTO details (detailid, [name], color, [weight], city) 
VALUES 
	(1, 'Screw', 'Red', 12, 'London'),
	(2, 'Bolt', 'Green', 17, 'Paris'),
	(3, 'Male-screw', 'Blue', 17, 'Roma'),
	(4, 'Male-screw', 'Red', 14, 'London'),
	(5, 'Whell', 'Blue', 12, 'Paris'),
	(6, 'Bloom', 'Red', 19, 'London');


INSERT INTO products (productid, [name], city) 
VALUES 
	(1, 'HDD', 'Paris'),
	(2, 'Perforator', 'Roma'),
	(3, 'Reader', 'Athens'),
	(4, 'Printer', 'Athens'),
	(5, 'FDD', 'London'),
	(6, 'Terminal', 'Oslo'),
	(7, 'Ribbon', 'London');

INSERT INTO supplies (supplierid, detailid, productid, quantity) 
VALUES
	(1,	1,	1,	200),
	(1,	1,  4,	700),
	(2,	3,	1,	400),
	(2,	3,	2,	200),
	(2,	3,	3,	200),
	(2,	3,	4,	500),
	(2,	3,	5,	600),
	(2,	3,	6,	400),
	(2,	3,	7,	800),
	(2,	5,	2,	100),
	(3,	3,	1,	200),
	(3,	4,	2,	500),
	(4,	6,	3,	300),
	(4,	6,	7,	300),
	(5,	2,	2,	200),
	(5,	2,	4,	100),
	(5,	5,	5,	500),
	(5,	5,	7,	100),
	(5,	6,	2,	200),
	(5,	1,	4,	100),
	(5,	3,	4,	200),
	(5,	4,	4,	800),
	(5,	5,	4,	400),
	(5,	6,	4,	500);
	

/* Task 1a */

SELECT supplies.productid FROM supplies
WHERE supplies.supplierid = 3
AND NOT EXISTS
	(SELECT * FROM supplies s
		WHERE s.productid = supplies.productid
		AND s.supplierid <> 3)

/* Task 1b */

SELECT supplierid, name
FROM suppliers
WHERE supplierid IN
	(SELECT supplierid 
	FROM supplies 
	WHERE productid IN
		(SELECT productid FROM supplies WHERE detailid = 1)
		AND
		(quantity > ANY(SELECT AVG(quantity) FROM supplies WHERE detailid = 1 GROUP by productid)));


/* Task 1c */

SELECT DISTINCT detailid
FROM supplies
WHERE productid = ANY(SELECT productid FROM products WHERE city = 'London');

/* Task 1d */

SELECT supplierid, name
FROM suppliers
WHERE supplierid = ANY
	(SELECT supplierid 
	FROM supplies 
	WHERE detailid = ANY (SELECT detailid FROM details WHERE color = 'Red'));

/* Task 1e */

SELECT DISTINCT detailid
FROM supplies
WHERE productid = ANY
(SELECT DISTINCT productid FROM supplies
WHERE supplierid = 2)

/* Task 1f */

SELECT productid FROM
(SELECT productid, AVG(quantity) AS avg_quantity FROM supplies
GROUP BY productid) AS average
WHERE average.avg_quantity >  
	(SELECT MAX(quantity) FROM supplies WHERE productid = 1);

/* Task 1g */

INSERT INTO products (productid, [name], city) 
VALUES 
	(8, 'HDD', 'Paris')

SELECT productid 
FROM products
WHERE productid <> ALL (SELECT DISTINCT productid FROM supplies);


/* Task 2a */

;WITH MaxQuantityForFirst(quantity) AS
(
	SELECT MAX(quantity)
	FROM supplies
	WHERE productid = 1
),
AverageQuantity(quantity) AS
(
	SELECT productid FROM
	(SELECT productid, AVG(quantity) AS avg_quantity FROM supplies
		GROUP BY productid) AS average
		WHERE average.avg_quantity > (SELECT * FROM MaxQuantityForFirst)
)

SELECT * FROM AverageQuantity;

/* Task 2b */

;WITH Factorial(Position, Value) AS
 (
 SELECT Position = 1, Value = 1
 UNION ALL
 SELECT Position+1, Value * (Position+1)
 FROM Factorial WHERE Position < 10
 )
 SELECT * FROM Factorial WHERE Position = 10;

/* Task 2c */

 ;WITH Fibonacci(Position,Value, a, b) AS
(
 SELECT Position = 1, Value = 1, a = 1, b = 1+1
 UNION ALL
 SELECT Position+1, Value = a, a = b, b = a+b
 FROM Fibonacci WHERE Position < 20
)
SELECT  * FROM Fibonacci;

/* Task 2d */

DECLARE @BeginPeriod DATETIME = '2013-11-25',
        @EndPeriod DATETIME = '2014-03-05'

;WITH cte AS
(
    SELECT DATEADD(month, DATEDIFF(month, 0, @BeginPeriod), 0) AS StartOfMonth, 
           DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @BeginPeriod) + 1, 0)) AS EndOfMonth
    UNION ALL
    SELECT DATEADD(month, 1, StartOfMonth) AS StartOfMonth, 
           DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, DATEADD(month, 1, StartOfMonth)) + 1, 0)) AS EndOfMonth  
    FROM   cte
    WHERE  DATEADD(month, 1, StartOfMonth) <= @EndPeriod
)
SELECT  
    (CASE WHEN StartOfMonth < @BeginPeriod THEN @BeginPeriod ELSE StartOfMonth END) StartOfMonth,
    (CASE WHEN EndOfMonth > @EndPeriod THEN @EndPeriod ELSE EndOfMonth END) EndOfMonth
FROM cte

/* Task 2e */

SET DATEFIRST 1; 
GO

;WITH monthDates
AS
(
    SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) as d
           ,DATEPART(week, DATEADD(month, DATEDIFF(month, 0, GETDATE()),0)) as w
    UNION	ALL
    SELECT	DATEADD(day, 1, d),
			DATEPART(week, DATEADD(day, 1, d))
    FROM monthDates
    WHERE d < DATEADD(month, DATEDIFF(month, 0, GETDATE())+1,-1)
)

SELECT	MAX(CASE WHEN DATEPART(weekday, d) = 1 THEN DATEPART(day, d) ELSE NULL END) AS [Mon]
        ,MAX(CASE WHEN DATEPART(weekday, d) = 2 THEN DATEPART(day, d) ELSE NULL END) AS [Tue]
        ,MAX(CASE WHEN DATEPART(weekday, d) = 3 THEN DATEPART(day, d) ELSE NULL END) AS [Wed]
        ,MAX(CASE WHEN DATEPART(weekday, d) = 4 THEN DATEPART(day, d) ELSE NULL END) AS [Thu]
        ,MAX(CASE WHEN DATEPART(weekday, d) = 5 THEN DATEPART(day, d) ELSE NULL END) AS [Fri]
        ,MAX(CASE WHEN DATEPART(weekday, d) = 6 THEN DATEPART(day, d) ELSE NULL END) AS [Sat]
		,MAX(CASE WHEN DATEPART(weekday, d) = 7 THEN DATEPART(day, d) ELSE NULL END) AS [Sun]
FROM monthDates
GROUP BY w

/* Task 3a */
DROP TABLE IF EXISTS [geography]
GO

create table [geography]
(id int not null primary key, name varchar(20), region_id int);

ALTER TABLE [geography]
       ADD CONSTRAINT R_GB
              FOREIGN KEY (region_id)
                             REFERENCES [geography]  (id);

insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);


/* Task 3b */

;WITH first_level_regions(region_id, place_id, name, PlaceLevel) AS 
(
	SELECT region_id, id, name, PlaceLevel = 1
	FROM geography
	WHERE region_id = 1
)
SELECT region_id, place_id, name, PlaceLevel
FROM first_level_regions
go

/* Task 3c */

;WITH first_level_regions(region_id, place_id, name, PlaceLevel) AS 
(
	SELECT region_id, id, name, PlaceLevel=-1
	FROM geography
	WHERE name = 'Ivano-Frankivsk'
UNION ALL
	SELECT g.region_id, g.id, g.name, f.PlaceLevel+1
	FROM geography g INNER JOIN first_level_regions f
	ON g.region_id = f.place_id
)
SELECT region_id, place_id, name, PlaceLevel
FROM first_level_regions
WHERE PlaceLevel >=0
go

/* Task 4c */

;WITH regions(region_id, place_id, name, place_level) AS 
(
	SELECT region_id, id, name, place_level = 0
	FROM geography
	WHERE name = 'Ukraine'
UNION ALL
	SELECT g.region_id, g.id, g.name, f.place_level + 1
	FROM geography g INNER JOIN regions f
	ON g.region_id = f.place_id
)
SELECT region_id, name, place_level
FROM regions
ORDER BY place_level, name
go

/* Task 5c */

;WITH regions(region_id, place_id, name, place_level) AS 
(
	SELECT region_id, id, name, place_level = 1
	FROM geography
	WHERE name = 'Lviv'
UNION ALL
	SELECT g.region_id, g.id, g.name, f.place_level + 1
	FROM geography g INNER JOIN regions f
	ON g.region_id = f.place_id
)
SELECT region_id, name, place_level
FROM regions
ORDER BY place_level, name
go

/* Task 6c */

;WITH regions(region_id, place_id, name, treepath, place_level) AS 
(
	SELECT region_id, id, name, treepath = CAST(name AS VARCHAR(255)), place_level = 1
	FROM geography
	WHERE name = 'Lviv'
UNION ALL
	SELECT g.region_id, g.id, g.name, CAST(f.treepath + '/' + g.name AS VARCHAR(255)), f.place_level + 1
	FROM geography g INNER JOIN regions f
	ON g.region_id = f.place_id
)
SELECT place_level, name, treepath
FROM regions
go

/* Task 7c */

;WITH regions(region_id, place_id, name, treepath, place_level) AS 
(
	SELECT region_id, id, name, treepath = CAST(name AS VARCHAR(255)), place_level = 1
	FROM geography
	WHERE name = 'Lviv'
UNION ALL
	SELECT g.region_id, g.id, g.name, CAST(f.treepath + '/' + g.name AS VARCHAR(255)), f.place_level + 1
	FROM geography g INNER JOIN regions f
	ON g.region_id = f.place_id
)
SELECT name as Region, 'Lviv' AS center, place_level - 1 AS pathlen, treepath
FROM regions
WHERE place_level > 1
go

/* Task 4.1 */

SELECT * FROM suppliers
WHERE city = 'London'
UNION
SELECT * FROM suppliers
WHERE city = 'Paris';

/* Task 4.2 */

SELECT city FROM suppliers
UNION
SELECT city FROM details
ORDER BY city;

SELECT city FROM suppliers
UNION ALL
SELECT city FROM details
ORDER BY city;

/* Task 4.3 */

SELECT supplierid FROM suppliers
EXCEPT
SELECT DISTINCT supplierid FROM supplies
WHERE detailid IN (SELECT detailid FROM details WHERE city = 'London');

/* Task 4.4 */

(SELECT * FROM products
WHERE city IN ('Paris', 'London')
EXCEPT
SELECT * FROM products
WHERE city IN ('Paris', 'Roma'))

UNION ALL

(SELECT * FROM products
WHERE city IN ('Paris', 'Roma')
EXCEPT
SELECT * FROM products
WHERE city IN ('Paris', 'London'))

/* Task 4.5 */

SELECT supplierid, detailid, productid FROM supplies
WHERE supplierid IN (SELECT supplierid FROM suppliers WHERE city = 'London')

UNION

(SELECT supplierid, detailid, productid FROM supplies
WHERE detailid IN ( SELECT detailid FROM details WHERE color = 'Green')
EXCEPT 
SELECT supplierid, detailid, productid FROM supplies
WHERE productid IN (SELECT productid FROM products WHERE city = 'Paris')
);