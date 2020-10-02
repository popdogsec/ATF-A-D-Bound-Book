CREATE TABLE BoundBook(

aquisitionDate DATE NOT NULL,
aquisitionType VARCHAR(100) NOT NULL,
aquisitionName VARCHAR(100) NOT NULL,
aquisitionAddress VARCHAR(100),
aquisitionFFL VARCHAR(20),
assetType VARCHAR(25) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
importer VARCHAR(50),
make VARCHAR(50) NOT NULL,
caliberGauge VARCHAR(25) NOT NULL,
serial VARCHAR(30) NOT NULL,
dispositionDate DATE,
dispositionType VARCHAR(100),
dispositionName VARCHAR(100),
dispositionAddress VARCHAR(100),
disposition4473 VARCHAR(12)
dispositionNICS VARCHAR(15),
dispositionFFL VARCHAR(20),

Constraint PK_BoundBook PRIMARY KEY (aquisitionDate, serial));

GO

CREATE PROCEDURE aquisition

@FromFFL BIT,
@aquisitionDate DATE,
@aquisitionType VARCHAR(100),
@aquisitionName VARCHAR(100),
@aquisitionAddress VARCHAR(100),
@aquisitionFFL VARCHAR(20),
@assetType VARCHAR(25),
@manufacturer VARCHAR(50),
@importer VARCHAR(50),
@make VARCHAR(50),
@caliberGauge VARCHAR(25),
@serial VARCHAR(30)
	
AS

IF EXISTS(SELECT * FROM BoundBook WHERE serial = @serial AND dispositionDate IS NOT NULL) OR NOT EXISTS(SELECT * FROM BoundBook WHERE serial = @serial)
	BEGIN
		IF (@FromFFL = 1) INSERT INTO BoundBook (aquisitionDate, aquisitionType, aquisitionName, aquisitionFFL, assetType, manufacturer, importer, make, caliberGauge, serial) VALUES (@aquisitionDate, @aquisitionType, @aquisitionName, @aquisitionFFL, @assetType, @manufacturer, @importer, @make, @caliberGauge, @serial);

		ELSE INSERT INTO BoundBook (aquisitionDate, aquisitionType, aquisitionName, aquisitionAddress, assetType, manufacturer, importer, make, caliberGauge, serial) VALUES (@aquisitionDate, @aquisitionType, @aquisitionName, @aquisitionAddress, @assetType, @manufacturer, @importer, @make, @caliberGauge, @serial);
	END
ELSE
	BEGIN
	PRINT 'Cannot aquire asset that has already been aquired but not disposed'
	END
GO

CREATE PROCEDURE disposition

@ToFFL BIT,
@Serial VARCHAR(30),
@dispositionDate DATE,
@dispositionType VARCHAR(100),
@dispositionName VARCHAR(100),
@dispositionAddress VARCHAR(100),
@disposition4473 VARCHAR(12)
dispositionNICS VARCHAR(15),
@dispositionFFL VARCHAR(20)

AS

IF(@ToFFL = 1)
	UPDATE BoundBook
	SET dispositionDate = @dispositionDate, dispositionType = @dispositionType, dispositionName = @dispositionName, dispositionFFL = @dispositionFFL
	WHERE serial = @serial AND dispositionDate IS NULL;

ELSE
	UPDATE BoundBook
	SET dispositionDate = @dispositionDate, dispositionType = @dispositionType, dispositionName = @dispositionName, dispositionAddress = @dispositionAddress, disposition4473 = @disposition4473, dispositionNICS = @dispositionNICS
	WHERE serial = @serial AND dispositionDate IS NULL;

GO
