
USE master
CREATE DATABASE CarDealership

GO
ALTER DATABASE CarDealership SET RECOVERY SIMPLE
GO

USE CarDealership

CREATE TABLE dbo.Manufacturers (ManufacturerID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
ManufacturerName nvarchar(50), 
Country nvarchar(50), 
Adres nvarchar(50), 
ExtraDescription nvarchar(50))

CREATE TABLE dbo.ExtraEquipments (ExtraEquipmentID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
EquipmentName nvarchar(50), 
EquipmentStats nvarchar(50), 
Price decimal(18,2))

CREATE TABLE dbo.CarcaseTypes (CarcaseTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
TypeName nvarchar(50), 
TypeDescription nvarchar(50))

CREATE TABLE dbo.CarModels (ModelID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
ModelName nvarchar(50))

CREATE TABLE dbo.Cars (CarID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
RegistrationNumber nvarchar(20),
ModelId int,
ManufacturerId int,
Photo image,
CarcaseTypeId int,
ReleaseYear date,
Color nvarchar(50),
CarcaseNumber nvarchar(50),
EngineNumber nvarchar(50),
CarsStats nvarchar(50),
Price decimal(18,2),
SellerEmployeeId int) -- автомобили

CREATE TABLE dbo.CarsEquipments (CarEquipmentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
CarId int,
EquipmentId int) -- должности

CREATE TABLE dbo.Positions (PositionID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
PositionName nvarchar(50),
Salary decimal(18,2)) -- должности

CREATE TABLE dbo.Employees (EmployeeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
FirstName nvarchar(50),
LastName nvarchar(50),
Age int,
PositionID int) -- сотрудники

CREATE TABLE dbo.Clients (ClientID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
FamilyName nvarchar(20),
[Name] nvarchar(20),
Surname nvarchar(20),
Adres nvarchar(20),
Telephone varchar(12),
PassportData nvarchar(50),
CarId int,
OrderDate date,
SaleDate date,
IsSold bit,
IsPayed bit,
Rrepayment decimal(18,2),
ClientEmployeeId int) -- автомобили

-- Добавление связей между таблицами
ALTER TABLE dbo.Cars  WITH CHECK ADD  CONSTRAINT FK_Cars_CarModels FOREIGN KEY(ModelId)
REFERENCES dbo.CarModels (ModelID) ON DELETE CASCADE
GO
ALTER TABLE dbo.Cars  WITH CHECK ADD  CONSTRAINT FK_Cars_Manufacturers FOREIGN KEY(ManufacturerId)
REFERENCES dbo.Manufacturers (ManufacturerID) ON DELETE NO ACTION
GO
ALTER TABLE dbo.Cars  WITH CHECK ADD  CONSTRAINT FK_Cars_CarcaseTypes FOREIGN KEY(CarcaseTypeId)
REFERENCES dbo.CarcaseTypes (CarcaseTypeID) ON DELETE NO ACTION
GO
ALTER TABLE dbo.Cars  WITH CHECK ADD  CONSTRAINT FK_Cars_Employees FOREIGN KEY(SellerEmployeeId)
REFERENCES dbo.Employees (EmployeeID) ON DELETE CASCADE
GO
ALTER TABLE dbo.Employees  WITH CHECK ADD  CONSTRAINT FK_Employees_Positions FOREIGN KEY(PositionID)
REFERENCES dbo.Positions (PositionID) ON DELETE CASCADE
GO
ALTER TABLE dbo.Clients  WITH CHECK ADD  CONSTRAINT FK_Clients_Cars FOREIGN KEY(CarId)
REFERENCES dbo.Cars (CarID) ON DELETE CASCADE
GO
ALTER TABLE dbo.Clients  WITH CHECK ADD  CONSTRAINT FK_Clients_Employees FOREIGN KEY(ClientEmployeeId)
REFERENCES dbo.Employees (EmployeeID) ON DELETE NO ACTION
GO
ALTER TABLE dbo.CarsEquipments  WITH CHECK ADD  CONSTRAINT FK_CarsEquipments_Cars FOREIGN KEY(CarId)
REFERENCES dbo.Cars (CarID) ON DELETE CASCADE
GO
ALTER TABLE dbo.CarsEquipments  WITH CHECK ADD  CONSTRAINT FK_CarsEquipments_ExtraEquipments FOREIGN KEY(EquipmentId)
REFERENCES dbo.ExtraEquipments (ExtraEquipmentID) ON DELETE CASCADE
GO

SET NOCOUNT ON


DECLARE @Symbol CHAR(52)= 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
		@Position int,
		@ManufacturerName nvarchar(50), 
		@Country nvarchar(50), 
		@Adres nvarchar(50), 
		@ExtraDescription nvarchar(50),
		@EquipmentName nvarchar(50), 
		@EquipmentStats nvarchar(50), 
		@Price decimal(18,2),
		@PositionName nvarchar(50),
		@Salary decimal(18,2),
		@FirstName nvarchar(50),
		@LastName nvarchar(50),
		@Age int,
		@PositionID int,
		@ModelName nvarchar(50),
		@Specifications nvarchar(50),
		@RegistrationNumber nvarchar(20),
		@ModelId int,
		@CarcaseNumber nvarchar(17),
		@EngineNumber nvarchar(17),
		@ReleaseYear date,
		@Mileage int,
		@DriverId int,
		@LastTI date,
		@MechanicId int,
		@SpecialMarks nvarchar(50),
		@i int,
		@NameLimit int,
		@odate date,
		@Inc_Exp real,
		@RowCount INT,
		@NumberExtraEquipments int,
		@NumberManufacturers int,
		@NumberPositions int,
		@NumberEmployees int,
		@NumberCarModels int,
		@NumberCars int,
		@MinNumberSymbols int,
		@MaxNumberSymbols int


SET @NumberManufacturers = 500
SET @NumberExtraEquipments = 500
SET @NumberPositions = 500
SET @NumberCarModels = 500
SET @NumberCars = 20000
SET @NumberEmployees = 20000


BEGIN TRAN
SELECT @i=0 FROM dbo.ExtraEquipments WITH (TABLOCKX) WHERE 1=0
	SET @RowCount=1
	SET @MinNumberSymbols=5
	SET @MaxNumberSymbols=50	
	WHILE @RowCount<=@NumberExtraEquipments
	BEGIN		
		SET @NameLimit=@MinNumberSymbols+RAND()*(@MaxNumberSymbols-@MinNumberSymbols) -- имя от 5 до 50 символов
		SET @i=1
        SET @EquipmentName=''
		SET @EquipmentStats=''
		WHILE @i<=@NameLimit
		BEGIN
			SET @Position=RAND()*52
			SET @EquipmentName = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Position=RAND()*52
			SET @EquipmentStats = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Price = ROUND(RAND(CHECKSUM(NEWID())) * (100), 2)
			SET @i=@i+1
		END
		INSERT INTO dbo.ExtraEquipments (EquipmentName, EquipmentStats, Price) SELECT @EquipmentName, @EquipmentStats, @Price
		SET @RowCount +=1
	END
SELECT @i=0 FROM dbo.Manufacturers WITH (TABLOCKX) WHERE 1=0
	SET @RowCount=1
	SET @MinNumberSymbols=5
	SET @MaxNumberSymbols=50	
	WHILE @RowCount<=@NumberManufacturers
	BEGIN		
		SET @NameLimit=@MinNumberSymbols+RAND()*(@MaxNumberSymbols-@MinNumberSymbols) -- имя от 5 до 50 символов
		SET @i=1
        SET @ManufacturerName=''
		SET @Country=''
		SET @Adres=''
		SET @ExtraDescription=''
		WHILE @i<=@NameLimit
		BEGIN
			SET @Position=RAND()*52
			SET @ManufacturerName = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Position=RAND()*52
			SET @Country = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Position=RAND()*52
			SET @Adres = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Position=RAND()*52
			SET @ExtraDescription = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @i=@i+1
		END
		INSERT INTO dbo.Manufacturers (ManufacturerName, Country, Adres, ExtraDescription) SELECT @ManufacturerName, @Country, @Adres, @ExtraDescription
		SET @RowCount +=1
	END
SELECT @i=0 FROM dbo.Positions WITH (TABLOCKX) WHERE 1=0
	SET @RowCount=1
	SET @MinNumberSymbols=5
	SET @MaxNumberSymbols=50	
	WHILE @RowCount<=@NumberPositions
	BEGIN		
		SET @NameLimit=@MinNumberSymbols+RAND()*(@MaxNumberSymbols-@MinNumberSymbols) -- имя от 5 до 50 символов
		SET @i=1
        SET @PositionName=''
		WHILE @i<=@NameLimit
		BEGIN
			SET @Position=RAND()*52
			SET @PositionName = @PositionName + SUBSTRING(@Symbol, @Position, 1)
			SET @Salary = ROUND(RAND(CHECKSUM(NEWID())) * (100), 2)
			SET @i=@i+1
		END
		INSERT INTO dbo.Positions (PositionName, Salary) SELECT @PositionName, @Salary
		SET @RowCount +=1
	END
SELECT @i=0 FROM dbo.Employees WITH (TABLOCKX) WHERE 1=0
	SET @RowCount=1
	SET @MinNumberSymbols=5
	SET @MaxNumberSymbols=50	
	WHILE @RowCount<=@NumberEmployees
	BEGIN		

		SET @NameLimit=@MinNumberSymbols+RAND()*(@MaxNumberSymbols-@MinNumberSymbols) -- имя от 5 до 50 символов
		SET @i=1
        SET @FirstName = ''
		SET @LastName = ''
		WHILE @i<=@NameLimit
		BEGIN
			SET @Position=RAND()*52
			SET @FirstName = @FirstName + SUBSTRING(@Symbol, @Position, 1)
			SET @Position=RAND()*52
			SET @LastName = @LastName + SUBSTRING(@Symbol, @Position, 1)
			SET @Age = CAST(RAND()*52 as int)
			SET @PositionID = CAST( (1+RAND()*(@NumberPositions-1)) as int)
			SET @i=@i+1
		END

		INSERT INTO dbo.Employees (FirstName, LastName, Age, PositionID) SELECT @FirstName, @LastName, @Age, @PositionID
		

		SET @RowCount +=1
	END

SELECT @i=0 FROM dbo.CarModels WITH (TABLOCKX) WHERE 1=0
	SET @RowCount=1
	SET @MinNumberSymbols=5
	SET @MaxNumberSymbols=50	
	WHILE @RowCount<=@NumberCarModels
	BEGIN		

		SET @NameLimit=@MinNumberSymbols+RAND()*(@MaxNumberSymbols-@MinNumberSymbols) -- имя от 5 до 50 символов
		SET @i=1
        SET @ModelName = ''
		WHILE @i<=@NameLimit
		BEGIN
			SET @Position=RAND()*52
			SET @ModelName = @ModelName + SUBSTRING(@Symbol, @Position, 1)
			SET @i=@i+1
		END
		INSERT INTO dbo.CarModels (ModelName) SELECT @ModelName
		SET @RowCount +=1
	END
COMMIT TRAN
GO
CREATE VIEW [dbo].[View_EmployeeAndPositions]
AS
SELECT        dbo.Employees.EmployeeID, dbo.Employees.FirstName, dbo.Employees.LastName, dbo.Employees.Age, dbo.Employees.PositionID, 
				dbo.Positions.PositionName, dbo.Positions.Salary 
FROM            dbo.Positions INNER JOIN
                         dbo.Employees ON dbo.Positions.PositionID = dbo.Employees.PositionID
GO

CREATE PROCEDURE AddExtraEqupment (@EquipmentName nvarchar(20), @EquipmentStats int, @Price decimal(18,2))
        AS INSERT INTO dbo.ExtraEquipments(
		EquipmentName,
		EquipmentStats,
		Price
		) 
		VALUES
		(@EquipmentName,
		@EquipmentStats,
		@Price)
GO
CREATE PROCEDURE AddEmployee (@FirstName nvarchar(50), @LastName nvarchar(50), @Age int, @PositionID int)
        AS INSERT INTO dbo.Employees(
		FirstName,
		LastName,
		Age,
		PositionID) 
		VALUES
		(@FirstName, 
		@LastName , 
		@Age, 
		@PositionID)
GO
CREATE PROCEDURE UpdateManufacturerAdres (@ManufacturerId int, @NewAdres nvarchar(50))
        AS UPDATE dbo.Manufacturers
        SET Adres = @NewAdres
		WHERE(
		dbo.Manufacturers.ManufacturerID = @NewAdres
		);
GO