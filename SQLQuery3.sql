USE [labor_sql];
GO

/*Task 4*/
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

/*Task 5*/
; WITH RowCTE(row_no) AS
(
	SELECT row_no = 1
	UNION ALL
	SELECT row_no + 1 FROM RowCTE WHERE row_no < 10000
)
SELECT * FROM RowCTE
option(maxrecursion 10000)

/*Task 6*/
; WITH RowCTE(row_no) AS
(
	SELECT row_no = 1
	UNION ALL
	SELECT row_no + 1 FROM RowCTE WHERE row_no < 100000
)
SELECT * FROM RowCTE
option(maxrecursion 100000)

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

/* Task 25 */

SELECT DISTINCT
	maker,
	CASE WHEN total_pc > 0 THEN CONCAT('yes(', total_pc, ')') ELSE 'no' END AS pc,
	CASE WHEN total_laptop > 0 THEN CONCAT('yes(', total_laptop, ')') ELSE 'no' END AS laptop,
	CASE WHEN total_printer > 0 THEN CONCAT('yes(', total_printer, ')') ELSE 'no' END AS printers
FROM product AS makers
CROSS APPLY
(SELECT COUNT(*) AS total_pc
	FROM pc INNER JOIN product
	ON pc.model = product.model
	WHERE product.maker = makers.maker) as pcs
CROSS APPLY
(SELECT COUNT(*) AS total_laptop
	FROM laptop INNER JOIN product
	ON laptop.model = product.model
	WHERE product.maker = makers.maker) as laptops
CROSS APPLY
(SELECT COUNT(*) AS total_printer
	FROM printer INNER JOIN product
	ON printer.model = product.model
	WHERE product.maker = makers.maker) as printers

/* Task 26 */ 

SELECT DISTINCT
	points.point,
	dates.[date],
	outcomes_total.[out],
	incomes_total.inc FROM
(
SELECT point from outcome_o
UNION SELECT point from income_o
) as points
CROSS APPLY
(
SELECT date from outcome_o
UNION SELECT date from income_o
) as dates
LEFT JOIN 
	(SELECT [out], [date], point
		FROM outcome_o) AS outcomes_total
		ON outcomes_total.[date] = dates.[date]
			AND outcomes_total.point = points.point
LEFT JOIN
	(SELECT inc, [date], point
		FROM income_o) AS incomes_total
		ON incomes_total.[date] = dates.[date]
			AND incomes_total.point = points.point
WHERE
	outcomes_total.[out] IS NOT NULL
	OR incomes_total.inc IS NOT NULL

/* Task 27 */ 

SELECT [name], numGuns, bore, displacement, [type], country, launched, [class]
FROM
(
SELECT 
	ships.[name],
	classes.numGuns,
	classes.bore,
	classes.displacement,
	classes.[type],
	classes.country,
	ships.launched,
	classes.class,
		CASE WHEN numGuns = 8 THEN 1 ELSE 0 END
		+ CASE WHEN bore = 15 THEN 1 ELSE 0 END
		+ CASE WHEN displacement = 32000 THEN 1 ELSE 0 END
		+ CASE WHEN [type] = 'bb' THEN 1 ELSE 0 END
		+ CASE WHEN country = 'USA' THEN 1 ELSE 0 END
		+ CASE WHEN launched = 1915 THEN 1 ELSE 0 END
		+ CASE WHEN classes.class = 'Kongo' THEN 1 ELSE 0 END AS [validation]
FROM ships
INNER JOIN classes
ON ships.class = classes.class)
AS result
WHERE [validation] >= 4

/* Task 28 */ 

SELECT 
	point,
	left_side.[date],
	CASE
		WHEN once_a_day.out > multiple_times.out THEN 'once a day'
		WHEN once_a_day.out < multiple_times.out THEN 'more than once a day'
		WHEN once_a_day.out = multiple_times.out THEN 'both'
	END
FROM
(
SELECT DISTINCT outcome.point, dates.[date]
FROM outcome
CROSS APPLY
(SELECT [date], point
FROM outcome_o
UNION SELECT [date], point
FROM outcome)
AS dates
WHERE outcome.point = dates.point) AS left_side
LEFT JOIN
(SELECT SUM([out]) as [out], [date]
FROM outcome
GROUP BY [date]) AS multiple_times
ON left_side.date = multiple_times.[date]
LEFT JOIN
(SELECT [out], [date]
FROM outcome_o) AS once_a_day
ON left_side.date = once_a_day.date

/* Task 29 */

SELECT 'B' As maker, 'pc' AS [type], model, price
FROM pc
WHERE model IN (SELECT model FROM product WHERE [type] = 'pc' AND maker = 'B')
UNION ALL
SELECT 'B' As maker, 'laptop' AS [type], model, price
FROM laptop
WHERE model IN (SELECT model FROM product WHERE [type] = 'laptop' AND maker = 'B')
UNION ALL
SELECT 'B' As maker, 'printer' AS [type], model, price
FROM printer
WHERE model IN (SELECT model FROM product WHERE [type] = 'printer' AND maker = 'B')

/* Task 30 */
SELECT [name], class
FROM ships
WHERE [name] = class

UNION

SELECT ship, ship
FROM outcomes
WHERE ship IN (SELECT class FROM classes);

/* Task 31 */

SELECT class, COUNT([name])
FROM ships
GROUP BY class;

/*Task 32 */

SELECT [name]
FROM ships
WHERE launched < 1942
UNION
SELECT ship
FROM outcomes
INNER JOIN battles
ON outcomes.battle = battles.name
WHERE YEAR(battles.date) < 1942;