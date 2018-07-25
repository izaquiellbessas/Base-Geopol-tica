-- MySQL Script generated by MySQL Workbench
-- Tue Jul 24 22:00:14 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema geografia
-- -----------------------------------------------------
-- Sistema de Gerenciamento de Regiões Geográficas e/ou Geopolíticas - Base fundamental para demais sistemas que envolvem geopolítica
DROP SCHEMA IF EXISTS `geografia` ;

-- -----------------------------------------------------
-- Schema geografia
--
-- Sistema de Gerenciamento de Regiões Geográficas e/ou Geopolíticas - Base fundamental para demais sistemas que envolvem geopolítica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `geografia` ;
USE `geografia` ;

-- -----------------------------------------------------
-- Table `geografia`.`Paises`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Paises` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Paises` (
  `nome` VARCHAR(90) NOT NULL,
  `iso_alpha2` VARCHAR(2) NOT NULL,
  `iso_alpha3` VARCHAR(3) NOT NULL,
  `iso_numero` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`iso_alpha3`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `geografia`.`Estados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Estados` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Estados` (
  `id_estado` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `sigla_uf` VARCHAR(2) NOT NULL,
  `fk_pais` VARCHAR(3) NULL,
  PRIMARY KEY (`id_estado`),
  INDEX `fk_Estados_Paises1_idx` (`fk_pais` ASC),
  CONSTRAINT `fk_Estados_Paises1`
    FOREIGN KEY (`fk_pais`)
    REFERENCES `geografia`.`Paises` (`iso_alpha3`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `geografia`.`Regioes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Regioes` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Regioes` (
  `id_regiao` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_regiao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `geografia`.`Mesorregioes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Mesorregioes` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Mesorregioes` (
  `id_mesorregiao` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(90) NOT NULL,
  `fk_id_regiao` INT NOT NULL,
  PRIMARY KEY (`id_mesorregiao`),
  INDEX `fk_Mesoregioes_Regioes_idx` (`fk_id_regiao` ASC),
  CONSTRAINT `fk_Mesoregioes_Regioes`
    FOREIGN KEY (`fk_id_regiao`)
    REFERENCES `geografia`.`Regioes` (`id_regiao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `geografia`.`Microrregioes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Microrregioes` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Microrregioes` (
  `id_micrroregiao` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(90) NOT NULL,
  `fk_id_mesoregiao` INT NOT NULL,
  PRIMARY KEY (`id_micrroregiao`),
  INDEX `fk_Microregioes_Mesoregioes1_idx` (`fk_id_mesoregiao` ASC),
  CONSTRAINT `fk_Microregioes_Mesoregioes1`
    FOREIGN KEY (`fk_id_mesoregiao`)
    REFERENCES `geografia`.`Mesorregioes` (`id_mesorregiao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `geografia`.`Cidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `geografia`.`Cidades` ;

CREATE TABLE IF NOT EXISTS `geografia`.`Cidades` (
  `id_cidade` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(120) NOT NULL,
  `geo_latitude` VARCHAR(255) NULL,
  `geo_longitude` VARCHAR(255) NULL,
  `geo_altitude` VARCHAR(255) NULL,
  `codigo_ibge` INT(9) NULL,
  `fk_id_microrregiao` INT NULL,
  `fk_id_estado` INT NOT NULL,
  PRIMARY KEY (`id_cidade`),
  INDEX `fk_Cidades_Microregioes1_idx` (`fk_id_microrregiao` ASC),
  INDEX `fk_Cidades_Estados1_idx` (`fk_id_estado` ASC),
  CONSTRAINT `fk_Cidades_Microregioes1`
    FOREIGN KEY (`fk_id_microrregiao`)
    REFERENCES `geografia`.`Microrregioes` (`id_micrroregiao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cidades_Estados1`
    FOREIGN KEY (`fk_id_estado`)
    REFERENCES `geografia`.`Estados` (`id_estado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `geografia` ;

-- -----------------------------------------------------
-- Placeholder table for view `geografia`.`view_regioes_mesorregioes_microrregioes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `geografia`.`view_regioes_mesorregioes_microrregioes` (`'Microrregião'` INT, `'Mesorregião'` INT, `'Região'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `geografia`.`view_cidades_com_estados_e_regioes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `geografia`.`view_cidades_com_estados_e_regioes` (`'Código IBGE'` INT, `'Cidades'` INT, `'Microrregião'` INT, `'Mesorregião'` INT, `'Estado/UF'` INT, `'Região'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `geografia`.`view_cidades_com_todas_caracteristicas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `geografia`.`view_cidades_com_todas_caracteristicas` (`'Código Sistema'` INT, `'Código IBGE'` INT, `'Cidades'` INT, `'Microrregião'` INT, `'Mesorregião'` INT, `'Estado/UF'` INT, `'Região'` INT, `'Altitude'` INT, `'Latitude'` INT, `'Longitude'` INT);

-- -----------------------------------------------------
-- View `geografia`.`view_regioes_mesorregioes_microrregioes`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `geografia`.`view_regioes_mesorregioes_microrregioes` ;
DROP TABLE IF EXISTS `geografia`.`view_regioes_mesorregioes_microrregioes`;
USE `geografia`;
CREATE  OR REPLACE VIEW `view_regioes_mesorregioes_microrregioes` AS
SELECT microrregioes.nome AS 'Microrregião',
	   mesorregioes.nome AS 'Mesorregião',
       regioes.nome AS 'Região'
FROM geografia.regioes AS regioes,
	 geografia.mesorregioes AS mesorregioes,
     geografia.microrregioes AS microrregioes
WHERE mesorregioes.id_mesorregiao = microrregioes.fk_id_mesoregiao AND 
	  mesorregioes.fk_id_regiao = regioes.id_regiao
ORDER BY regioes.nome, mesorregioes.nome, microrregioes.nome
;

-- -----------------------------------------------------
-- View `geografia`.`view_cidades_com_estados_e_regioes`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `geografia`.`view_cidades_com_estados_e_regioes` ;
DROP TABLE IF EXISTS `geografia`.`view_cidades_com_estados_e_regioes`;
USE `geografia`;
CREATE  OR REPLACE VIEW `view_cidades_com_estados_e_regioes` AS
SELECT cidades.codigo_ibge AS 'Código IBGE',
	   cidades.nome AS 'Cidades',
	   microrregioes.nome AS 'Microrregião',
	   mesorregioes.nome AS 'Mesorregião',
       estados.sigla_uf AS 'Estado/UF',
       regioes.nome AS 'Região'
FROM geografia.cidades,
	 geografia.regioes,
	 geografia.mesorregioes,
     geografia.microrregioes,
     geografia.estados
WHERE mesorregioes.id_mesorregiao = microrregioes.fk_id_mesoregiao AND 
	  mesorregioes.fk_id_regiao = regioes.id_regiao AND
      cidades.fk_id_microrregiao = microrregioes.id_micrroregiao AND
      cidades.fk_id_estado = estados.id_estado
ORDER BY regioes.nome, estados.sigla_uf, mesorregioes.nome, microrregioes.nome, cidades.nome
;

-- -----------------------------------------------------
-- View `geografia`.`view_cidades_com_todas_caracteristicas`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `geografia`.`view_cidades_com_todas_caracteristicas` ;
DROP TABLE IF EXISTS `geografia`.`view_cidades_com_todas_caracteristicas`;
USE `geografia`;
CREATE  OR REPLACE VIEW `view_cidades_com_todas_caracteristicas` AS
SELECT cidades.id_cidade AS 'Código Sistema',
	   cidades.codigo_ibge AS 'Código IBGE',
	   cidades.nome AS 'Cidades',
	   microrregioes.nome AS 'Microrregião',
	   mesorregioes.nome AS 'Mesorregião',
       estados.sigla_uf AS 'Estado/UF',
       regioes.nome AS 'Região',
       cidades.geo_altitude AS 'Altitude',
       cidades.geo_latitude AS 'Latitude',
       cidades.geo_longitude AS 'Longitude'
FROM geografia.cidades,
	 geografia.regioes,
	 geografia.mesorregioes,
     geografia.microrregioes,
     geografia.estados
WHERE mesorregioes.id_mesorregiao = microrregioes.fk_id_mesoregiao AND 
	  mesorregioes.fk_id_regiao = regioes.id_regiao AND
      cidades.fk_id_microrregiao = microrregioes.id_micrroregiao AND
      cidades.fk_id_estado = estados.id_estado
ORDER BY regioes.nome, estados.sigla_uf, mesorregioes.nome, microrregioes.nome, cidades.nome
;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
