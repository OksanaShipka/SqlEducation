USE [labor_sql];
GO

/*Task 1*/

SELECT DISTINCT (maker), [type], speed, hd
FROM product
INNER JOIN pc 
ON product.model = pc.model
WHERE NOT hd > 8;

/*Task 2*/

SELECT  DISTINCT (maker) 
FROM product
INNER JOIN pc 
ON product.model = pc.model
WHERE NOT speed < 600;

/*Task 3*/

SELECT DISTINCT (maker)
FROM product
INNER JOIN laptop
ON product.model = laptop.model
WHERE NOT speed >500;

/*Task 4*/

SELECT MAX(code) as [model_code_max], MIN(code) as [model_code_min], hd, ram FROM
(
SELECT laptop.code, model, laptop.hd, laptop.ram 
FROM laptop
INNER JOIN
(SELECT laptop.hd, laptop.ram FROM laptop
GROUP BY laptop.hd, laptop.ram
HAVING COUNT(*) = 2) AS grouped
ON laptop.hd = grouped.hd AND laptop.ram = grouped.ram
) as models
GROUP BY model, hd, ram


/*Task 5*/

SELECT DISTINCT
	bb_classes.country,
	bb_classes.class AS bb_class,
	bc_classes.class AS bc_class
FROM
(SELECT * FROM classes WHERE [type] = 'bb')
AS bb_classes
INNER JOIN
(SELECT DISTINCT [class], [type], country
FROM classes
WHERE [type] = 'bc') AS bc_classes
ON bb_classes.country = bc_classes.country

/*Task 6*/

SELECT DISTINCT (product.model), maker
FROM product
LEFT JOIN pc
ON product.model = pc.model
WHERE pc.price < 600;

/*Task 7*/

SELECT DISTINCT (product.model), maker
FROM product
LEFT JOIN laptop
ON product.model=laptop.model
WHERE price > 300;

/*Task 8*/

SELECT maker, product.model, price
FROM product
INNER JOIN laptop
ON product.model = laptop.model

UNION

SELECT maker, product.model, price
FROM product
INNER JOIN pc
ON product.model = pc.model

/*Task 9*/

SELECT maker, product.model, price
FROM product
LEFT OUTER JOIN pc
ON product.model=pc.model
WHERE [type] = 'pc';

/*Task 10*/

SELECT  maker, [type], product.model, speed
FROM product
INNER JOIN laptop
ON product.model = laptop.model
WHERE speed > 600;

/*Task 11*/

SELECT ships.*, displacement
FROM ships
LEFT JOIN classes
ON ships.class = classes.class;

/*Task 12*/

SELECT ship, battle, [date]
FROM outcomes
LEFT JOIN battles
ON outcomes.battle = battles.name
WHERE NOT result = 'sunk';

/*Task 13*/

SELECT [name], country
FROM ships
LEFT JOIN classes
ON ships.class = classes.class;

/*Task 14*/

SELECT DISTINCT(plane), [name]
FROM trip
INNER JOIN company
ON trip.id_comp = company.id_comp
WHERE plane = 'Boeing';

/*Task 15*/

SELECT [name], [date]
FROM passenger
LEFT JOIN pass_in_trip
ON passenger.id_psg = pass_in_trip.id_psg;

/*Task 16*/

SELECT pc.model, speed, hd
FROM pc
LEFT JOIN product
ON pc.model = product.model
WHERE product.maker = 'A'
AND (hd = 10 OR hd = 20)
ORDER BY speed

/*Task 17*/

SELECT *
FROM
(SELECT maker, [type], model
FROM product)
AS info
PIVOT
(
	COUNT(model)
	FOR [type] IN ([pc], [laptop], [printer])
)
AS pvt_table;

/* Task 18 */

SELECT [avg],
 [11],[12],[14],[15]
 FROM (SELECT 'average price' AS 'avg', screen, price FROM Laptop) x
 PIVOT
 (AVG(price)
 FOR screen
 IN([11],[12],[14],[15])
 ) pvt;


/* Task 19 */


SELECT laptop.*, result.maker FROM laptop
CROSS APPLY 
(SELECT maker FROM product WHERE laptop.model = product.model) AS result

/* Task 20 */

SELECT * 
FROM laptop AS L1
CROSS APPLY 
(SELECT max(price) AS max_price FROM product 
JOIN laptop ON laptop.model = product.model
WHERE maker = (SELECT maker FROM product AS P2 WHERE P2.model = L1.model)) x;

/* Task 21 */

SELECT * FROM laptop L1
CROSS APPLY
(SELECT TOP 1 * FROM Laptop L2 
WHERE L1.model < L2.model OR (L1.model = L2.model AND L1.code < L2.code) 
ORDER BY model, code) X
ORDER BY L1.model;

/* Task 22 */

SELECT * FROM laptop L1
OUTER APPLY
(SELECT TOP 1 * 
FROM Laptop L2 
WHERE L1.model < L2.model OR (L1.model = L2.model AND L1.code < L2.code) 
ORDER BY model, code) X
ORDER BY L1.model;

/* Task 23 */

SELECT X.* FROM 
(SELECT DISTINCT [type] FROM product) Pr1 
CROSS APPLY 
(SELECT TOP 3 * FROM product Pr2 WHERE  Pr1.type=Pr2.type ORDER BY pr2.model) x;


/* Task 24 */

SELECT code, [name], [value] FROM Laptop
CROSS APPLY
(VALUES('speed', speed)
,('ram', ram)
,('hd', hd)
,('screen', screen)
) spec([name], [value])
WHERE code < 4 
ORDER BY code, [name], [value];
