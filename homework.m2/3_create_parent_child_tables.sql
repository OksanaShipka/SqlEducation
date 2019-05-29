USE OA_module_2
GO

/* Create parent table */
DROP TABLE IF EXISTS managers
GO

CREATE TABLE managers (
	ID int IDENTITY(1,1) PRIMARY KEY,
	first_name NVARCHAR(255) NOT NULL,
	last_name NVARCHAR(255) NOT NULL,
	code VARCHAR(12) NOT NULL,
	passport NVARCHAR(8) NULL,
	phone VARCHAR(25) NOT NULL,
	[address] NVARCHAR(100) NULL,
	birthday DATE NULL,
	employment_date DATE NOT NULL,
	unique_id VARCHAR(10) NOT NULL UNIQUE,
	email VARCHAR(50) NULL,
	inserted_date DATETIME NOT NULL DEFAULT GETDATE(),
	updated_date DATETIME NULL,
	CONSTRAINT check_unique_id_length CHECK (LEN(unique_id) = 10),
	CONSTRAINT check_unique_id_digits_only CHECK (unique_id NOT LIKE '%[^0-9]%')
)
GO

/* Create child table */
DROP TABLE IF EXISTS vehicles
GO

CREATE TABLE vehicles (
	ID int IDENTITY(1,1) PRIMARY KEY,
	manager_id int,
	plates_number NVARCHAR(10) NOT NULL UNIQUE,
	model NVARCHAR(50),
	issued_year DATE NULL,
	color varchar(20) NULL,
	fuel varchar(20) NULL,
	engine decimal(5,2) NOT NULL,
	mileage int NOT NULL,
	inserted_date DATETIME NOT NULL DEFAULT GETDATE(),
	updated_date DATETIME NULL,
	CONSTRAINT check_engine CHECK (engine > 0),
	CONSTRAINT check_mileage CHECK (mileage >= 0),
	CONSTRAINT manager_fk FOREIGN KEY (manager_id) REFERENCES [managers] (ID) ON DELETE CASCADE
)
GO

/* Create parent table update trigger */
DROP TRIGGER IF EXISTS managers_on_update
GO

CREATE TRIGGER managers_on_update
ON managers
AFTER UPDATE
AS
	UPDATE managers
	SET updated_date = GETDATE()
	WHERE ID IN (SELECT DISTINCT ID FROM inserted)
GO

/* Create child table trigger */
DROP TRIGGER IF EXISTS vehicles_on_update
GO

CREATE TRIGGER vehicles_on_update
ON vehicles
AFTER UPDATE
AS
	UPDATE vehicles
	SET updated_date = GETDATE()
	WHERE ID IN (SELECT DISTINCT ID FROM inserted)

GO

/* Create parent table view */
DROP VIEW IF EXISTS main_managers_info
GO

CREATE VIEW main_managers_info
AS
SELECT 
	ID,
	first_name + ' ' + last_name AS [name],
	code,
	phone
FROM managers
GO

/* Create childtable view */
DROP VIEW IF EXISTS main_vehicles_info
GO

CREATE VIEW main_vehicles_info
AS
	SELECT 
		vehicles.ID,
		managers.first_name + ' ' + managers.last_name AS manager_name,
		plates_number
	FROM vehicles
	INNER JOIN managers
	ON manager_id = managers.ID
GO

/* Create parent table view with check option */
DROP VIEW IF EXISTS managers_with_email
GO

CREATE VIEW managers_with_email
AS
	SELECT *
	FROM managers
	WHERE email IS NOT NULL
WITH CHECK OPTION
GO