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

CREATE PROCEDURE sp_gerador_grupos 
AS
	DECLARE @loopGrupo INT, @grupo INT
	SET @loopGrupo = 1

	/*Loop dos grupos*/
	WHILE (@loopGrupo < 5) BEGIN
		/*SET @grupo = CAST((RAND() * 3 + 1) AS INT)*/
		DECLARE @grupoValido BIT, @nomeGrupo VARCHAR(1)
		EXEC sp_valida_grupo @loopGrupo, @grupoValido OUTPUT, @nomeGrupo OUTPUT
		IF(@grupoValido = 1) BEGIN
			
			/*Loop dos times*/
			DECLARE @loopTimes INT SET @loopTimes = 1
			WHILE (@loopTimes < 5) BEGIN

				DECLARE @timeValido BIT, @time INT, @loopTime BIT
				SET @time = CAST((RAND() * 16 + 1) AS INT)
				SET @loopTime = 0
				
				WHILE(@loopTime = 0)BEGIN
					/*Validação dos times aleatórios*/
					EXEC sp_valida_times @time, @nomeGrupo, @timeValido OUTPUT

					IF(@timeValido = 1)BEGIN
						DECLARE @query VARCHAR(100)
						SET @query = 'INSERT INTO grupos VALUES ('''+@nomeGrupo+''', '+CAST(@time AS VARCHAR(2))+')'
						EXEC(@query)
						SET @loopTime = 1
					END
					ELSE IF(@time = 16)BEGIN
						SET @time = 1
					END
					ELSE BEGIN
						SET @time = @time + 1
					END
				END
				SET @loopTimes = @loopTimes + 1
			END
			SET @loopGrupo = @loopGrupo + 1
		END
	END
	SELECT * FROM grupos ORDER BY Grupo

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

CREATE PROCEDURE sp_valida_times(@cod INT, @grupo VARCHAR(1), @valido BIT OUTPUT)
AS
	DECLARE @participando INT
	SELECT @participando = CodigoTime FROM grupos WHERE CodigoTime = @cod
	/*Indentifica se o time já foi inserido*/
	IF(@participando IS NULL) BEGIN
		
		DECLARE @unico_time BIT, @unico_no_grupo INT

		SELECT @unico_time = fl_unico_time FROM times WHERE CodigoTime = @cod

		SELECT @unico_no_grupo = g.CodigoTime FROM grupos AS g 
			INNER JOIN times as t ON g.CodigoTime = t.CodigoTime
			WHERE t.fl_unico_time = 1 AND g.Grupo LIKE @grupo

		/*Identifica se já tem um time "especial" no grupo*/
		IF(@unico_no_grupo IS NULL)BEGIN

			IF(@unico_time = 1)BEGIN
				SET @valido = 1
			END 
			ELSE BEGIN
				SET @valido = 0
			END
		END
		ELSE BEGIN
			IF(@unico_time = 0)BEGIN
				SET @valido = 1
			END
			ELSE BEGIN
				SET @valido = 0
			END
		END

	END
	ELSE BEGIN
		SET @valido = 0
	END

EXEC sp_gerador_grupos

SELECT * FROM times
SELECT * FROM grupos
SELECT * FROM jogos

DELETE FROM times
DROP TABLE times
DELETE FROM grupos
DROP TABLE grupos
DELETE FROM jogos
DROP TABLE jogos

CREATE PROCEDURE sp_gera_jogos
AS
	DECLARE @data DATE, @loopData INT
	SET @data = '2021-02-27' SET @loopData = 1
	WHILE(@loopData < 13)BEGIN
		DECLARE @timeA INT, @timeB INT
		SET @timeA = CAST((RAND() * 16 + 1) AS INT)
		SET @timeB = CAST((RAND() * 16 + 1) AS INT)

	END

DECLARE @timeA INT, @timeB INT, @
		SET @timeA = CAST((RAND() * 16 + 1) AS INT)
		SELECT @timeB = CodigoTime FROM grupos
		PRINT @timeA
		PRINT @timeB

/*

DECLARE @loopRodada INT, @data DATE, @dataPassada DATE,  @loopJogos INT
SET @loopRodada = 1 SET @data = '2022-02-27' 

WHILE (@loopRodada < 13)BEGIN
	SET @loopJogos = 1
	WHILE (@loopJogos < 9)BEGIN
		DECLARE @timeA INT, @timeB INT, @golsA INT, @golsB INT
		/*IF(@loopRodada >= 1)BEGIN

		SELECT TOP 1 @timeA = codigoTime FROM grupos_times AS gt
		LEFT JOIN jogos as j ON gt.codigoTime = j.CodigoTimeA OR gt.codigoTime = j.CodigoTimeB
		WHERE (j.Data != @data OR j.Data IS NULL)
		ORDER BY NEWID()

		SELECT TOP 1 @timeB = codigoTime FROM grupos_times AS gt
		LEFT JOIN jogos as j ON gt.codigoTime = j.CodigoTimeA OR gt.codigoTime = j.CodigoTimeB
		WHERE (j.Data != @data OR j.Data IS NULL)
		AND gt.codigoGrupo != (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = @timeA)
		ORDER BY NEWID()
		
		END
		ELSE BEGIN
		*/
		SET @timeA = NULL SET @timeB = NULL

		SELECT TOP 1 @timeA = codigoTime FROM grupos_times
		WHERE codigoTime NOT IN (SELECT DISTINCT gt.codigoTime FROM grupos_times AS gt LEFT JOIN jogos AS jA ON jA.CodigoTimeA = gt.codigoTime OR jA.CodigoTimeB = gt.codigoTime
		WHERE jA.Data = @data )
		AND codigoGrupo NOT IN (SELECT TOP 2 codigoGrupo FROM grupos_times AS gt LEFT JOIN jogos AS j ON j.CodigoTimeA = gt.codigoTime OR j.CodigoTimeB = gt.codigoTime
			WHERE j.Data = @data
			GROUP BY (codigoGrupo)
			ORDER BY COUNT(codigoGrupo) DESC)
		ORDER BY NEWID()

		SELECT TOP 1 @timeB = codigoTime FROM grupos_times
		WHERE codigoGrupo NOT IN (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = @timeA)
		AND codigoTime NOT IN (SELECT DISTINCT gt.codigoTime FROM grupos_times AS gt LEFT JOIN jogos AS jA ON jA.CodigoTimeA = gt.codigoTime OR jA.CodigoTimeB = gt.codigoTime
		WHERE jA.Data = @data)
		ORDER BY NEWID()
		/*END*/

		INSERT INTO jogos VALUES(@timeA, @timeB, 1, 2, @data)
		
		SET @loopJogos = @loopJogos + 1 

	END
	SET @data = DATEADD(DD,3,@data)
	SET @loopRodada = @loopRodada + 1


	PRINT 'loopRodada: ' + CAST(@loopRodada AS VARCHAR(2))
END


SELECT * FROM jogos
ORDER BY Data
SELECT * FROM grupos_times
DELETE FROM jogos

SELECT * FROM grupos WHERE codigoGrupo IN (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = 1 OR codigoTime = 2)

SELECT TOP 2 codigoGrupo, participacoes FROM grupo_rodada ORDER BY (participacoes)
UPDATE grupo_rodada SET participacoes = participacoes + 1 WHERE CodigoGrupo = 3

'2022-02-27'
'2022-03-02'
'2022-03-05'
'2022-03-08'
'2022-03-11'

SELECT DISTINCT gt.codigoTime FROM grupos_times AS gt LEFT JOIN jogos AS jA ON jA.CodigoTimeA = gt.codigoTime OR jA.CodigoTimeB = gt.codigoTime
WHERE jA.Data = '2022-02-27'

SELECT TOP 2 codigoGrupo FROM grupos_times AS gt LEFT JOIN jogos AS j ON j.CodigoTimeA = gt.codigoTime OR j.CodigoTimeB = gt.codigoTime
WHERE j.Data = '2022-03-11'
GROUP BY (codigoGrupo)
ORDER BY COUNT(codigoGrupo) DESC

*/