CREATE TABLE `cad_clients` (
  `client_id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_name` VARCHAR(45) NOT NULL,
  `client_doc` VARCHAR(50) NOT NULL DEFAULT '',
  `client_tel` VARCHAR(45) NOT NULL,
  `client_adress` LONGTEXT NOT NULL,
  `client_status` ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  `client_type` ENUM('Físico', 'Jurídico') NOT NULL,
  PRIMARY KEY (`client_id`),
  UNIQUE INDEX `company_tel_UNIQUE` (`client_tel`),
  UNIQUE INDEX `client_doc` (`client_doc`)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB AUTO_INCREMENT = 28;