CREATE DATABASE p1LabBD
GO
USE p1LabBD

CREATE TABLE times(
	CodigoTime		INT				NOT NULL	IDENTITY(1,1),
	NomeTime		VARCHAR(100)	NOT NULL,
	Cidade			VARCHAR(100)	NOT NULL,
	Estadio			VARCHAR(100)	NOT NULL,
	fl_unico_time	BIT				NOT NULL
	PRIMARY KEY(CodigoTime)
)

CREATE TABLE grupos(
	CodigoGrupo		INT				NOT NULL	IDENTITY(1,1),
	Grupo			VARCHAR(1)		NOT NULL	CHECK(UPPER(Grupo) = 'A' OR 
													  UPPER(Grupo) = 'B' OR 
													  UPPER(Grupo) = 'C' OR 
													  UPPER(Grupo) = 'D'),
	CodigoTime		INT				NOT NULL,
	PRIMARY KEY(CodigoGrupo),
	FOREIGN KEY(CodigoTime) REFERENCES times(CodigoTime)
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

INSERT INTO times VALUES('Corinthians', 'São Paulo', 'Neo Química Arena', 1),
						('Palmeiras', 'São Paulo', 'Allianz Parque', 1),
						('São Paulo', 'São Paulo', 'Morumbi', 1),
						('Santos', 'Santos', 'Vila Belmiro', 1),
						('Botafogo-SP', 'Ribeirão Preto', 'Santa Cruz', 0),
						('Ferroviária', 'Araraquara', 'Fonte Luminosa', 0),
						('Guarani', 'Campinas', 'Brinco de Ouro', 0),
						('Inter de Limeira', 'Limeira', 'Limeirão', 0),
						('Ituano', 'Itu', 'Novelli Júnior', 0),
						('Mirassol', 'Mirassol', 'José Maria de Campos Maia', 0),
						('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi', 0),
						('Ponte Preta', 'Campinas', 'Moisés Lucarelli', 0),
						('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedid', 0),
						('Santo André', 'Santo André', 'Bruno José Daniel', 0),
						('São Bento', 'Sorocaba', 'Walter Ribeiro', 0),
						('São Caetano', 'São Caetano do Sul', 'Anacletto Campanella', 0)

CREATE PROCEDURE sp_gerador_grupos()

INSERT INTO grupos VALUES('A', 1)

SELECT * FROM grupos
