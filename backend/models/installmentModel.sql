CREATE TABLE cad_installments (
  installment_id INT(11) NOT NULL AUTO_INCREMENT,
  installment_value DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  installment_qtd INT(11) NOT NULL DEFAULT '0',
  installment_date DATE NOT NULL,
  installment_historic LONGTEXT NULL,
  installment_status ENUM('RECEBIDA', 'PENDENTE', 'VENCIDA') NOT NULL DEFAULT 'PENDENTE',
  plan_id INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (installment_id),
  INDEX plan_id (plan_id),
  CONSTRAINT plan_id FOREIGN KEY (plan_id) REFERENCES cad_plans (plan_id)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
------------------------------- VERSÃO 2 ---------------------------------------------
CREATE TABLE cad_installments (
  installment_id INT(11) NOT NULL AUTO_INCREMENT,
  installment_value DECIMAL(10, 2) NOT NULL,
  installment_number INT(11) NOT NULL,
  installment_date DATE NOT NULL,
  installment_historic LONGTEXT NULL,
  installment_status ENUM('RECEBIDA', 'PENDENTE', 'VENCIDA', 'COBRADO') NOT NULL DEFAULT 'PENDENTE',
  installment_historicpay LONGTEXT NULL,
  cad_contracts_contract_id INT(11) NOT NULL,
  PRIMARY KEY (installment_id),
  INDEX fk_cad_installments_cad_contracts1_idx (cad_contracts_contract_id),
  CONSTRAINT fk_cad_installments_cad_contracts1 FOREIGN KEY (cad_contracts_contract_id) REFERENCES cad_contracts (contract_id) ON UPDATE NO ACTION ON DELETE NO ACTION
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB AUTO_INCREMENT = 216;