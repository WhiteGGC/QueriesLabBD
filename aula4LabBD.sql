CREATE DATABASE aula4Lab
GO
USE aula4Lab

CREATE TABLE cliente(
	cpf			VARCHAR(11)	 NOT NULL,
	nome		VARCHAR(100) NOT NULL,
	email		VARCHAR(200) NOT NULL,
	limite		DECIMAL(7, 2) NOT NULL,
	nascimento	DATE		 NOT NULL
	PRIMARY KEY(cpf)
)

/*Verifica o primeiro digito*/
CREATE PROCEDURE sp_cpf_primeiro_verificador (@cpf VARCHAR(11), @ver1 INT OUTPUT)
AS
	DECLARE @loop INT, @digitos INT, @soma INT, @digito INT, @aux INT
	SET @loop = 1 SET @digitos = 10 SET @soma = 0 SET @ver1 = 0 

	WHILE(@loop < 10) BEGIN
		SET @digito = CAST(SUBSTRING(@cpf, @loop, 1) AS INT)
		SET @soma = @soma + (@digitos * @digito)
		SET @digitos = @digitos - 1
		SET @loop = @loop + 1 
	END 
	SET @aux = @soma % 11
	IF (@aux < 2) BEGIN
		SET @ver1 = 0
	END
	ELSE BEGIN
		SET @ver1 = 11 - @aux
	END

/*Verifica o segundo digito*/
CREATE PROCEDURE sp_cpf_segundo_verificador (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @loop INT, @digitos INT, @soma INT, @digito INT, @aux INT, @ver1 INT, @ver2 INT, @ver VARCHAR(10)
	SET @loop = 1 SET @digitos = 11 SET @soma = 0 SET @ver2 = 0 

	EXEC sp_cpf_primeiro_verificador @cpf, @ver1 OUTPUT

	WHILE(@loop < 10) BEGIN
		SET @digito = CAST(SUBSTRING(@cpf, @loop, 1) AS INT)
		SET @soma = @soma + (@digitos * @digito)
		SET @digitos = @digitos - 1
		SET @loop = @loop + 1 
	END
	SET @soma = @soma + (2 * @ver1)
	SET @aux = @soma % 11

	IF (@aux < 2) BEGIN
		SET @ver2 = 0
	END
	ELSE BEGIN
		SET @ver2 = 11 - @aux
	END

	SET @ver = CAST(@ver1 AS VARCHAR(1)) + CAST(@ver2 AS VARCHAR(1))
	IF (@ver = SUBSTRING(@cpf, 10, 2)) BEGIN
		SET @valido = 1
	END
	ELSE BEGIN
		SET @valido = 0
	END

/*Valida mesmos caracteres*/

CREATE PROCEDURE sp_cpf_numero_iguais (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @loop INT, @aux VARCHAR(10)
	SET @loop = 1 SET @aux = SUBSTRING(@cpf, 1, 1) SET @valido = 0 
	
	WHILE(@loop < 12) BEGIN
		IF(@aux != SUBSTRING(@cpf, @loop, 1)) BEGIN
			SET @valido = 1
		END
		SET @loop = @loop + 1
	END

/*Valida o CPF*/

CREATE PROCEDURE sp_valida_cpf (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @valida1 BIT, @valida2 BIT

	EXEC sp_cpf_segundo_verificador @cpf, @valida1 OUTPUT
	EXEC sp_cpf_numero_iguais @cpf, @valida2 OUTPUT

	IF(@valida1 = 0 OR @valida2 = 0) BEGIN
		SET @valido = 0
	END ELSE BEGIN
		SET @valido = 1
	END

DECLARE @cpf_valido BIT
EXEC sp_valida_cpf '50329193813', @cpf_valido OUTPUT
PRINT @cpf_valido

CREATE PROCEDURE sp_cliente (@op CHAR(1), @cpf VARCHAR(11), @nome VARCHAR(100),
	@email VARCHAR(200), @limite DECIMAL(7,2), 
	@nascimento DATE, @saida VARCHAR(100) OUTPUT)
AS
	DECLARE @cpf_valido		BIT
	IF (UPPER(@op) = 'D' AND @cpf IS NOT NULL)
	BEGIN
		DELETE cliente WHERE cpf = @cpf
		SET @saida = 'Cliente excluído com sucesso'
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @cpf IS NULL)
		BEGIN
			RAISERROR('CPF não pode ser NULL', 16, 1)
		END
		ELSE 
		BEGIN
			EXEC sp_valida_cpf @cpf, @cpf_valido OUTPUT
			IF (@cpf_valido = 0)
			BEGIN
				RAISERROR('CPF inválido', 16, 1)
			END
			ELSE
			BEGIN
				IF (UPPER(@op) = 'I')
				BEGIN
					INSERT INTO cliente VALUES
					(@cpf, @nome, @email, @limite, @nascimento)
					SET @saida = 'Cliente inserido com sucesso'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE cliente
						SET nome = @nome, email = @email,
							limite = @limite, nascimento = @nascimento
						WHERE cpf = @cpf
 
						SET @saida = 'Cliente alterado com sucesso'
					END
					ELSE
					BEGIN
						RAISERROR('Opção Invalida', 16, 1)
					END
				END
			END
		END
	END
 
DECLARE @out VARCHAR(40)
EXEC sp_cliente 'D', '50329193813', 'Gustavo', 'mfeianf@email', 4.5, '09/02/2002', 
	@out OUTPUT
PRINT @out
 
SELECT * FROM cliente

