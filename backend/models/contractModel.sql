CREATE TABLE cad_contracts (
  contract_id INT(11) NOT NULL AUTO_INCREMENT,
  contract_plan LONGTEXT NOT NULL,
  contract_paysun ENUM('Y', 'N') NOT NULL DEFAULT 'N',
  contract_paysat ENUM('Y', 'N') NOT NULL DEFAULT 'N',
  contract_fexpiry DATE NOT NULL,
  contract_status ENUM('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
  company_id INT(11) NOT NULL,
  PRIMARY KEY (contract_id),
  INDEX company_id (company_id)
) COLLATE = 'utf8_general_ci' ENGINE = MyISAM;