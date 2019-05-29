USE OA_module_2
GO

/* Create main table */
DROP TABLE IF EXISTS employees
GO

CREATE TABLE employees (
	ID int IDENTITY(1,1) PRIMARY KEY,
	first_name NVARCHAR(255) NOT NULL,
	last_name NVARCHAR(255) NOT NULL,
	internal_code VARCHAR(12) NOT NULL,
	passport NVARCHAR(8) NULL,
	phone VARCHAR(25) NOT NULL,
	[address] NVARCHAR(100) NULL,
	birthday DATE NULL,
	employment_date DATE NOT NULL,
	unique_id NVARCHAR(10) NOT NULL UNIQUE,
	email VARCHAR(50) NULL,
	inserted_date DATETIME NOT NULL DEFAULT GETDATE(),
	updated_date DATETIME NULL
)
GO

/* Create log table */
DROP TABLE IF EXISTS employees_log
GO

CREATE TABLE employees_log (
	ID int,
	first_name NVARCHAR(255) NOT NULL,
	last_name NVARCHAR(255) NOT NULL,
	internal_code VARCHAR(12) NOT NULL,
	passport NVARCHAR(8) NULL,
	phone VARCHAR(25) NOT NULL,
	[address] NVARCHAR(100) NULL,
	birthday DATE NULL,
	employment_date DATE NOT NULL,
	unique_id NVARCHAR(10) NOT NULL,
	email VARCHAR(50) NULL,
	inserted_date DATETIME NOT NULL,
	updated_date DATETIME NULL,
	operation_type VARCHAR(10) NOT NULL,
	operation_timestamp DATETIME NOT NULL DEFAULT GETDATE()
)
GO

/* Create INSERT trigger */
DROP TRIGGER IF EXISTS on_employee_insert
GO

CREATE TRIGGER on_employee_insert
ON employees
AFTER INSERT
AS
	INSERT INTO employees_log
	SELECT *,
		'INSERTED',
		GETDATE()
	FROM inserted
GO

/* Create UPDATE trigger */
DROP TRIGGER IF EXISTS on_employee_update
GO

CREATE TRIGGER on_employee_update
ON employees
AFTER UPDATE
AS
	INSERT INTO employees_log
	SELECT *,
		'UPDATED',
		GETDATE()
	FROM inserted
GO

/* Create DELETE trigger */
DROP TRIGGER IF EXISTS on_employee_delete
GO

CREATE TRIGGER on_employee_delete
ON employees
AFTER DELETE
AS
	INSERT INTO employees_log
	SELECT *,
		'DELETED',
		GETDATE()
	FROM deleted
GO
