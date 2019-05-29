USE OA_module_2
GO

/* Insert valid record to parent table */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John'
           ,'Smith'
           ,'AB1234'
           ,'KB123456'
           ,'+3809300998877'
           ,'Lviv, Noname str'
           ,'1987-03-23'
           ,'2019-05-20 12:35:29.123'
           ,'1234567890'
           ,'test@test.com')
GO

/* VARCHAR length exceeded - column [code] */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John'
           ,'Smith'
           ,'123456789123456789'
           ,'KB123456'
           ,'+3809300998877'
           ,'Lviv, Noname str'
           ,'1987-03-23'
           ,'2019-05-20 12:35:29.123'
           ,'1234567890'
           ,'test@test.com')
GO

/* Insert NULL into not-nullable column - column [code] */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John'
           ,'Smith'
           ,NULL
           ,'KB1234567'
           ,'+3809300998877'
           ,'Lviv, Noname str'
           ,'1987-03-23'
           ,'2019-05-20 12:35:29.123'
           ,'1234567890'
           ,'test@test.com')
GO

/* Insert non-unique value */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John_new'
           ,'Smith_new'
           ,'AB9999'
           ,'KB9999'
           ,'+3809998835'
           ,'Kyiv, Noname str'
           ,'1978-03-23'
           ,'2018-05-20 12:35:29.123'
           ,'1234567890'
           ,'test2@test.com')
GO

/* Invalid unique identifier length - column unique_id */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John_new'
           ,'Smith_new'
           ,'AB9999'
           ,'KB9999'
           ,'+3809998835'
           ,'Kyiv, Noname str'
           ,'1978-03-23'
           ,'2018-05-20 12:35:29.123'
           ,'98765432'
           ,'test2@test.com')
GO

/* Invalid unique identifier format - column unique_id */
INSERT INTO [dbo].[managers]
           ([first_name]
           ,[last_name]
           ,[code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John_new'
           ,'Smith_new'
           ,'AB9999'
           ,'KB9999'
           ,'+3809998835'
           ,'Kyiv, Noname str'
           ,'1978-03-23'
           ,'2018-05-20 12:35:29.123'
           ,'ABCDEFGHIJ'
           ,'test2@test.com')
GO

/* Insert valid record to child table */
INSERT INTO [dbo].[vehicles]
           ([manager_id]
           ,[plates_number]
           ,[model]
           ,[issued_year]
           ,[color]
           ,[fuel]
           ,[engine]
           ,[mileage])
	SELECT ID,
		'BC1234AH',
		'Toyota',
		'2008-03-01',
		'Black',
		'Diesel',
		2.0,
		100000
	FROM managers
	WHERE unique_id = '1234567890'
GO

/* invalid foreign key value */
INSERT INTO [dbo].[vehicles]
           ([manager_id]
           ,[plates_number]
           ,[model]
           ,[issued_year]
           ,[color]
           ,[fuel]
           ,[engine]
           ,[mileage])
		VALUES
		(99999,
		'BC0000AH',
		'Tesla',
		'2007-03-01',
		'Red',
		'Petrol',
		1.6,
		200000)
GO

/* Non unique value - column planes_number */
INSERT INTO [dbo].[vehicles]
           ([manager_id]
           ,[plates_number]
           ,[model]
           ,[issued_year]
           ,[color]
           ,[fuel]
           ,[engine]
           ,[mileage])
	SELECT ID,
		'BC1234AH',
		'Tesla',
		'2007-03-01',
		'Red',
		'Petrol',
		1.6,
		200000
	FROM managers
	WHERE unique_id = '1234567890'
GO

/* Negative values */
INSERT INTO [dbo].[vehicles]
           ([manager_id]
           ,[plates_number]
           ,[model]
           ,[issued_year]
           ,[color]
           ,[fuel]
           ,[engine]
           ,[mileage])
	SELECT ID,
		'BC0000AH',
		'Tesla',
		'2007-03-01',
		'Red',
		'Petrol',
		-2,
		-200000
	FROM managers
	WHERE unique_id = '1234567890'
GO

/* Insert valid record to table with logging */
INSERT INTO [dbo].[employees]
           ([first_name]
           ,[last_name]
           ,[internal_code]
           ,[passport]
           ,[phone]
           ,[address]
           ,[birthday]
           ,[employment_date]
           ,[unique_id]
           ,[email])
     VALUES
           ('John'
           ,'Smith'
           ,'AB1234'
           ,'KB123456'
           ,'+3809300998877'
           ,'Lviv, Noname str'
           ,'1987-03-23'
           ,'2019-05-20 12:35:29.123'
           ,'1234567890'
           ,'test@test.com')
GO