CREATE DATABASE p1LabBD
GO
USE p1LabBD

CREATE TABLE times(
	CodigoTime		VARCHAR(5)		NOT NULL,
	NomeTime		VARCHAR(100)	NOT NULL,
	Cidade			VARCHAR(100)	NOT NULL,
	Estadio			VARCHAR(100)	NOT NULL
	PRIMARY KEY(CodigoTime)
)

CREATE TABLE grupos(
	Grupo			VARCHAR(1)		NOT NULL	CHECK(UPPER(Grupo) = 'A' OR 
													  UPPER(Grupo) = 'B' OR 
													  UPPER(Grupo) = 'C' OR 
													  UPPER(Grupo) = 'D'),
	CodigoTime		VARCHAR(5)		NOT NULL,
	PRIMARY KEY(Grupo),
	FOREIGN KEY(CodigoTime) REFERENCES times(CodigoTime)
)

CREATE TABLE jogos(
	CodigoTimeA		VARCHAR(5)		NOT NULL,
	CodigoTimeB		VARCHAR(5)		NOT NULL,
	GolsTimeA		INT				NOT NULL,
	GolsTimeB		INT				NOT NULL,
	Data			DATE			NOT NULL	
	PRIMARY KEY(CodigoTimeA, CodigoTimeB),
	FOREIGN KEY(CodigoTimeA) REFERENCES times(CodigoTime),
	FOREIGN KEY(CodigoTimeB) REFERENCES times(CodigoTime)
)
INSERT INTO times VALUES(1, 'Corinthians', 'São Paulo', 'Neo Química Arena')
INSERT INTO grupos VALUES('A', 1)

SELECT * FROM grupos
