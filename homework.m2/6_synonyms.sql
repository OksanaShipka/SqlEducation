USE OA_module_2
GO

/* Create new schema */
CREATE SCHEMA O_Shipka
GO

/* Create synonyms for tables */
CREATE SYNONYM company_managers
FOR dbo.managers
GO

CREATE SYNONYM company_vehicles
FOR dbo.vehicles
GO

CREATE SYNONYM company_employees
FOR dbo.employees
GO

CREATE SYNONYM company_employees_log
FOR dbo.employees_log
GO

/* Test gettings information from synonyms */
SELECT *
INTO O_Shipka.managers
FROM company_managers
GO

SELECT *
INTO O_Shipka.vehicles
FROM company_vehicles
GO

SELECT *
INTO O_Shipka.employees
FROM company_employees
GO

SELECT *
INTO O_Shipka.employees_log
FROM company_employees_log