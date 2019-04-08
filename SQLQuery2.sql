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

SELECT laptop.code, laptop.model, grouped.hd, grouped.ram 
FROM laptop
INNER JOIN
(SELECT laptop.hd, laptop.ram FROM laptop
GROUP BY laptop.hd, laptop.ram
HAVING COUNT(*) = 2) AS grouped
ON laptop.hd = grouped.hd AND laptop.ram = grouped.ram
ORDER BY laptop.model DESC, grouped.hd DESC, grouped.ram DESC;

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
FROM (SELECT maker, [type], count(model) AS count_m
FROM product) AS info
PIVOT (SUM ([count_m])
FOR [type] IN (pc, laptop, printer) AS pvt_table;

SELECT *
FROM 
(SELECT * FROM product)
AS [source]
PIVOT
(
	COUNT(model)
	FOR [type] IN ([pc], [laptop], [printer])
)
AS [pivot];

