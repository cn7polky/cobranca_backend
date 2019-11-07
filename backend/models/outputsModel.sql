CREATE TABLE cad_outputs (
  output_id INT(11) NOT NULL AUTO_INCREMENT,
  output_value DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  output_date DATE NOT NULL,
  output_reason VARCHAR(255) NOT NULL DEFAULT '0',
  cad_users_user_id INT(11) NOT NULL DEFAULT '0',
  cad_box_box_id INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (output_id),
  INDEX fk_cad_users_cad_users2 (cad_users_user_id),
  INDEX fk_cad_box_cad_box2 (cad_box_box_id),
  CONSTRAINT fk_cad_box_cad_box2 FOREIGN KEY (cad_box_box_id) REFERENCES cad_box (box_id),
  CONSTRAINT fk_cad_users_cad_users2 FOREIGN KEY (cad_users_user_id) REFERENCES cad_users (user_id)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB;