USE [labor_sql];
GO

/*Task 1*/

/*Task 8*/

SELECT DISTINCT maker
FROM product
WHERE [type] = 'pc' AND maker NOT IN (SELECT maker FROM product WHERE [type] = 'laptop');

/*Task 9*/

SELECT DISTINCT maker
FROM product
WHERE [type] = 'pc'
AND maker <> ALL
	(SELECT maker FROM product WHERE [type] = 'laptop');

/*Task 10*/

SELECT DISTINCT (maker)
FROM product
WHERE [type] = 'pc'
AND NOT maker = ANY 
	(SELECT maker FROM product WHERE [type] = 'laptop');

/*Task 11*/

SELECT DISTINCT maker
FROM product
WHERE maker
IN (SELECT maker FROM product WHERE [type] = 'pc')
AND maker
IN (SELECT maker FROM product WHERE [type] = 'laptop')

/*Task 12*/
  
SELECT DISTINCT maker
FROM product
WHERE [type] = 'pc'
AND NOT maker <> ALL
	(SELECT maker FROM product WHERE [type] = 'laptop');

/*Task 13*/

SELECT DISTINCT (maker)
FROM product
WHERE [type] = 'pc'
AND maker = ANY
	(SELECT maker FROM product WHERE [type] = 'laptop');

/*Task 14*/

SELECT maker
FROM product
WHERE model = ANY (SELECT model FROM pc);

SELECT maker
FROM product
WHERE model IN (SELECT model FROM pc);

SELECT maker
FROM product
WHERE NOT model <> ALL (SELECT model FROM pc);

/* Task 15 */

IF EXISTS (SELECT * FROM classes WHERE country = 'Ukraine')
	SELECT class FROM classes WHERE country = 'Ukraine';
ELSE 
	SELECT country, class FROM classes;

/* Task 16 */

SELECT ship, battle, [date]
FROM Outcomes os, battles
WHERE EXISTS (SELECT ship 
 FROM Outcomes oa
 WHERE oa.ship = os.ship AND 
 result = 'damaged'
 ) AND 
 EXISTS (SELECT SHIP
 FROM Outcomes ou
 WHERE ou.ship=os.ship
 GROUP BY ship 
 HAVING COUNT(battle)>1
);

/*Task 17*/

SELECT maker, [type]
FROM product
WHERE EXISTS (SELECT model FROM pc);

/*Task 18*/

SELECT DISTINCT maker
FROM product
WHERE maker = 
	(SELECT maker FROM product WHERE model = 
		(SELECT model
		FROM pc WHERE speed = 
			(SELECT MAX(speed) FROM pc)
))
AND [type] = 'printer';

 
/*Task 19*/

 
/*Task 20*/

SELECT model, price
FROM printer
WHERE price = (SELECT MAX(price) FROM printer);

/*Task 21*/

SELECT DISTINCT [type], laptop.model, speed
FROM laptop
INNER JOIN product
ON laptop.model = product.model
WHERE speed < ANY (SELECT speed FROM pc)
AND [type] = 'laptop';

/*Task 22*/

SELECT maker, price
FROM printer
INNER JOIN product
ON printer.model = product.model
WHERE price = (SELECT MIN(price) FROM printer WHERE color = 'y') AND color = 'y';

/*Task 23*/

SELECT DISTINCT subquery.country,
	grouped.battle,
	grouped.total_ships
FROM (
SELECT 
	battle,
	COUNT(ship) as total_ships
FROM classes
INNER JOIN ships ON classes.class = ships.class
INNER JOIN outcomes ON outcomes.ship = ships.name
GROUP BY battle)
AS grouped
INNER JOIN 
(SELECT
	classes.country,
	outcomes.battle
FROM classes
INNER JOIN ships ON classes.class = ships.class
INNER JOIN outcomes ON outcomes.ship = ships.name)
AS subquery
ON grouped.battle = subquery.battle

/* Task 24 */

SELECT product.maker,
	COUNT(pc.model) AS pc_total,
	COUNT(laptop.model) AS laptop_total,
	COUNT(printer.model) AS printer_total
FROM product
LEFT JOIN pc ON product.model = pc.model
LEFT JOIN laptop ON product.model = laptop.model
LEFT JOIN printer ON product.model = printer.model
GROUP BY maker

/*Task 32*/

SELECT [name]
FROM ships
WHERE launched < 1942
UNION
SELECT ship
FROM outcomes
INNER JOIN battles
ON outcomes.battle = battles.name
WHERE YEAR(battles.date) < 1942;