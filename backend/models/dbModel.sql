
-- Copiando estrutura do banco de dados para cobranca_model
CREATE DATABASE IF NOT EXISTS `cobranca_model` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `cobranca_model`;

-- Copiando estrutura para tabela cobranca_model.cad_box
CREATE TABLE IF NOT EXISTS `cad_box` (
  `box_id` int(11) NOT NULL AUTO_INCREMENT,
  `box_opendate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `box_openvalue` decimal(10,2) NOT NULL DEFAULT '0.00',
  `box_closedate` datetime DEFAULT NULL,
  `box_closevalue` decimal(10,2) DEFAULT '0.00',
  `box_route` varchar(255) NOT NULL DEFAULT '0',
  `box_status` enum('ABERTO','FECHADO') NOT NULL DEFAULT 'ABERTO',
  `cad_users_user_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`box_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_clients
CREATE TABLE IF NOT EXISTS `cad_clients` (
  `client_id` int(11) NOT NULL AUTO_INCREMENT,
  `client_name` varchar(45) NOT NULL,
  `client_doc` varchar(50) NOT NULL DEFAULT '',
  `client_tel` varchar(45) NOT NULL,
  `client_adress` longtext NOT NULL,
  `client_status` enum('Ativo','Inativo') NOT NULL DEFAULT 'Ativo',
  `client_type` enum('Físico','Jurídico') NOT NULL,
  PRIMARY KEY (`client_id`),
  UNIQUE KEY `company_tel_UNIQUE` (`client_tel`),
  UNIQUE KEY `client_doc` (`client_doc`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_districts
CREATE TABLE IF NOT EXISTS `cad_districts` (
  `district_id` int(11) NOT NULL AUTO_INCREMENT,
  `district_name` varchar(255) NOT NULL,
  PRIMARY KEY (`district_id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_plans
CREATE TABLE IF NOT EXISTS `cad_plans` (
  `plan_id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_values` decimal(10,2) NOT NULL,
  `plan_11` decimal(10,2) NOT NULL,
  `plan_24` decimal(10,2) NOT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_users
CREATE TABLE IF NOT EXISTS `cad_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `user_email` varchar(200) NOT NULL,
  `user_tel` varchar(45) NOT NULL,
  `user_pass` varchar(45) NOT NULL,
  `user_level` enum('Colaborador','Administrador') NOT NULL DEFAULT 'Colaborador',
  `user_status` enum('Ativo','Inativo') NOT NULL DEFAULT 'Inativo',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email_UNIQUE` (`user_email`),
  UNIQUE KEY `user_tel_UNIQUE` (`user_tel`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_cashflow
CREATE TABLE IF NOT EXISTS `cad_cashflow` (
  `cashf_id` int(11) NOT NULL AUTO_INCREMENT,
  `cashf_value` decimal(10,2) NOT NULL,
  `cashf_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cashf_reason` longtext NOT NULL,
  `cashf_type` enum('ENTRADA','SAIDA') NOT NULL,
  `cad_users_user_id` int(11) NOT NULL,
  `cad_box_box_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`cashf_id`),
  KEY `fk_cad_users` (`cad_users_user_id`),
  KEY `fk_cad_box_cad_box1` (`cad_box_box_id`),
  CONSTRAINT `fk_cad_box_cad_box1` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
  CONSTRAINT `fk_cad_users_cad_users1` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_contracts
CREATE TABLE IF NOT EXISTS `cad_contracts` (
  `contract_id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_status` enum('ABERTO','FECHADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  `contract_dateopen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `contract_dateclose` datetime DEFAULT NULL,
  `cad_clients_client_id` int(11) NOT NULL,
  `cad_plans_plan_id` int(11) NOT NULL,
  `cad_users_user_id` int(11) NOT NULL,
  PRIMARY KEY (`contract_id`),
  KEY `fk_cad_contracts_cad_companies1_idx` (`cad_clients_client_id`),
  KEY `fk_cad_plans_plan_id1` (`cad_plans_plan_id`),
  KEY `fk_cad_users_cad_users4` (`cad_users_user_id`),
  CONSTRAINT `fk_cad_contracts_cad_clients1` FOREIGN KEY (`cad_clients_client_id`) REFERENCES `cad_clients` (`client_id`),
  CONSTRAINT `fk_cad_plans_plan_id1` FOREIGN KEY (`cad_plans_plan_id`) REFERENCES `cad_plans` (`plan_id`),
  CONSTRAINT `fk_cad_users_cad_users4` FOREIGN KEY (`cad_users_user_id`) REFERENCES `cad_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_installments
CREATE TABLE `cad_installments` (
	`installment_id` INT(11) NOT NULL AUTO_INCREMENT,
	`installment_value` DECIMAL(10,2) NOT NULL,
	`installment_remaing` DECIMAL(10,2) NULL DEFAULT NULL,
	`installment_number` INT(11) NOT NULL,
	`installment_date` DATE NOT NULL,
	`installment_historic` LONGTEXT NULL,
	`installment_status` ENUM('RECEBIDA','PENDENTE','VENCIDA','COBRADO') NOT NULL DEFAULT 'PENDENTE',
	`cad_contracts_contract_id` INT(11) NOT NULL,
	`cad_box_box_id` INT(11) NULL DEFAULT NULL,
	`cad_clients_client_id` INT(11) NOT NULL,
	PRIMARY KEY (`installment_id`),
	INDEX `fk_cad_installments_cad_contracts1_idx` (`cad_contracts_contract_id`),
	INDEX `fk_cad_box_cad_box3` (`cad_box_box_id`),
	INDEX `fk_cad_clients_client1` (`cad_clients_client_id`),
	CONSTRAINT `fk_cad_box_cad_box3` FOREIGN KEY (`cad_box_box_id`) REFERENCES `cad_box` (`box_id`),
	CONSTRAINT `fk_cad_clients_client1` FOREIGN KEY (`cad_clients_client_id`) REFERENCES `cad_clients` (`client_id`),
	CONSTRAINT `fk_cad_contracts_contracts1` FOREIGN KEY (`cad_contracts_contract_id`) REFERENCES `cad_contracts` (`contract_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1957
;


-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_recinstallments
CREATE TABLE IF NOT EXISTS `cad_recinstallments` (
  `recin_id` int(11) NOT NULL AUTO_INCREMENT,
  `recin_value` decimal(10,2) NOT NULL DEFAULT '0.00',
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cobranca_model.cad_users
CREATE TABLE IF NOT EXISTS `cad_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `user_email` varchar(200) NOT NULL,
  `user_tel` varchar(45) NOT NULL,
  `user_pass` varchar(45) NOT NULL,
  `user_level` enum('Colaborador','Administrador') NOT NULL DEFAULT 'Colaborador',
  `user_status` enum('Ativo','Inativo') NOT NULL DEFAULT 'Inativo',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email_UNIQUE` (`user_email`),
  UNIQUE KEY `user_tel_UNIQUE` (`user_tel`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
