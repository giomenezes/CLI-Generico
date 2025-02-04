DROP DATABASE IF EXISTS gct_individual;
CREATE DATABASE IF NOT EXISTS `gct_individual` DEFAULT CHARACTER SET utf8 ;
USE `gct_individual`;


CREATE TABLE IF NOT EXISTS `empresa` (
  `id_empresa` INT NOT NULL auto_increment,
  `razao_social` VARCHAR(120) NULL,
  `cnpj` CHAR(18) NULL,
  `numero_imovel` INT NULL,
  `cep` CHAR(9) NULL,
  `email` VARCHAR(150) NULL,
  `telefone` VARCHAR(13) NULL,
  `complemento` VARCHAR(450) NULL,
  PRIMARY KEY (`id_empresa`)
);

CREATE TABLE IF NOT EXISTS `funcionario` (
  `id_funcionario` INT NOT NULL primary key auto_increment,
  `nome` VARCHAR(120) NULL,
  `email` VARCHAR(150) NULL,
  `senha` VARCHAR(150) NULL,
  `cargo` VARCHAR(90) NULL,
  `cpf` CHAR(14) NULL,
  `permissao` INT NOT NULL,
  `fk_gerente` INT,
  `fk_empresa` INT NOT NULL,
  FOREIGN KEY (`fk_gerente`) REFERENCES funcionario(`id_funcionario`) ON DELETE CASCADE,
  FOREIGN KEY (`fk_empresa`) REFERENCES empresa(`id_empresa`) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS `servidor` (
  `id_servidor` INT NOT NULL auto_increment,
  `nome` VARCHAR(60) NULL,
  `codigo` VARCHAR(50) NULL,
  `tipo` VARCHAR(100) NULL,
  `descricao` VARCHAR(200) NULL,
  `status` TINYINT NULL,
  `fk_empresa` INT NOT NULL,
  `prioridade` INT NULL,
  `localizacao` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id_servidor`),
  FOREIGN KEY (`fk_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS `unidade_medida` (
  `id_unidade_medida` INT NOT NULL auto_increment,
  `sigla` CHAR(5) NULL,
  PRIMARY KEY (`id_unidade_medida`)
);


CREATE TABLE IF NOT EXISTS `modelo_componente` (
  `id_modelo_componente` INT NOT NULL auto_increment,
  `modelo` VARCHAR(50) NULL,
  `fabricante` VARCHAR(60) NULL,
  PRIMARY KEY (`id_modelo_componente`)
);

CREATE TABLE IF NOT EXISTS `componente` (
  `id_componente` INT NOT NULL auto_increment,
  `tipo_componente` VARCHAR(60) NULL,
  `fk_modelo_componente` INT NOT NULL,
  `fk_servidor` INT NOT NULL,
  PRIMARY KEY (`id_componente`),
  FOREIGN KEY (`fk_modelo_componente`) REFERENCES `modelo_componente` (`id_modelo_componente`) ON DELETE CASCADE,
  FOREIGN KEY (`fk_servidor`) REFERENCES `servidor` (`id_servidor`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `chamados` (
  `id_chamados` INT NOT NULL auto_increment,
  `titulo` VARCHAR(60) NULL,
  `descricao` VARCHAR(200) NULL,
  `data_hora` DATETIME NULL,
  `status` VARCHAR(30) NULL,
  `link` VARCHAR(200),
  `fk_componente` INT NOT NULL,
  `fk_empresa` INT NOT NULL,
  PRIMARY KEY (`id_chamados`),
  FOREIGN KEY (`fk_componente`) REFERENCES `componente` (`id_componente`) ON DELETE CASCADE,
  FOREIGN KEY (`fk_empresa`) REFERENCES `empresa` (id_empresa) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `registro` (
  `id_registro` INT NOT NULL auto_increment,
  `valor_registro` DOUBLE NULL,
  `data_registro` DATETIME NULL,
  `fk_componente` INT NOT NULL,
  `fk_medida` INT NOT NULL,
  PRIMARY KEY (`id_registro`),
  FOREIGN KEY (`fk_componente`) REFERENCES `componente` (`id_componente`) ON DELETE CASCADE,
  FOREIGN KEY (`fk_medida`) REFERENCES `unidade_medida` (`id_unidade_medida`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `anomalia`(
  `id_anomalia` INT NOT NULL auto_increment,
  `solucao` VARCHAR(450),
  `fk_chamados` INT NOT NULL,
  primary key (`id_anomalia`),
  foreign key (`fk_chamados`) REFERENCES `chamados`(`id_chamados`) ON DELETE CASCADE
);

-- Cadastro de Empresas
INSERT INTO `empresa` (`razao_social`, `cnpj`, `numero_imovel`, `cep`, `email`, `telefone`) 
VALUES ('Pague Seguro',"61.186.888/0093-01", 763, '09260-640', 'pagueSeguro@gmail.com', '123123123')
	, ('SPTECH', "61.186.888/0093-01", 298,'09260-640', 'sptech@gmail.com', '456456456')
	, ('Amazon', "61.186.888/0093-01", 234,'09260-640', 'amazon@gmail.com', '889877677');
Select * from `empresa`;


-- Cadastro de Gerentes
INSERT INTO `funcionario` (`nome`, `email`, `senha`, `cargo`, `cpf`, `permissao`, `fk_gerente`, `fk_empresa`)
VALUES ('Gabriel', 'gabriel@gmail.com', '12345', 'Gerente', '690.969.360-43', '1', null, 1)
	, ('Fernando Brandão', 'fernado@gmail.com', '12345', 'Presidente', '226.146.010-47', '1', null, 2)
    , ('Cláudio', 'claudio@gmail.com', '12345', 'Gerente', '810.791.190-35', '1', null, 3);


-- Cadastro de Funcionários
INSERT INTO `funcionario` (`nome`, `email`, `senha`, `cargo`, `cpf`, `permissao`, `fk_gerente`, `fk_empresa`)
values ('Cleiton Rodrigues', 'cleiton@gmail.com', '12345', 'Analísta Junior', "514.184.580-07", '2', 1, 1)
	, ('Carlos Souza', 'carlos@gmail.com', '12345', 'Analísta Sênior', "541.886.660-56", '1', 2, 2)
    , ('Pedro Henrique', 'pedro@gmail.com', '12345', 'Analísta Sênior', "091.045.750-67", '1', 3, 3);

SELECT * FROM `funcionario`;

-- Cadastro de Servidores 
INSERT INTO `servidor` (`nome`, `codigo`, `tipo`,`status`, `descricao`, `fk_empresa`, `localizacao`)
VALUES ('SERVER-AHRL1NB', 'XPTO-0987', 'Servidor Principal',1, 'Servidor responsável por executar X tarefa', 1, 'Sede empresa 012 - Port 3')
	, ('SERVER-9HJD2AL', 'XP-9384', 'Servidor de Backup',1, 'Servidor responsável por backups', 1, 'Sede empresa 234 - Comp A')
    , ('SERVER-UHD71P6', 'LOC-0284', 'Servidor de Homologação',1, 'Servidor responsável por Homologações ', 1, 'Sede empresa 102 - Port 1');

UPDATE servidor set `status` = 0 WHERE id_servidor in(2);

-- Cadastro de Modelo de Componentes
INSERT INTO `modelo_componente` (`modelo`, `fabricante`)
VALUES
('Intel Core i7 13700K', 'Intel'),
('AMD Ryzen 7 7800X', 'AMD'),
('Apple M1 Max', 'Apple'),
('DDR4 3200MHz 16GB', 'Corsair'),
('DDR5 4800MHz 32GB', 'G.Skill'),
('LPDDR5 6400MHz 64GB', 'Samsung'),
('Samsung 980 Pro 1TB', 'Samsung'),
('WD Black SN850 2TB', 'Western Digital'),
('Seagate FireCuda 530 4TB', 'Seagate');


-- Cadastro de Componentes
INSERT INTO `componente` (`tipo_componente`, `fk_modelo_componente`, `fk_servidor`) VALUES 
('CPU', 1, 1),
('RAM', 5, 1),
('Disco', 8, 1),
('CPU', 1, 2),
('RAM',5, 2),
('Disco', 8, 2);

INSERT INTO `unidade_medida` (`sigla`) VALUES
('%'),
('GB'),
('GHz'),
('s'),
('UN');

-- Chamados
INSERT INTO `chamados` (`titulo`, `descricao`, `data_hora`, `status`, `fk_componente`, `fk_empresa`) VALUES
("Alerta uso da CPU", "Uso da CPU está em 90%", "2023-09-09 14:00:00", "Aberto", 1, 1),
("Alerta uso da RAM", "Uso da RAM está em 80%", "2023-09-09 14:00:00", "Aberto", 2, 1),
("Alerta uso da CPU", "Uso da CPU está em 90%", "2023-09-09 14:00:00", "Aberto", 4, 1),
("Alerta uso da RAM", "Uso da RAM está em 80%", "2023-09-09 14:00:00", "Aberto", 5, 1),
("Alerta uso da CPU", "Uso da CPU está em 90%", "2023-10-09 14:05:32", "Aberto", 1, 1),
("Alerta uso da RAM", "Uso da RAM está em 80%", "2023-10-09 14:05:32", "Aberto", 2, 1),
("Alerta uso da Disco", "Uso da Disco está em 75%", "2023-10-09 14:05:32", "Aberto", 3, 1),
("Alerta uso da CPU", "Uso da CPU está em 90%", "2023-10-09 14:05:32", "Aberto", 4, 1),
("Alerta uso da RAM", "Uso da RAM está em 80%", "2023-10-09 14:05:32", "Aberto", 5, 1);


CREATE OR REPLACE VIEW `vw_registro_geral` AS 
SELECT 
    `registro`.`data_registro`,
    `registro`.`valor_registro`,
    `unidade_medida`.`sigla`,
    `componente`.`tipo_componente`,
    `componente`.`fk_servidor`
    
FROM `registro`
    INNER JOIN `unidade_medida` ON 
        `registro`.`fk_medida` = `unidade_medida`.`id_unidade_medida`
    INNER JOIN `componente` ON
        `registro`.`fk_componente` = `componente`.`id_componente`;

CREATE OR REPLACE VIEW `vw_registro_RAM` AS 
SELECT * FROM `vw_registro_geral` 
  WHERE `tipo_componente` LIKE 'RAM';

CREATE OR REPLACE VIEW `vw_registro_CPU` AS 
SELECT * FROM `vw_registro_geral` 
  WHERE `tipo_componente` LIKE 'CPU';

CREATE OR REPLACE VIEW `vw_registro_Disco` AS 
SELECT * FROM `vw_registro_geral` 
  WHERE `tipo_componente` LIKE 'Disco';

CREATE OR REPLACE VIEW `vw_registro_componente` AS
SELECT registro.*, tipo_componente
        FROM registro, componente;


drop function if exists p1;
drop view if exists h_parm;
create function p1() returns INTEGER DETERMINISTIC NO SQL return @p1;

create view h_parm as
SELECT registro.*, tipo_componente
        FROM registro, componente
        WHERE tipo_componente IN ("CPU", "RAM", "Disco")
        AND id_componente = fk_componente
        AND fk_servidor = p1()
        ORDER BY data_registro DESC
        LIMIT 3;

select s.* from (select @p1:=1 p) parm , h_parm s;

select * from registro
        WHERE tipo_componente IN ("CPU", "RAM", "Disco")
        AND id_componente = fk_componente
        AND fk_servidor = 1
        ORDER BY data_registro DESC
        LIMIT 3;

CREATE TABLE IF NOT EXISTS `processo` (
	id INT PRIMARY KEY AUTO_INCREMENT,
	pid INT,
    nome VARCHAR(200),
    uso_cpu DOUBLE,
    uso_memoria DOUBLE, 
    bytes_utilizados DOUBLE,
    swap_utilizada DOUBLE,
    data_registro DATETIME,
    fk_servidor INT NOT NULL,
    FOREIGN KEY (`fk_servidor`) REFERENCES servidor(`id_servidor`) ON DELETE CASCADE
);

CREATE OR REPLACE VIEW `vw_processos_consumidores` AS
 SELECT * FROM processo 
 WHERE uso_cpu > 20 
 ORDER BY uso_cpu;