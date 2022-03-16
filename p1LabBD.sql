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
	Grupo			VARCHAR(1)		NOT NULL	CHECK(UPPER(Grupo) = 'A' OR 
													  UPPER(Grupo) = 'B' OR 
													  UPPER(Grupo) = 'C' OR 
													  UPPER(Grupo) = 'D'),
	CodigoTime		INT				NOT NULL,
	PRIMARY KEY(CodigoTime),
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

CREATE PROCEDURE sp_gerador_grupos(@saida INT) 
AS
	DECLARE @loopGrupo INT, @loopTime INT, @time INT, @grupo INT
	SET @loopGrupo = 0 SET @loopTime = 0
	WHILE (@loopTime < 16) BEGIN
		SET @time = CAST((RAND() * 15 + 1) AS INT)
		SET @grupo = CAST((RAND() * 3 + 1) AS INT)
	END

CREATE PROCEDURE sp_valida_grupo(@cod INT, @valido BIT OUTPUT, @grupo VARCHAR(1) OUTPUT)
AS
	/*escolhe a letra do grupo (A, B, C, D) baseado no numero*/
	IF(@cod = 1) BEGIN
		SET @grupo = 'A'
	END
	ELSE IF (@cod = 2) BEGIN
		SET @grupo = 'B'
	END
	ELSE IF (@cod = 3) BEGIN
		SET @grupo = 'C'
	END
	ELSE BEGIN
		SET @grupo = 'D'
	END

	/*Valida se o grupo esta cheio*/
	DECLARE @cont INT
	SELECT @cont = COUNT(Grupo) FROM grupos WHERE Grupo LIKE @grupo

	IF(@cont = 4)BEGIN
		SET @valido = 0
	END
	ELSE BEGIN
		SET @valido = 1
	END

DECLARE @valida BIT, @grops VARCHAR(1)
EXEC sp_valida_grupo 5, @valida OUTPUT, @grops OUTPUT
PRINT @valida
PRINT @grops

CREATE PROCEDURE sp_valida_times(@cod INT, @grupo VARCHAR(1), @valido BIT OUTPUT)
AS
	DECLARE @participando INT
	SELECT @participando = CodigoTime FROM grupos WHERE CodigoTime = @cod
	/*Indentifica se o time já foi inserido*/
	IF(@participando IS NULL) BEGIN
		
		DECLARE @unico_time BIT, @unico_no_grupo INT

		SELECT @unico_time = fl_unico_time FROM times WHERE CodigoTime = @cod

		/*Identifica se já tem um time "especial" no grupo*/
		IF(@unico_time = 1)BEGIN

			SELECT @unico_no_grupo = g.CodigoTime FROM grupos AS g 
			INNER JOIN times as t ON g.CodigoTime = t.CodigoTime
			WHERE t.fl_unico_time = 1 AND g.Grupo LIKE @grupo

			IF(@unico_no_grupo IS NULL)BEGIN
				SET @valido = 1
			END
		END
		ELSE BEGIN
			SET @valido = 1
		END

	END


SELECT * FROM grupos

USE master

SELECT * FROM times
SELECT * FROM grupos
SELECT * FROM jogos

DELETE FROM times
DROP TABLE times
DELETE FROM grupos
DROP TABLE grupos
DELETE FROM jogos
DROP TABLE jogos

DECLARE @participand INT, @bit BIT
SELECT @participand = CodigoTime FROM grupos WHERE CodigoTime = 3
IF(@participand IS NOT NULL) BEGIN
	SET @bit = 1
END
ELSE BEGIN
	SET @bit = 0
END

PRINT @participand
PRINT @bit

INSERT INTO grupos VALUES ('A', 1)
INSERT INTO grupos VALUES ('A', 2)
INSERT INTO grupos VALUES ('A', 12)
SELECT CodigoTime FROM grupos WHERE CodigoTime = 2

DECLARE @unico_no_grupo INT, @bit BIT
SELECT @unico_no_grupo = g.CodigoTime FROM grupos AS g 
		INNER JOIN times as t 
		ON g.CodigoTime = t.CodigoTime
		WHERE t.fl_unico_time = 1 AND g.Grupo LIKE 'A'
PRINT @unico_no_grupo
IF(@unico_no_grupo IS NULL) BEGIN
	SET @bit = 1
END
ELSE BEGIN
	SET @bit = 0
END
PRINT @bit
