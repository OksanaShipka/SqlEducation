USE [labor_sql];
GO

/*Task 1*/

SELECT maker,[type] 
FROM product
WHERE [type] = 'laptop'
ORDER BY maker ASC;

/* Task 2 */

SELECT model, ram, screen, price
FROM laptop
WHERE price > 1000
ORDER BY ram ASC, price DESC;

/* Task 3 */

SELECT * 
FROM printer
WHERE color = 'y'
ORDER BY price DESC;

/* Task 4 */

SELECT  model, speed, hd, cd, price
FROM pc
WHERE price < 600 AND (cd='12x' OR cd='24x')
ORDER BY speed DESC;

/* Task 5 */

SELECT  [name], class
FROM ships
ORDER BY [name] ASC;

/* Task 6 */

SELECT * 
FROM pc
WHERE speed >= 500 AND price < 800
ORDER by price DESC;

/* Task 7 */

SELECT * 
FROM printer
WHERE [type] = 'Matrix' AND price < 300
ORDER BY [type] DESC;

/* Task 8 */

SELECT model, speed
FROM pc
WHERE price BETWEEN 400 AND 600
ORDER BY hd ASC;

/* Task 9 */

SELECT model, speed, hd, price
FROM laptop
WHERE screen < 12
ORDER BY price DESC;

/* Task 10 */

SELECT model, [type], price
FROM printer
WHERE price < 300
ORDER BY [type] DESC;

/* Task 11 */

SELECT model, ram, price
FROM laptop
WHERE  ram = 64
ORDER BY screen ASC;

/* Task 12 */

SELECT model, ram, price
FROM pc
WHERE  ram > 64
ORDER BY hd ASC;

/* Task 13 */

SELECT model, speed, price
FROM pc
WHERE speed BETWEEN 500 AND 750
ORDER BY hd DESC;

/* Task 14 */

SELECT * 
FROM outcome_o
WHERE [out] > 2000
ORDER BY [date] DESC;

/* Task 15 */

SELECT * 
FROM income_o
WHERE [inc] BETWEEN 5000 AND 10000
ORDER BY [inc] ASC;

/* Task 16 */

SELECT * 
FROM income
WHERE point = 1
ORDER BY inc ASC;

/* Task 17 */

SELECT * 
FROM outcome
WHERE point = 2
ORDER BY [out] ASC;

/* Task 18 */

SELECT * 
FROM classes
WHERE country = 'Japan'
ORDER BY [type] DESC;

/* Task 19 */

SELECT [name], launched
FROM ships
WHERE launched BETWEEN 1920 AND 1942
ORDER BY launched DESC;

/* Task 20 */

SELECT ship, battle, result
FROM outcomes
WHERE battle = 'Guadalcanal' AND NOT result = 'sunk'
ORDER BY ship DESC;

/* Task 21 */

SELECT ship, battle, result
FROM outcomes
WHERE result = 'sunk'
ORDER BY ship DESC;

/* Task 22 */

SELECT class, displacement
FROM classes
WHERE displacement >= 40000
ORDER BY [type] ASC;

/* Task 23 */

SELECT trip_no, town_from, town_to
FROM trip
WHERE town_from = 'London' OR town_to = 'London'
ORDER BY time_out ASC;

/* Task 24 */

SELECT trip_no, plane, town_from, town_to
FROM trip
WHERE plane = 'TU-134'
ORDER BY time_out DESC;

/* Task 25 */

SELECT trip_no, plane, town_from, town_to
FROM trip
WHERE plane = 'IL-86'
ORDER BY plane ASC;

/* Task 26 */

SELECT trip_no, town_from, town_to
FROM trip
WHERE NOT (town_from = 'Rostov' OR town_to = 'Rostov')
ORDER BY plane ASC;

/* Task 27 */

SELECT model
FROM pc
WHERE model LIKE '%1%1%';

/* Task 28 */

SELECT *
FROM outcome
WHERE MONTH([date]) = 3;

/* Task 29 */
SELECT *
FROM outcome_o
WHERE DAY([date]) = 14;
 
/* Task 30 */

SELECT * 
FROM ships
WHERE [name] LIKE 'W%n';

/* Task 31 */
 
SELECT [name]
FROM ships
WHERE NOT ([name] LIKE '%e%e%e%') AND [name] LIKE '%e%e%';

/* Task 32 */

SELECT [name], launched
FROM ships
WHERE NOT [name] LIKE '%a'
 
/* Task 33 */

SELECT [name]
FROM battles
WHERE NOT [name] LIKE '%c' AND [name] LIKE '% %';

/* Task 34 */

SELECT *
FROM trip
WHERE DATEPART(HOUR, [time_out]) BETWEEN 12 AND 17;

/* Task 35 */

SELECT *
FROM trip
WHERE DATEPART(HOUR, [time_in]) BETWEEN 17 AND 23;

/* Task 36 */

SELECT *
FROM trip
WHERE DATEPART(HOUR, [time_in]) BETWEEN 21 AND 24 
	OR DATEPART(HOUR, [time_in]) BETWEEN 00 AND 10;
 
/* Task 37 */

SELECT [date]
FROM pass_in_trip
WHERE place LIKE '1%';

/* Task 38 */

SELECT [date]
FROM pass_in_trip
WHERE place LIKE '%c';
 
/*Task 39*/

SELECT * FROM
(
	SELECT SUBSTRING([name], CHARINDEX(' ', [name]) + 1, LEN([name]))
	AS LastName
	FROM passenger
) lastnames
WHERE LastName LIKE 'C%';

/*Task 40*/

SELECT * FROM
(
	SELECT SUBSTRING([name], CHARINDEX(' ', [name]) + 1, LEN([name]))
	AS LastName
	FROM passenger
) lastnames
WHERE LastName NOT LIKE ' J%'

/* Task 41 */
 
SELECT CONCAT('Середня ціна: ', AVG (price))
FROM laptop;

/* Task 42 */

SELECT 
	CONCAT ('model: ', model),
	CONCAT('speed: ', speed),
	CONCAT('ram: ', ram),
	CONCAT('hd: ', hd),
	CONCAT('cd: ', cd),
	CONCAT ('price: ', price) 
FROM pc;

/* Task 43 */

SELECT FORMAT([date], N'yyyy.MM.dd') AS [date]
FROM income;

/* Task 44 */

SELECT ship, battle,
CASE 
	WHEN result = 'sunk' THEN 'потонув'
	WHEN result = 'damaged' THEN 'поранений'
	WHEN result = 'OK' THEN 'в порядку'
END AS resut
FROM outcomes;

/* Task 45 */

SELECT CONCAT ('ряд: ', SUBSTRING (place, 1, 1)), 
       CONCAT ('місце: ', SUBSTRING (place, 2, 2))
FROM pass_in_trip;

/*TASK 46 */

SELECT CONCAT ('from ', town_from, 'to ', town_to)
FROM trip;

/*TASK 47 */

SELECT CONCAT (LEFT (trip_no, 1), RIGHT(trip_no, 1),
LEFT(ID_comp, 1), RIGHT(ID_comp, 1),
LEFT(TRIM(plane), 1), RIGHT(TRIM(plane), 1),
LEFT(TRIM(town_from), 1), RIGHT(TRIM(town_from), 1),
LEFT(TRIM(town_to), 1), RIGHT(TRIM(town_to), 1),
LEFT(FORMAT(time_out, 'yyyy/MM/dd h:mm:ss'), 1), RIGHT(FORMAT(time_out, 'yyyy/MM/dd h:mm:ss'), 1),
LEFT(FORMAT(time_in, 'yyyy/MM/dd h:mm:ss'), 1), RIGHT(FORMAT(time_in, 'yyyy/MM/dd h:mm:ss'), 1)
)
FROM trip;

 /*TASK 48 */

SELECT [maker], COUNT(model) AS [count]
FROM product
WHERE [type] = 'pc'
GROUP BY [maker]
HAVING COUNT(model) > 1

/*TASK 49 */

SELECT city, SUM([count]) as [count] FROM
(
(SELECT town_from as city, COUNT (town_from) as [count]
FROM trip
GROUP BY town_from)
UNION ALL

(SELECT town_to as city, COUNT (town_to) as [count]
FROM trip
GROUP BY town_to)
) AS [all]

GROUP BY [city]

 /* or */

SELECT DISTINCT 
city, city_from.[from],
city_to.[to],
city_from.[from] + city_to.[to] as [total]
FROM (
SELECT town_from as city
FROM trip
UNION ALL
SELECT town_to as city
FROM trip) cities
INNER JOIN

(SELECT town_from, COUNT(town_from) as [from]
FROM trip
GROUP BY town_from)
city_from
ON cities.city = city_from.town_from

INNER JOIN

(SELECT town_to, COUNT(town_to) as [to]
FROM trip
GROUP BY town_to)
city_to
ON cities.city = city_to.town_to

ORDER BY [total] DESC

/*TASK 50 */
  
SELECT [type], COUNT (model) AS count_model
FROM printer
GROUP BY [type];

/*TASK 51 */

SELECT cd, COUNT(DISTINCT model) as models FROM pc
GROUP BY cd
UNION ALL
SELECT 'Total:', COUNT(DISTINCT cd) FROM pc
   
/*TASK 52 */
  
SELECT DATEDIFF(minute,  time_out, time_in) / 60.0
FROM trip;

/*TASK 53 */

 SELECT by_point.point, by_point.date, by_point.sum_date, by_point.min, by_point.max, total_sum.total
FROM

(SELECT point,
		[date], 
		SUM([out]) AS [sum_date], 
		MIN([out]) AS [min], 
		MAX([out]) AS [max]
FROM outcome
GROUP BY point, [date]) AS by_point

INNER JOIN
   
(SELECT point, SUM([out]) AS total FROM outcome
GROUP BY point)
AS total_sum ON by_point.point = total_sum.point
ORDER BY by_point.point

/*TASK 54 */

SELECT [trip_no],
	SUM(CASE WHEN place LIKE '1%' THEN 1 ELSE 0 END) AS row_1,
	SUM(CASE WHEN place LIKE '2%' THEN 1 ELSE 0 END) AS row_2,
	SUM(CASE WHEN place LIKE '3%' THEN 1 ELSE 0 END) AS row_3,
	SUM(CASE WHEN place LIKE '4%' THEN 1 ELSE 0 END) AS row_4,
	SUM(CASE WHEN place LIKE '5%' THEN 1 ELSE 0 END) AS row_5,
	SUM(CASE WHEN place LIKE '6%' THEN 1 ELSE 0 END) AS row_6
FROM pass_in_trip
GROUP BY [trip_no];

/*TASK 55 */
   
SELECT
	SUM(CASE WHEN [name] LIKE '% S%' THEN 1 ELSE 0 END) AS "from_S",
	SUM(CASE WHEN [name] LIKE '% B%' THEN 1 ELSE 0 END) AS "from_B",
	SUM(CASE WHEN [name] LIKE '% A%' THEN 1 ELSE 0 END) AS "from_A"
FROM passenger;