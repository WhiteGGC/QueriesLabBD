CREATE DATABASE p1LabBDRefatoracao
GO
USE p1LabBDRefatoracao

CREATE TABLE times(
	codigoTime		INT				NOT NULL	IDENTITY(1,1),
	nomeTime		VARCHAR(100)	NOT NULL,
	cidade			VARCHAR(100)	NOT NULL,
	estadio			VARCHAR(100)	NOT NULL,
	fl_unico_time	BIT				NOT NULL,
	participacoes	INT				NOT NULL
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
	codigoTime		INT,
	codigoGrupo		INT				
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

CREATE TABLE grupo_rodada(
	CodigoGrupo		INT				NOT NULL,
	participacoes	INT				NOT NULL
	PRIMARY KEY(CodigoGrupo)
)

CREATE TABLE matchups(
	CodigoTimeA		INT				NOT NULL,
	CodigoTimeB		INT				NOT NULL
	PRIMARY KEY(CodigoTimeA, CodigoTimeB),
	FOREIGN KEY(CodigoTimeA) REFERENCES times(CodigoTime),
	FOREIGN KEY(CodigoTimeB) REFERENCES times(CodigoTime)
)

INSERT INTO times VALUES('Corinthians', 'São Paulo', 'Neo Química Arena', 1, 0),
						('Palmeiras', 'São Paulo', 'Allianz Parque', 1, 0),
						('São Paulo', 'São Paulo', 'Morumbi', 1, 0),
						('Santos', 'Santos', 'Vila Belmiro', 1, 0),
						('Botafogo-SP', 'Ribeirão Preto', 'Santa Cruz', 0, 0),
						('Ferroviária', 'Araraquara', 'Fonte Luminosa', 0, 0),
						('Guarani', 'Campinas', 'Brinco de Ouro', 0, 0),
						('Inter de Limeira', 'Limeira', 'Limeirão', 0, 0),
						('Ituano', 'Itu', 'Novelli Júnior', 0, 0),
						('Mirassol', 'Mirassol', 'José Maria de Campos Maia', 0, 0),
						('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi', 0, 0),
						('Ponte Preta', 'Campinas', 'Moisés Lucarelli', 0, 0),
						('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedid', 0, 0),
						('Santo André', 'Santo André', 'Bruno José Daniel', 0, 0),
						('São Bento', 'Sorocaba', 'Walter Ribeiro', 0, 0),
						('São Caetano', 'São Caetano do Sul', 'Anacletto Campanella', 0, 0)

INSERT INTO grupo_rodada VALUES (1, 0), (2, 0), (3, 0), (4, 0)

DECLARE @loopA INT, @loopB INT
SET @loopA = 1 

WHILE(@loopA < 17)BEGIN
	DECLARE @aux INT
	SELECT @aux = COUNT(codigoTime) FROM grupos_times 
		WHERE codigoTime NOT IN (SELECT codigoTimeA FROM matchups WHERE CodigoTimeB = @loopA)
		AND codigoGrupo NOT IN (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = @loopA)
		AND codigoTime NOT IN (SELECT codigoTimeB FROM matchups WHERE CodigoTimeA = @loopA)
	SET @loopB = 0
	WHILE(@loopB < @aux)BEGIN
		DECLARE @codigoB INT
		SELECT TOP 1 @codigoB = codigoTime FROM grupos_times 
		WHERE codigoTime NOT IN (SELECT codigoTimeA FROM matchups WHERE CodigoTimeB = @loopA)
		AND codigoGrupo NOT IN (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = @loopA)
		AND codigoTime NOT IN (SELECT codigoTimeB FROM matchups WHERE CodigoTimeA = @loopA)

		INSERT INTO matchups VALUES (@loopA, @codigoB)

		SET @loopB = @loopB + 1
	END
	SET @loopA = @loopA + 1
END

SELECT * FROM matchups
DELETE FROM matchups
SELECT * FROM grupos_times


SELECT  COUNT(codigoTime) FROM grupos_times 
		WHERE codigoTime NOT IN (SELECT codigoTimeA FROM matchups WHERE CodigoTimeB = 1)
		AND codigoGrupo NOT IN (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = 1)
		AND codigoTime NOT IN (SELECT codigoTimeB FROM matchups WHERE CodigoTimeA = 1)








/*
CREATE PROCEDURE sp_gerador_grupos 
AS
	DECLARE @loop INT
	SET @loop = 1

	WHILE(@loop < 5)BEGIN
		DECLARE @time INT
		SELECT TOP 1 @time = t.codigoTime FROM times AS t 
		LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigoTime
		WHERE fl_unico_time = 1 AND gt.codigoTime IS NULL ORDER BY NEWID()
		INSERT INTO grupos_times VALUES(@time, @loop)
		SET @loop = @loop + 1
	END

	SET @loop = 1
	WHILE (@loop < 13)BEGIN
		DECLARE @grupo INT

		SELECT TOP 1 @time = t.codigoTime FROM times AS t 
		LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigoTime
		WHERE fl_unico_time = 0 AND gt.codigoTime IS NULL ORDER BY NEWID()

		SELECT TOP 1 @grupo = g.codigoGrupo FROM grupos AS g
		INNER JOIN grupos_times AS gt ON gt.codigoGrupo = g.codigoGrupo
		GROUP BY g.codigoGrupo
		HAVING COUNT(g.codigoGrupo) < 4
		ORDER BY NEWID()

		INSERT INTO grupos_times VALUES(@time, @grupo) 

		SET @loop = @loop + 1
	END

	SELECT g.nome AS Grupo, t.nomeTime AS Time FROM grupos_times AS gt
	INNER JOIN grupos AS g ON g.codigoGrupo = gt.codigoGrupo
	INNER JOIN times AS t ON t.codigoTime = gt.codigoTime
	ORDER BY g.nome

EXEC sp_gerador_grupos
SELECT g.nome AS Grupo, t.nomeTime AS Time FROM grupos_times AS gt
	INNER JOIN grupos AS g ON g.codigoGrupo = gt.codigoGrupo
	INNER JOIN times AS t ON t.codigoTime = gt.codigoTime
	ORDER BY g.nome
DELETE FROM grupos_times


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