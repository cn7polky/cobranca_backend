CREATE SCHEMA IF NOT EXISTS `cobranca_model` DEFAULT CHARACTER SET utf8;
-- -----------------------------------------------------
-- Schema cobranca_app
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_owners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_owners` (
  `owner_id` INT NOT NULL AUTO_INCREMENT,
  `owner_name` VARCHAR(250) NOT NULL,
  `owner_cpf` VARCHAR(45) NOT NULL,
  `owner_adress` LONGTEXT NOT NULL,
  `owner_tel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`owner_id`),
  UNIQUE INDEX `owner_cpf_UNIQUE` (`owner_cpf` ASC),
  UNIQUE INDEX `owner_tel_UNIQUE` (`owner_tel` ASC)
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_companies` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(45) NOT NULL,
  `company_tel` VARCHAR(45) NOT NULL,
  `company_adress` LONGTEXT NOT NULL,
  `company_active` ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  `cad_owners_owner_id` INT NOT NULL,
  PRIMARY KEY (`company_id`),
  UNIQUE INDEX `company_tel_UNIQUE` (`company_tel` ASC),
  INDEX `fk_cad_companies_cad_owners1_idx` (`cad_owners_owner_id` ASC),
  CONSTRAINT `fk_cad_companies_cad_owners1` FOREIGN KEY (`cad_owners_owner_id`) REFERENCES `cobranca_model`.`cad_owners` (`owner_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_contracts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_contracts` (
  `contract_id` INT NOT NULL AUTO_INCREMENT,
  `contract_plan` VARCHAR(255) NOT NULL,
  `contract_paysun` ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  `contract_paysat` ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  `contract_fexpiry` DATE NOT NULL,
  `contract_status` ENUM('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
  `cad_companies_company_id` INT NOT NULL,
  PRIMARY KEY (`contract_id`),
  INDEX `fk_cad_contracts_cad_companies1_idx` (`cad_companies_company_id` ASC),
  CONSTRAINT `fk_cad_contracts_cad_companies1` FOREIGN KEY (`cad_companies_company_id`) REFERENCES `cobranca_model`.`cad_companies` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_districts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_districts` (
  `district_id` INT NOT NULL AUTO_INCREMENT,
  `district_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`district_id`)
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_plans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_plans` (
  `plan_id` INT NOT NULL AUTO_INCREMENT,
  `plan_values` DECIMAL(10, 2) NOT NULL,
  `plan_11` DECIMAL(10, 2) NOT NULL,
  `plan_24` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_installments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_installments` (
  `installment_id` INT NOT NULL AUTO_INCREMENT,
  `installment_value` DECIMAL(10, 2) NOT NULL,
  `installment_number` INT NOT NULL,
  `installment_date` DATE NOT NULL,
  `installment_historic` LONGTEXT NOT NULL,
  `installment_status` ENUM('RECEBIDA', 'PENDENTE', 'VENCIDA') NOT NULL,
  `cad_plans_plan_id` INT NOT NULL,
  `cad_contracts_contract_id` INT NOT NULL,
  PRIMARY KEY (`installment_id`),
  INDEX `fk_cad_installments_cad_plans1_idx` (`cad_plans_plan_id` ASC),
  INDEX `fk_cad_installments_cad_contracts1_idx` (`cad_contracts_contract_id` ASC),
  CONSTRAINT `fk_cad_installments_cad_plans1` FOREIGN KEY (`cad_plans_plan_id`) REFERENCES `cobranca_model`.`cad_plans` (`plan_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cad_installments_cad_contracts1` FOREIGN KEY (`cad_contracts_contract_id`) REFERENCES `cobranca_model`.`cad_contracts` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `cobranca_model`.`cad_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_model`.`cad_users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(255) NOT NULL,
  `user_email` VARCHAR(200) NOT NULL,
  `user_tel` VARCHAR(45) NOT NULL,
  `user_pass` VARCHAR(45) NOT NULL,
  `user_level` INT NOT NULL DEFAULT 0,
  `user_active` ENUM('Y', 'N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC),
  UNIQUE INDEX `user_tel_UNIQUE` (`user_tel` ASC)
) ENGINE = InnoDB;
USE `cobranca_app`;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_owners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_owners` (
  `owner_id` INT(11) NOT NULL AUTO_INCREMENT,
  `owner_name` VARCHAR(250) NOT NULL DEFAULT '0',
  `owner_cpf` VARCHAR(50) NOT NULL DEFAULT '0',
  `owner_adress` LONGTEXT NOT NULL,
  `owner_tel` VARCHAR(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner_id`),
  UNIQUE INDEX `owner_cpf` (`owner_cpf` ASC),
  UNIQUE INDEX `owner_tel` (`owner_tel` ASC)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_companies` (
  `company_id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(250) NOT NULL DEFAULT '0',
  `company_tel` VARCHAR(250) NOT NULL DEFAULT '0',
  `company_adress` LONGTEXT NOT NULL,
  `company_active` ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  `owner_id` INT(11) NULL DEFAULT '0',
  PRIMARY KEY (`company_id`),
  UNIQUE INDEX `company_tel` (`company_tel` ASC),
  INDEX `owner_id` (`owner_id` ASC),
  CONSTRAINT `owner_id` FOREIGN KEY (`owner_id`) REFERENCES `cobranca_app`.`cad_owners` (`owner_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 48 DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_contracts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_contracts` (
  `contract_id` INT(11) NOT NULL AUTO_INCREMENT,
  `contract_plan` LONGTEXT NOT NULL,
  `contract_paysun` ENUM('Y', 'N') NOT NULL DEFAULT 'N',
  `contract_paysat` ENUM('Y', 'N') NOT NULL DEFAULT 'N',
  `contract_fexpiry` DATE NOT NULL,
  `contract_status` ENUM('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
  `company_id` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`contract_id`)
) ENGINE = MyISAM DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_districts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_districts` (
  `district_id` INT(11) NOT NULL AUTO_INCREMENT,
  `district_name` VARCHAR(250) NOT NULL DEFAULT '0',
  PRIMARY KEY (`district_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 98 DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_plans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_plans` (
  `plan_id` INT(11) NOT NULL AUTO_INCREMENT,
  `plan_values` DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  `plan_11` DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  `plan_24` DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`plan_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_installments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_installments` (
  `installment_id` INT(11) NOT NULL AUTO_INCREMENT,
  `installment_value` DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  `installment_qtd` INT(11) NOT NULL DEFAULT '0',
  `installment_date` DATE NOT NULL,
  `installment_historic` LONGTEXT NULL DEFAULT NULL,
  `installment_status` ENUM('RECEBIDA', 'PENDENTE', 'VENCIDA') NOT NULL DEFAULT 'PENDENTE',
  `plan_id` INT(11) NOT NULL DEFAULT '0',
  `contract_id` INT(11) NOT NULL,
  PRIMARY KEY (`installment_id`),
  INDEX `plan_id` (`plan_id` ASC),
  CONSTRAINT `plan_id` FOREIGN KEY (`plan_id`) REFERENCES `cobranca_app`.`cad_plans` (`plan_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;
-- -----------------------------------------------------
-- Table `cobranca_app`.`cad_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cobranca_app`.`cad_users` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(250) NOT NULL DEFAULT '0',
  `user_email` VARCHAR(150) NOT NULL DEFAULT '0',
  `user_tel` VARCHAR(100) NOT NULL DEFAULT '0',
  `user_pass` VARCHAR(200) NOT NULL DEFAULT '0',
  `user_level` INT(11) NULL DEFAULT '0',
  `user_active` ENUM('Y', 'N') NULL DEFAULT 'N',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_email` (`user_email` ASC)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARACTER SET = utf8;
SET
  SQL_MODE = @OLD_SQL_MODE;
SET
  FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET
  UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
--------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  ----------------------------------- VERSÃO 2.0 ---------------------------------------------
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  -- --------------------------------------------------------
  -- Servidor:                     127.0.0.1
  -- Versão do servidor:           5.7.26 - MySQL Community Server (GPL)
  -- OS do Servidor:               Win64
  -- HeidiSQL Versão:              10.2.0.5599
  -- --------------------------------------------------------
  /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
  /*!40101 SET NAMES utf8 */;
  /*!50503 SET NAMES utf8mb4 */;
  /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
  /*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- Copiando estrutura do banco de dados para cobranca_model
  CREATE DATABASE IF NOT EXISTS `cobranca_model`
  /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `cobranca_model`;
-- Copiando estrutura para tabela cobranca_model.cad_box
  CREATE TABLE IF NOT EXISTS `cad_box` (
    `box_id` int(11) NOT NULL AUTO_INCREMENT,
    `box_opendate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `box_openvalue` decimal(10, 2) NOT NULL DEFAULT '0.00',
    `box_closedate` datetime DEFAULT NULL,
    `box_closevalue` decimal(10, 2) DEFAULT '0.00',
    `box_route` varchar(255) NOT NULL DEFAULT '0',
    `box_status` enum('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
    `cad_users_user_id` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`box_id`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 23 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_companies
  CREATE TABLE IF NOT EXISTS `cad_companies` (
    `company_id` int(11) NOT NULL AUTO_INCREMENT,
    `company_name` varchar(45) NOT NULL,
    `company_tel` varchar(45) NOT NULL,
    `company_adress` longtext NOT NULL,
    `company_active` enum('Y', 'N') NOT NULL DEFAULT 'Y',
    `cad_owners_owner_id` int(11) NOT NULL,
    PRIMARY KEY (`company_id`),
    UNIQUE KEY `company_tel_UNIQUE` (`company_tel`),
    KEY `fk_cad_companies_cad_owners1_idx` (`cad_owners_owner_id`),
    CONSTRAINT `fk_cad_companies_cad_owners1` FOREIGN KEY (`cad_owners_owner_id`) REFERENCES `cad_owners` (`owner_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
  ) ENGINE = InnoDB AUTO_INCREMENT = 14 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_contracts
  CREATE TABLE IF NOT EXISTS `cad_contracts` (
    `contract_id` int(11) NOT NULL AUTO_INCREMENT,
    `contract_status` enum('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
    `cad_companies_company_id` int(11) NOT NULL,
    `cad_plans_plan_id` int(11) NOT NULL,
    `cad_users_user_id` int(11) NOT NULL,
    PRIMARY KEY (`contract_id`),
    KEY `fk_cad_contracts_cad_companies1_idx` (`cad_companies_company_id`),
    KEY `fk_cad_plans_plan_id1` (`cad_plans_plan_id`),
    KEY `fk_cad_users_cad_users4` (`cad_users_user_id`),
    CONSTRAINT `fk_cad_contracts_cad_companies1` FOREIGN KEY (`cad_companies_company_id`) REFERENCES `cad_companies` (`company_id`),
    CONSTRAINT `fk_cad_plans_plan_id1` FOREIGN KEY (`cad_plans_plan_id`) REFERENCES `cad_plans` (`plan_id`),
    CONSTRAINT `fk_cad_users_cad_users4` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 57 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_districts
  CREATE TABLE IF NOT EXISTS `cad_districts` (
    `district_id` int(11) NOT NULL AUTO_INCREMENT,
    `district_name` varchar(255) NOT NULL,
    PRIMARY KEY (`district_id`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 98 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_inputs
  CREATE TABLE IF NOT EXISTS `cad_inputs` (
    `input_id` int(11) NOT NULL AUTO_INCREMENT,
    `input_value` decimal(10, 2) NOT NULL,
    `input_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `input_reason` longtext NOT NULL,
    `cad_users_user_id` int(11) NOT NULL,
    `cad_box_box_id` int(11) DEFAULT NULL,
    PRIMARY KEY (`input_id`),
    KEY `fk_cad_users` (`cad_users_user_id`),
    KEY `fk_cad_box_cad_box1` (`cad_box_box_id`),
    CONSTRAINT `fk_cad_box_cad_box1` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
    CONSTRAINT `fk_cad_users_cad_users1` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_installments
  CREATE TABLE IF NOT EXISTS `cad_installments` (
    `installment_id` int(11) NOT NULL AUTO_INCREMENT,
    `installment_value` decimal(10, 2) NOT NULL,
    `installment_remaing` decimal(10, 2) DEFAULT NULL,
    `installment_number` int(11) NOT NULL,
    `installment_date` date NOT NULL,
    `installment_historic` longtext,
    `installment_status` enum('RECEBIDA', 'PENDENTE', 'VENCIDA', 'COBRADO') NOT NULL DEFAULT 'PENDENTE',
    `cad_contracts_contract_id` int(11) NOT NULL,
    `cad_box_box_id` int(11) DEFAULT NULL,
    PRIMARY KEY (`installment_id`),
    KEY `fk_cad_installments_cad_contracts1_idx` (`cad_contracts_contract_id`),
    KEY `fk_cad_box_cad_box3` (`cad_box_box_id`),
    CONSTRAINT `fk_cad_box_cad_box3` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
    CONSTRAINT `fk_cad_contracts_contracts1` FOREIGN KEY (`cad_contracts_contract_id`) REFERENCES `cad_contracts` (`contract_id`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 442 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_outputs
  CREATE TABLE IF NOT EXISTS `cad_outputs` (
    `output_id` int(11) NOT NULL AUTO_INCREMENT,
    `output_value` decimal(10, 2) NOT NULL DEFAULT '0.00',
    `output_date` date NOT NULL,
    `output_reason` varchar(255) NOT NULL DEFAULT '0',
    `cad_users_user_id` int(11) NOT NULL DEFAULT '0',
    `cad_box_box_id` int(11) DEFAULT NULL,
    PRIMARY KEY (`output_id`),
    KEY `fk_cad_users_cad_users2` (`cad_users_user_id`),
    KEY `fk_cad_box_cad_box2` (`cad_box_box_id`),
    CONSTRAINT `fk_cad_box_cad_box2` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
    CONSTRAINT `fk_cad_users_cad_users2` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_owners
  CREATE TABLE IF NOT EXISTS `cad_owners` (
    `owner_id` int(11) NOT NULL AUTO_INCREMENT,
    `owner_name` varchar(250) NOT NULL,
    `owner_cpf` varchar(45) NOT NULL,
    `owner_adress` longtext NOT NULL,
    `owner_tel` varchar(45) NOT NULL,
    PRIMARY KEY (`owner_id`),
    UNIQUE KEY `owner_cpf_UNIQUE` (`owner_cpf`),
    UNIQUE KEY `owner_tel_UNIQUE` (`owner_tel`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_plans
  CREATE TABLE IF NOT EXISTS `cad_plans` (
    `plan_id` int(11) NOT NULL AUTO_INCREMENT,
    `plan_values` decimal(10, 2) NOT NULL,
    `plan_11` decimal(10, 2) NOT NULL,
    `plan_24` decimal(10, 2) NOT NULL,
    PRIMARY KEY (`plan_id`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_recinstallments
  CREATE TABLE IF NOT EXISTS `cad_recinstallments` (
    `recin_id` int(11) NOT NULL AUTO_INCREMENT,
    `recin_value` decimal(10, 2) NOT NULL DEFAULT '0.00',
    `recin_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `cad_installments_installment_id` int(11) NOT NULL DEFAULT '0',
    `cad_box_box_id` int(11) NOT NULL DEFAULT '0',
    `cad_users_user_id` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`recin_id`),
    KEY `fk_cad_users_cad_users5` (`cad_users_user_id`),
    KEY `fk_cad_box_box5` (`cad_box_box_id`),
    KEY `fk_cad_installments_cad_installments5` (`cad_installments_installment_id`),
    CONSTRAINT `fk_cad_box_box5` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
    CONSTRAINT `fk_cad_installments_cad_installments5` FOREIGN KEY (`cad_installments_installment_id`) REFERENCES `cad_installments` (`installment_id`),
    CONSTRAINT `fk_cad_users_cad_users5` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  -- Copiando estrutura para tabela cobranca_model.cad_users
  CREATE TABLE IF NOT EXISTS `cad_users` (
    `user_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_name` varchar(255) NOT NULL,
    `user_email` varchar(200) NOT NULL,
    `user_tel` varchar(45) NOT NULL,
    `user_pass` varchar(45) NOT NULL,
    `user_level` int(11) NOT NULL DEFAULT '0',
    `user_status` enum('ATIVO', 'INATIVO') NOT NULL DEFAULT 'INATIVO',
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `user_email_UNIQUE` (`user_email`),
    UNIQUE KEY `user_tel_UNIQUE` (`user_tel`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8;
-- Exportação de dados foi desmarcado.
  /*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
  /*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
  /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;