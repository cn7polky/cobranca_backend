CREATE TABLE cad_inputs (
  input_id INT(11) NOT NULL AUTO_INCREMENT,
  input_value DECIMAL(10, 2) NOT NULL,
  input_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  input_reason LONGTEXT NOT NULL,
  cad_users_user_id INT(11) NOT NULL,
  cad_box_box_id INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (input_id),
  INDEX fk_cad_users (cad_users_user_id),
  INDEX fk_cad_box_cad_box1 (cad_box_box_id),
  CONSTRAINT fk_cad_box_cad_box1 FOREIGN KEY (cad_box_box_id) REFERENCES cad_box (box_id),
  CONSTRAINT fk_cad_users_cad_users1 FOREIGN KEY (cad_users_user_id) REFERENCES cad_users (user_id)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB;