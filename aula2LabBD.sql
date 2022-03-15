CREATE DATABASE aula2
GO
USE aula2

CREATE TABLE motorista(
	codigo	INT			 NOT NULL,
	nome	VARCHAR(40) NOT NULL,
	naturalidade VARCHAR(40) NOT NULL
	PRIMARY KEY(codigo)
)

CREATE TABLE onibus(
	placa	CHAR(7)		NOT NULL,
	marca	VARCHAR(15) NOT NULL,
	ano		INT			NOT NULL,
	descricao VARCHAR(20) NOT NULL
	PRIMARY KEY(placa)
)

CREATE TABLE viagem(
	codigo		 INT			NOT NULL,
	onibus		 CHAR(7)		NOT NULL,
	motorista	 INT			NOT NULL,
	hora_saida	 INT			NOT NULL,
	hora_chegada INT			NOT NULL,
	partida		 VARCHAR(40)	NOT NULL,
	destino		 VARCHAR(40)	NOT NULL
	PRIMARY KEY(codigo)
	FOREIGN KEY(onibus) REFERENCES onibus(placa),
	FOREIGN KEY(motorista) REFERENCES motorista(codigo)
)

INSERT INTO motorista(codigo, nome, naturalidade) VALUES
	(12341, 'Julio Cesar', 'São Paulo'),
	(12342, 'Mario Carmo', 'Americana'),
	(12343, 'Lucio Castro', 'Campinas'),
	(12344, 'André Figueiredo', 'São Paulo'),
	(12345, 'Luiz Carlos', 'São Paulo'),
	(12346, 'Carlos Roberto', 'Campinas'),
	(12347, 'João Paulo', 'São Paulo')

INSERT INTO onibus(placa, marca, ano, descricao) VALUES
	('adf0965', 'Mercedes', 2009, 'Leito'),
	('bhg7654', 'Mercedes', 2012, 'Sem banheiro'),
	('dtr2093', 'Mercedes', 2017, 'Ar Condicionado'),
	('gui7652', 'Volvo', 2014, 'Ar Condicionado'),
	('jhy9425', 'Volvo', 2018, 'Leito'),
	('lmk7485', 'Mercedes', 2015, 'Ar Condicionado'),
	('aqw2374', 'Volvo', 2014, 'Leito')

INSERT INTO viagem(codigo, onibus, motorista, hora_saida, hora_chegada, partida, destino) VALUES
	(101, 'adf0965', 12343, 10, 12, 'São Paulo', 'Campinas'),
	(102, 'gui7652', 12341, 7, 12, 'São Paulo', 'Araraquara'),
	(103, 'bhg7654', 12345, 14, 22, 'São Paulo', 'Rio de Janeiro'),
	(104, 'dtr2093', 12344, 18, 21, 'São Paulo', 'Sorocaba'),
	(105, 'aqw2374', 12342, 11, 17, 'São Paulo', 'Ribeirão Preto'),
	(106, 'jhy9425', 12347, 10, 19, 'São Paulo', 'São José do Rio Preto'),
	(107, 'lmk7485', 12346, 13, 20, 'São Paulo', 'Curitiba'),
	(108, 'adf0965', 12343, 14, 16, 'Campinas', 'São Paulo'),
	(109, 'gui7652', 12341, 14, 19, 'Araraquara', 'São Paulo'),
	(110, 'bhg7654', 12345, 0, 8, 'Rio de Janeiro', 'São Paulo'),
	(111, 'dtr2093', 12344, 22, 1, 'Sorocaba', 'São Paulo'),
	(112, 'aqw2374', 12342, 19, 5, 'Ribeirão Preto', 'São Paulo'),
	(113, 'jhy9425', 12347, 22, 7, 'São José do Rio Preto', 'São Paulo'),
	(114, 'lmk7485', 12346, 0, 7, 'Curitiba', 'São Paulo')

SELECT CAST(codigo AS VARCHAR) AS codigo, nome AS nome_marca FROM motorista
UNION
SELECT placa, marca FROM onibus

GO
CREATE VIEW v_motorista_onibus
AS
SELECT CAST(codigo AS VARCHAR) AS codigo, nome AS nome_marca FROM motorista
UNION
SELECT placa, marca FROM onibus


GO
CREATE VIEW v_descricao_onibus 
AS
SELECT v.codigo as codigo_viagem,
	   m.nome as nome_motorista,
	   SUBSTRING(o.placa, 1, 3) + '-' + SUBSTRING(o.placa, 4, 4) as placa_onibus,
	   o.marca as marca_onibus,
	   o.ano as ano_onibus,
	   o.descricao as descricao_onibus
FROM viagem AS v
INNER JOIN motorista AS m ON v.motorista = m.codigo
INNER JOIN onibus AS o ON o.placa = v.onibus

GO
CREATE VIEW v_descricao_viagem
AS
SELECT codigo,
	   SUBSTRING(onibus, 1, 3) + '-' + SUBSTRING(onibus, 4, 4) as placa_onibus,
	   CAST(hora_saida AS VARCHAR) + ':00' as hora_saida,
	   CAST(hora_chegada AS VARCHAR)+ ':00' as hora_chegada,
	   partida,
	   destino
FROM viagem

GO 
SELECT * FROM v_motorista_onibus
SELECT * FROM v_descricao_onibus
SELECT * FROM v_descricao_viagem
