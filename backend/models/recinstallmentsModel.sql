CREATE TABLE cad_recinstallments (
  recin_id INT(11) NOT NULL AUTO_INCREMENT,
  recin_value DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  recin_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  cad_installments_installment_id INT(11) NOT NULL DEFAULT '0',
  cad_box_box_id INT(11) NOT NULL DEFAULT '0',
  cad_users_user_id INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (recin_id),
  INDEX fk_cad_users_cad_users5 (cad_users_user_id),
  INDEX fk_cad_box_box5 (cad_box_box_id),
  INDEX fk_cad_installments_cad_installments5 (cad_installments_installment_id),
  CONSTRAINT fk_cad_box_box5 FOREIGN KEY (cad_box_box_id) REFERENCES cad_box (box_id),
  CONSTRAINT fk_cad_installments_cad_installments5 FOREIGN KEY (cad_installments_installment_id) REFERENCES cad_installments (installment_id),
  CONSTRAINT fk_cad_users_cad_users5 FOREIGN KEY (cad_users_user_id) REFERENCES cad_users (user_id)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB;