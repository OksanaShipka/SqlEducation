USE master
GO

USE SalesOrders
GO

/* Task 1 */
SELECT DISTINCT CustCity
FROM Customers;

/* Task 2 */
SELECT CONCAT(EmpFirstName, ' ', EmpLastName) AS Employees, EmpPhoneNumber
FROM Employees;

/* Task 3 */
SELECT DISTINCT CategoryDescription
FROM Products
INNER JOIN Product_Vendors
ON Products.ProductNumber = Product_Vendors.ProductNumber
INNER JOIN Categories 
ON Categories.CategoryID = Products.CategoryID

/* Task 4 */
SELECT DISTINCT ProductName, RetailPrice, CategoryDescription
FROM Product_Vendors
INNER JOIN Products
ON Product_Vendors.ProductNumber = Products.ProductNumber
INNER JOIN Categories
ON Categories.CategoryID = Products.CategoryID

/* Task 5 */
SELECT VendName
FROM Vendors
ORDER BY VendZipCode;

/* Task 6 */
SELECT EmpFirstName, EmpLastName, EmpPhoneNumber, EmpAreaCode
FROM Employees
ORDER BY EmpLastName, EmpFirstName;

/* Task 7 */
SELECT VendName
FROM Vendors;

/* Task 8 */
SELECT DISTINCT CustState
FROM Customers;

/* Task 9 */
SELECT ProductName, RetailPrice
FROM Products;

/* Task 10 */
SELECT * 
FROM Employees;

/* Task 11 */
SELECT VendCity, VendName
FROM Vendors
ORDER BY VendCity;

/* Task 12 */
SELECT Orders.OrderNumber, MAX(Product_Vendors.DaysToDeliver) AS MaxDaysToDeliver
FROM Orders
INNER JOIN Order_Details
ON Orders.OrderNumber = Order_Details.OrderNumber
INNER JOIN Product_Vendors
ON Order_Details.ProductNumber = Product_Vendors.ProductNumber
GROUP BY Orders.OrderNumber
ORDER BY Orders.OrderNumber

/* Task 13 */
SELECT ProductNumber, ProductName, QuantityOnHand * RetailPrice AS Cost
FROM Products

/* Task 14 */
SELECT 
	DaysToDeliver.OrderNumber,
	DATEDIFF(day, Orders.OrderDate, Orders.ShipDate) + DaysToDeliver.MaxDaysToDeliver AS MaxDeliveryTime
FROM
	(SELECT Orders.OrderNumber, MAX(Product_Vendors.DaysToDeliver) MaxDaysToDeliver
		FROM Orders
		INNER JOIN Order_Details
		ON Orders.OrderNumber = Order_Details.OrderNumber
		INNER JOIN Product_Vendors
		ON Product_Vendors.ProductNumber = Order_Details.ProductNumber
		GROUP BY Orders.OrderNumber)
	AS DaysToDeliver
INNER JOIN Orders
ON DaysToDeliver.OrderNumber = Orders.OrderNumber

/* Task 15 */
; WITH RowCTE(row_no) AS
(
	SELECT row_no = 1
	UNION ALL
	SELECT row_no + 1 FROM RowCTE WHERE row_no < 10000
)
SELECT * FROM RowCTE
OPTION(maxrecursion 10000)

/* Task 16 */

; WITH rs (D, [name]) AS
(SELECT 
	CAST('20190101' AS [date]) AS D,
	DATENAME(WEEKDAY, '20190101')
UNION ALL
	SELECT DATEADD(day, 1, D), DATENAME(WEEKDAY, DATEADD(day, 1,D)) FROM rs
	WHERE D < '20191231'
	),
	rs1 AS
	(
		SELECT D, [name] FROM rs
		WHERE [name] IN ('Saturday', 'Sunday')
	)
		
SELECT COUNT(*) FROM rs1
OPTION (maxrecursion 366)
