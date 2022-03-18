CREATE DATABASE p1LabBDRefatoracao
GO
USE p1LabBDRefatoracao

CREATE TABLE times(
	codigoTime		INT				NOT NULL	IDENTITY(1,1),
	nomeTime		VARCHAR(100)	NOT NULL,
	cidade			VARCHAR(100)	NOT NULL,
	estadio			VARCHAR(100)	NOT NULL,
	fl_unico_time	BIT				NOT NULL
	PRIMARY KEY(codigoTime)
)

CREATE TABLE grupos(
	codigoGrupo		INT				NOT NULL	IDENTITY(1,1),
	nome			VARCHAR(1)		NOT NULL	CHECK(UPPER(nome) = 'A' OR 
													  UPPER(nome) = 'B' OR 
													  UPPER(nome) = 'C' OR 
													  UPPER(nome) = 'D')
	PRIMARY KEY(codigoGrupo)
)

CREATE TABLE grupos_times(
	codigoTime		INT			NOT NULL,
	codigoGrupo		INT			NOT NULL
	PRIMARY KEY(codigoTime, codigoGrupo)
	FOREIGN KEY(codigoGrupo) REFERENCES grupos(codigoGrupo),
	FOREIGN KEY(codigoTime) REFERENCES times(codigoTime)
)

CREATE TABLE jogos(
	CodigoTimeA		INT				NOT NULL,
	CodigoTimeB		INT				NOT NULL,
	GolsTimeA		INT				NOT NULL,
	GolsTimeB		INT				NOT NULL,
	Data			DATE			NOT NULL	
	PRIMARY KEY(CodigoTimeA, CodigoTimeB),
	FOREIGN KEY(CodigoTimeA) REFERENCES times(CodigoTime),
	FOREIGN KEY(CodigoTimeB) REFERENCES times(CodigoTime)
)

INSERT INTO times VALUES('Corinthians', 'S�o Paulo', 'Neo Qu�mica Arena', 1),
						('Palmeiras', 'S�o Paulo', 'Allianz Parque', 1),
						('S�o Paulo', 'S�o Paulo', 'Morumbi', 1),
						('Santos', 'Santos', 'Vila Belmiro', 1),
						('Botafogo-SP', 'Ribeir�o Preto', 'Santa Cruz', 0),
						('Ferrovi�ria', 'Araraquara', 'Fonte Luminosa', 0),
						('Guarani', 'Campinas', 'Brinco de Ouro', 0),
						('Inter de Limeira', 'Limeira', 'Limeir�o', 0),
						('Ituano', 'Itu', 'Novelli J�nior', 0),
						('Mirassol', 'Mirassol', 'Jos� Maria de Campos Maia', 0),
						('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi', 0),
						('Ponte Preta', 'Campinas', 'Mois�s Lucarelli', 0),
						('Red Bull Bragantino', 'Bragan�a Paulista', 'Nabi Abi Chedid', 0),
						('Santo Andr�', 'Santo Andr�', 'Bruno Jos� Daniel', 0),
						('S�o Bento', 'Sorocaba', 'Walter Ribeiro', 0),
						('S�o Caetano', 'S�o Caetano do Sul', 'Anacletto Campanella', 0)

INSERT INTO grupos VALUES ('A'), ('B'), ('C'), ('D')

CREATE PROCEDURE sp_gerador_grupos 
AS
	DECLARE @loopTimes INT
	SET @loopTimes = 1
	WHILE(@loopTimes < 17)BEGIN
		DECLARE @grupo INT
		SET @grupo = CAST((RAND() * 4 + 1) AS INT)
	END