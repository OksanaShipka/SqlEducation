USE master
GO

CREATE DATABASE OA_module_6
GO

USE OA_module_6
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
	

/* Task 1 */
SELECT 
	productid
	,name
	,city
	,ROW_NUMBER () OVER (ORDER BY city) AS row_number_
FROM products;

/* Task 2 */
SELECT 
	 productid
	,name
	,city
	,ROW_NUMBER () OVER (PARTITION BY city ORDER BY name) AS row_number_
FROM products;

/* Task 3 */
SELECT * 
FROM
	(SELECT 
	 productid
	,name
	,city
	,ROW_NUMBER () OVER (PARTITION BY city ORDER BY name) AS row_number_
	FROM products) AS cte_city
WHERE row_number_ = 1;

/* Task 4 */
SELECT
	productid
	,detailid
	,quantity
	,SUM(quantity) OVER (PARTITION BY productid) AS all_quantity_per_prod
	,SUM(quantity) OVER (PARTITION BY detailid) AS all_quantity_per_det
FROM supplies;
		
/* Task 5 */
SELECT * 
FROM
	(SELECT
	supplierid
	,detailid
	,productid
	,quantity
	,ROW_NUMBER () OVER (ORDER BY supplierid) AS rn
	,COUNT (supplierid) OVER () AS tot
	FROM supplies ) AS cte_supp
WHERE rn BETWEEN 10 AND 15;

/* Task 6 */
SELECT *
FROM
	(SELECT
	supplierid
	,detailid
	,productid
	,quantity
	,AVG (quantity) OVER () AS avg_qty
	FROM supplies) AS cte_avg
WHERE quantity < avg_qty;


	