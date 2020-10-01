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
dispositionDate DATE NOT NULL,
dispositionType VARCHAR(100) NOT NULL,
dispositionName VARCHAR(100) NOT NULL,
dispositionAddress VARCHAR(100),
disposition4473 VARCHAR(12),
dispositionFFL VARCHAR(20),

Constraint PK_BoundBook PRIMARY KEY (aquisitionDate, serial));

CREATE PROCEDURE aquisition

@FromFFL BOOLEAN,
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

IF EXISTS(SELECT * FROM BoundBook WHERE serial = @serial AND dispositionDate IS NULL) 
BEGIN

IF (@FromFFL)
BEGIN
INSERT INTO BoundBook (aquisitionDate, aquisitionType, aquisitionName, aquisitionFFL, assetType, manufacturer, importer, make, caliberGauge, serial) VALUES (@aquisitionDate, @aquisitionType, @aquisitionName, @aquisitionFFL, @assetType, @manufacturer, @importer, @make, @caliberGauge, @serial)
END

ELSE 
BEGIN
INSERT INTO BoundBook (aquisitionDate, aquisitionType, aquisitionName, aquisitionAddress, assetType, manufacturer, importer, make, caliberGauge, serial) VALUES (@aquisitionDate, @aquisitionType, @aquisitionName, @aquisitionAddress, @assetType, @manufacturer, @importer, @make, @caliberGauge, @serial)
END

END

GO

CREATE PROCEDURE disposition

@ToFFL BOOLEAN,
@Serial VARCHAR(30),
@dispositionDate DATE,
@dispositionType VARCHAR(100),
@dispositionName VARCHAR(100),
@dispositionAddress VARCHAR(100),
@disposition4473 VARCHAR(12),
@dispositionFFL VARCHAR(20)

AS

IF(@ToFFL)
BEGIN

UPDATE BoundBook
SET dispositionDate = @dispositionDate, dispositionType = @dispositionType, dispositionName = @dispositionName, dispositionFFL = @dispositionFFL
WHERE serial = @serial

END
ELSE
BEGIN

UPDATE BoundBook
SET dispositionDate = @dispositionDate, dispositionType = @dispositionType, dispositionName = @dispositionName, dispositionAddress = @dispositionAddress, disposition4473 = @disposition4473
WHERE serial = @serial

END
