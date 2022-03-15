CREATE DATABASE aula1lab
GO
USE aula1lab

CREATE TABLE titulacao(
	id		INT			 NOT NULL,
	titulo	VARCHAR(40) NOT NULL
	PRIMARY KEY(id)
)

CREATE TABLE professor(
	registro INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	titulacao INT NOT NULL

	PRIMARY KEY(registro),
	FOREIGN KEY(titulacao) REFERENCES titulacao(id) 
)

CREATE TABLE curso(
	codigo INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	area INT NOT NULL

	PRIMARY KEY(codigo)
)

CREATE TABLE aluno(
	ra INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	idade INT NOT NULL CHECK(idade > 0)

	PRIMARY KEY(ra)
)

CREATE TABLE disciplina(
	codigo INT NOT NULL,
	nome VARCHAR(80) NOT NULL,
	carga INT NOT NULL CHECK(carga >= 32)

	PRIMARY KEY(codigo)
)

CREATE TABLE disciplina_professor(
	disciplinaCod INT NOT NULL,
	professorReg INT NOT NULL

	PRIMARY KEY(disciplinaCod, professorReg),
	FOREIGN KEY(disciplinaCod) REFERENCES disciplina(codigo),
	FOREIGN KEY(professorReg) REFERENCES professor(registro)
)

CREATE TABLE curso_disciplina(
	cursoCod INT NOT NULL,
	disciplinaCod INT NOT NULL

	PRIMARY KEY(cursoCod, disciplinaCod),
	FOREIGN KEY(disciplinaCod) REFERENCES disciplina(codigo),
	FOREIGN KEY(cursoCod) REFERENCES curso(codigo)
)

CREATE TABLE aluno_disciplina(
	alunoRa INT NOT NULL,
	disciplinaCod INT NOT NULL

	PRIMARY KEY(alunoRa, disciplinaCod),
	FOREIGN KEY(disciplinaCod) REFERENCES disciplina(codigo),
	FOREIGN KEY(alunoRa) REFERENCES aluno(ra)
)

INSERT INTO titulacao(id, titulo) VALUES
	(1,	'Especialista'),
	(2,	'Mestre'),
	(3,	'Doutor')

INSERT INTO curso(codigo, nome, area) VALUES
	(1, 'ADS', 'Ciências da Computação'),
	(2, 'Logística', 'Engenharia Civil')

INSERT INTO professor(registro, nome, titulacao) VALUES
	(1111, 'Leandro', 2),
	(1112, 'Antonio', 2),
	(1113, 'Alexandre', 3),
	(1114, 'Wellington', 2),
	(1115, 'Luciano', 1),
	(1116, 'Edson',	2),
	(1117, 'Ana', 2),
	(1118, 'Alfredo', 1),	
	(1119, 'Celio',	2),
	(1120, 'Dewar',	3),
	(1121, 'Julio',	1)

INSERT INTO disciplina(codigo, nome, carga) VALUES
	(1, 'Laboratório de Banco de Dados', 80),
	(1, 'Laboratório de Engenharia de Software', 80),
	(3, 'Programação Linear e Aplicações', 80),
	(4, 'Redes de Computadores', 80),
	(5, 'Segurança da informação', 40),
	(6, 'Teste de Software',	80),
	(7, 'Custos e Tarifas Logísticas', 80),
	(8, 'Gestão de Estoques', 40),	
	(9, 'Fundamentos de Marketing',	40),
	(10, 'Métodos Quantitativos de Gestão',	80),
	(11, 'Gestão do Tráfego Urbano', 80),
	(12, 'Sistemas de Movimentação e Transporte', 40)

INSERT INTO aluno(ra, nome, idade) VALUES
	(3416, 'DIEGO PIOVESAN DE RAMOS', 18),
	(3423, 'LEONARDO MAGALHÃES DA ROSA', 17),
	(3434, 'LUIZA CRISTINA DE LIMA MARTINELI', 20),
	(3440, 'IVO ANDRÉ FIGUEIRA DA SILVA', 25),
	(3443, 'BRUNA LUISA SIMIONI', 37),
	(3448, 'THAÍS NICOLINI DE MELLO',	17),
	(3457, 'LÚCIO DANIEL TÂMARA ALVES', 29),
	(3459, 'LEONARDO RODRIGUES', 25),	
	(3465, 'ÉDERSON RAFAEL VIEIRA',	19),
	(3466, 'DAIANA ZANROSSO DE OLIVEIRA',	21),
	(3467, 'DANIELA MAURER', 23),
	(3470, 'ALEX SALVADORI PALUDO', 42),
	(3471, 'VINÍCIUS SCHVARTZ', 19),
	(3472, 'MARIANA CHIES ZAMPIERI', 18),
	(3482, 'EDUARDO CAINAN GAVSKI', 19),
	(3483, 'REDNALDO ORTIZ DONEDA', 20),
	(3499, 'MAYELEN ZAMPIERON', 22)

INSERT INTO aluno_disciplina(disciplinaCod, alunoRa) VALUES
	(1, 3416),
	(4, 3416),
	(1, 3423),
	(2, 3423),
	(5, 3423),
	(6, 3423),
	(2, 3434),
	(5, 3434),
	(6, 3434),
	(1, 3440),
	(5, 3443),
	(6, 3443),
	(4, 3448),
	(, 3448),
	(, 3448),
	(, 3457),
	(, 3457),
	(, 3457),
	(4, 3457),
	(5, 3459),
	(6, 3459),
	(1, 3465),
	(6, 3465),
	(7, 3465),
	(11, 3466),
	(8, 3466),
	(11, 3467),
	(8, 3467),
	(12, 3470),
	(8, 3470),
	(9, 3470),
	(11, 3470),
	(12, 3471),
	(7, 3472),
	(7, 3472),
	(12, 3472),
	(9, 3482),
	(11, 3482),
	(8, 3483),
	(11, 3483),
	(12, 3483),
	(8, 3499)

USE master
DROP DATABASE aula1lab