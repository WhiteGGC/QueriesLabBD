CREATE DATABASE queriesDinamicas
GO
USE queriesDinamicas

CREATE TABLE produto(
	cod		INT			 NOT NULL,
	nome	VARCHAR(100) NOT NULL,
	valor	DECIMAL(7,2) NOT NULL

	PRIMARY KEY(cod)
)

CREATE TABLE entrada(
	cod			INT			 NOT NULL,
	cod_prod	INT			 NOT NULL,
	quantidade	INT			 NOT NULL,
	valor_total	DECIMAL(7,2) NOT NULL

	PRIMARY KEY(cod)
	FOREIGN KEY(cod_prod) REFERENCES produto(cod)
)

CREATE TABLE saida(
	cod			INT			 NOT NULL,
	cod_prod	INT			 NOT NULL,
	quantidade	INT			 NOT NULL,
	valor_total	DECIMAL(7,2) NOT NULL

	PRIMARY KEY(cod)
	FOREIGN KEY(cod_prod) REFERENCES produto(cod)
)

CREATE PROCEDURE sp_insereproduto(@es VARCHAR(1), @transacao INT, 
	@cod_produto INT, @quantidade INT, @saida VARCHAR(100) OUTPUT)
AS	 
	DECLARE @op VARCHAR(100)
	IF (UPPER(@es) LIKE 'E') BEGIN
		SET @op = 'Entrada'
	END
	ELSE
	IF (UPPER(@es) LIKE 'S') BEGIN
		SET @op = 'Saida'
	END
	ELSE BEGIN
		RAISERROR('Código inválido', 16, 1)
	END

	DECLARE @valor DECIMAL(7,2)
	SELECT @valor = valor FROM produto WHERE cod = @cod_produto
		
	DECLARE @total INT
	SET @total = @quantidade * @valor 

	DECLARE @query VARCHAR(MAX)

	SET @query = 'INSERT INTO '+LOWER(@op)+' VALUES ('+CAST(@transacao AS VARCHAR(5))
					+','+CAST(@cod_produto AS VARCHAR(5))
					+','+CAST(@quantidade AS VARCHAR(5))
					+','+CAST(@total AS VARCHAR(5))+')'
	
	DECLARE @erro VARCHAR(100)
	BEGIN TRY
		EXEC (@query)
		SET @saida = @op+' inserida com sucesso'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Id duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro na entrada ou saida do produto', 16, 1)
		END
	END CATCH

INSERT INTO produto VALUES (5, 'Impressora', 400)

DECLARE @out1 VARCHAR(100)
EXEC sp_insereproduto 'e', 1, 1, 10, @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(100)
EXEC sp_insereproduto 's', 2, 4, 50, @out2 OUTPUT
PRINT @out2

SELECT * FROM entrada
SELECT * FROM saida