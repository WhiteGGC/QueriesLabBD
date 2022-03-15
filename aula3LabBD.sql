/*1*/
DECLARE @num1 INT
SET @num1 = 9

IF(@num1 % 2 = 0)
BEGIN
	PRINT 'É múltiplo de 2'
END
ELSE IF(@num1 % 3 = 0)
BEGIN
	PRINT 'É múltiplo de 3'
END
ELSE IF(@num1 % 5 = 0)
BEGIN
	PRINT 'É múltiplo de 5'
END
ELSE
BEGIN
	PRINT 'Não é múltiplo de 2, 3 ou 5'
END

/*2*/
DECLARE @num2 INT, @num3 INT, @num4 INT, @maior INT, @menor INT
SET @num2 = 9 SET @num3 = 15 SET @num4 = 4 SET @maior = @num2 SET @menor = @num2

IF(@num2 > @maior) BEGIN
	SET @maior = @num2
END
ELSE IF (@num2 < @menor) BEGIN
	SET @menor = @num2
END
IF(@num3 > @maior) BEGIN
	SET @maior = @num3
END
ELSE IF (@num3 < @menor) BEGIN
	SET @menor = @num3
END
IF(@num4 > @maior) BEGIN
	SET @maior = @num4
END
ELSE IF (@num4 < @menor) BEGIN
	SET @menor = @num4
END

PRINT 'O maior valor: ' + CAST(@maior AS VARCHAR) 
+ ' o menor valor: ' + CAST(@menor AS VARCHAR)

/*3*/

DECLARE @cont1 INT, @termo1 INT, @termo2 INT, @aux1 INT, @soma INT
SET @cont1 = 0 SET @termo1 = 1  SET @termo2 = 0 SET @soma = 0
WHILE(@cont1 < 15) BEGIN
	SET @aux1 = @termo2
	SET @termo2 = @termo2 + @termo1
	SET @termo1 = @aux1
	PRINT @termo2
	SET @soma = @soma + @termo2
	SET @cont1 = @cont1 + 1
END
PRINT 'A soma dos termos: ' + CAST(@soma AS VARCHAR)

/*4*/

DECLARE @frase1 VARCHAR(50), @upper VARCHAR(50), @lower VARCHAR(50)
SET @frase1 = 'Teste de Frase'

SET @upper = UPPER(@frase1)
PRINT @upper
SET @lower = LOWER(@frase1)
PRINT @lower

/*5*/

DECLARE @frase2 VARCHAR(50), @invertida VARCHAR(50)
SET @frase2 = 'Teste de Frase'

/*SET @invertida = REVERSE(@frase2)
PRINT @invertida*/

SET @invertida = SUBSTRING(@frase2, 14, 1) + 
SUBSTRING(@frase2, 13, 1) +
SUBSTRING(@frase2, 12, 1) +
SUBSTRING(@frase2, 11, 1) +
SUBSTRING(@frase2, 10, 1) +
SUBSTRING(@frase2, 9, 1) +
SUBSTRING(@frase2, 8, 1) +
SUBSTRING(@frase2, 7, 1) +
SUBSTRING(@frase2, 6, 1) +
SUBSTRING(@frase2, 5, 1) +
SUBSTRING(@frase2, 4, 1) +
SUBSTRING(@frase2, 3, 1) +
SUBSTRING(@frase2, 2, 1) +
SUBSTRING(@frase2, 1, 1) 
PRINT @invertida