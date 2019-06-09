USE master
GO

USE OA_module_3
GO

/* Task 1 */

UPDATE suppliers
SET rating = rating + 10
WHERE rating <
	(SELECT rating FROM suppliers WHERE supplierid = 4);

/* Task 2 */

DROP TABLE IF EXISTS productid_london 
GO

SELECT  DISTINCT supplies.productid
INTO productid_london
FROM supplies
INNER JOIN products
ON supplies.productid = products.productid
INNER JOIN suppliers
ON supplies.supplierid = suppliers.supplierid
WHERE products.city = 'London' OR suppliers.city = 'London'

/* Task 3 */

INSERT INTO products (productid, [name], city) 
VALUES (8, 'qlw', 'Paris');

DELETE FROM products 
FROM products
LEFT JOIN supplies
ON products.productid = supplies.productid
WHERE supplierid IS NULL;

/* Task 4 */

SELECT DISTINCT 
	s1.supplierid,
	CASE
		WHEN s1.detailid > s2.detailid
		THEN s2.detailid
		ELSE s1.detailid
	END detail1,
	CASE
		WHEN s1.detailid > s2.detailid
		THEN s1.detailid
		ELSE s2.detailid
	END detail2
INTO detail_pairs
FROM supplies s1
INNER JOIN (SELECT s2.supplierid, s2.detailid FROM supplies s2) s2
ON s1.supplierid = s2.supplierid
WHERE s1.detailid <> s2.detailid;

/* Task 5 */

UPDATE supplies
SET quantity = quantity * 1.1
FROM supplies
INNER JOIN details
ON supplies.productid = details.detailid
WHERE details.color = 'Red';

/* Task 6 */

SELECT DISTINCT color, city
INTO details_color_city 
FROM details;

/* Task 7 */

DROP TABLE IF EXISTS detailid_london 
GO

SELECT  DISTINCT supplies.detailid
INTO detailid_london
FROM supplies
INNER JOIN products
ON supplies.productid = products.productid
INNER JOIN suppliers
ON supplies.supplierid = suppliers.supplierid
WHERE products.city = 'London' OR suppliers.city = 'London';

/* Task 8 */

INSERT INTO suppliers (supplierid, [name], city) 
VALUES (10, 'White', 'New York');

/* Task 9 */

ALTER TABLE supplies
   DROP CONSTRAINT productid_fk;

ALTER TABLE supplies
   ADD CONSTRAINT productid_fk
   FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE;

DELETE 
FROM products 
WHERE city = 'Roma';

/* Task 10 */

DROP TABLE IF EXISTS all_cities
GO

SELECT * 
INTO all_cities
FROM (
	SELECT city
	FROM suppliers
	UNION
	SELECT city 
	FROM details
	UNION
	SELECT city 
	FROM products
) cities
ORDER BY 1;

/* Task 11 */

UPDATE details
SET color = 'Yellow'
WHERE color = 'Red' AND [weight] < 15;

/* Task 12 */

DROP TABLE IF EXISTS productid_city_o
GO

SELECT productid, city
INTO productid_city_o
FROM products
WHERE SUBSTRING (city, 2,1) = 'o';

/* Task 13 */

UPDATE suppliers
SET rating = rating + 10
FROM supplies
INNER JOIN suppliers
ON supplies.supplierid = suppliers.supplierid
WHERE quantity >
	(SELECT AVG (quantity) FROM supplies);

/* Task 14 */

DROP TABLE IF EXISTS suppliers_d1
GO

SELECT DISTINCT suppliers.supplierid, [name]
INTO suppliers_d1
FROM suppliers
INNER JOIN supplies
ON suppliers.supplierid = supplies.supplierid
WHERE detailid = 1
ORDER BY 1;

/* Task 15 */

INSERT INTO suppliers
VALUES
	(11, 'Black', 20, 'London'),
	(12, 'Red', 10, 'Paris');

/* Merge 1 */

DROP TABLE IF EXISTS tmp_details
GO

CREATE TABLE tmp_details (
	detailid integer PRIMARY KEY,
	[name] VARCHAR(20),
	color VARCHAR(20),
	[weight] integer,
	city VARCHAR(20)
)
GO

INSERT INTO tmp_Details (detailid, name, color, weight, city) 
VALUES 
	(1, 'Screw', 'Blue', 13, 'Osaka'),
	(2, 'Bolt', 'Pink', 12, 'Tokio'),
	(18, 'Whell-24', 'Red', 14, 'Lviv'),
	(19, 'Whell-28', 'Pink', 15, 'London');

/* Merge 2 */

MERGE details
    USING tmp_details
ON (details.detailid = tmp_details.detailid)
WHEN MATCHED
    THEN UPDATE SET 
        details.[name] = tmp_details.[name],
        details.color = tmp_details.color,
	    details.[weight] = tmp_details.[weight],
		details.city = tmp_details.city 
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (detailid, name, color, weight, city)
         VALUES (
			tmp_details.detailid,
			tmp_details.[name],
			tmp_details.color,
			tmp_details.[weight],
			tmp_details.city);