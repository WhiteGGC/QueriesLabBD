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

INSERT INTO grupos VALUES ('A'), ('B'), ('C'), ('D')

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


DECLARE @loopRodada INT, @data DATE
SET @loopRodada = 1 SET @data = '2022-02-27'

WHILE (@loopRodada < 13)BEGIN
	DECLARE @loopJogos INT SET @loopJogos = 1
	WHILE (@loopJogos < 9)BEGIN
		DECLARE @timeA INT, @timeB INT, @golsA INT, @golsB INT

		SELECT TOP 1 @timeA = codigoTime FROM grupos_times AS gt
		LEFT JOIN jogos as j ON gt.codigoTime = j.CodigoTimeA OR gt.codigoTime = j.CodigoTimeB
		WHERE (j.CodigoTimeA IS NULL AND (j.Data = @data OR j.Data IS NULL))
		OR (j.CodigoTimeB IS NULL AND (j.Data = @data OR j.Data IS NULL))
		ORDER BY NEWID()

		SELECT TOP 1 @timeB = codigoTime FROM grupos_times AS gt
		LEFT JOIN jogos as j ON gt.codigoTime = j.CodigoTimeA OR gt.codigoTime = j.CodigoTimeB
		WHERE ((j.CodigoTimeA IS NULL AND (j.Data = @data OR j.Data IS NULL))
		OR (j.CodigoTimeB IS NULL AND (j.Data = @data OR j.Data IS NULL)))
		AND gt.codigoTime != @timeA
		AND gt.codigoGrupo != (SELECT codigoGrupo FROM grupos_times WHERE codigoTime = @timeA)
		AND ((j.CodigoTimeA != @timeA OR j.CodigoTimeB != @timeA))
		ORDER BY NEWID()

		INSERT INTO jogos VALUES(@timeA, @timeB, 1, 2, @data)
		SET @loopJogos = @loopJogos + 1 
	END
	SET @data = DATEADD(DD,3,@data)
	SET @loopRodada = @loopRodada + 1
END

SELECT * FROM jogos
SELECT g.nome AS Grupo, t.nomeTime AS Time FROM grupos_times AS gt
	INNER JOIN grupos AS g ON g.codigoGrupo = gt.codigoGrupo
	INNER JOIN times AS t ON t.codigoTime = gt.codigoTime

/*SET @data = DATEADD(DD,3,@data)*/

SELECT codigoTime FROM grupos_times AS gt
LEFT JOIN jogos as j ON gt.codigoTime = j.CodigoTimeA OR gt.codigoTime = j.CodigoTimeB
WHERE (j.CodigoTimeA IS NULL AND (j.Data = '2022-02-27' OR j.Data IS NULL))
OR (j.CodigoTimeB IS NULL AND (j.Data = '2022-02-27' OR j.Data IS NULL))
ORDER BY NEWID()

INSERT INTO jogos VALUES(10, 12, 1, 2, '2022-02-27')
INSERT INTO jogos VALUES(9, 8, 1, 2, '2022-02-27')
DELETE FROM jogos

SELECT codigoTimeA FROM jogos WHERE CodigoTimeB = 2