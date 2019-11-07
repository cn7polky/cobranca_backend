CREATE TABLE cad_owners (
  owner_id INT(11) NOT NULL AUTO_INCREMENT,
  owner_name VARCHAR(250) NOT NULL DEFAULT 0,
  owner_cpf VARCHAR(50) NOT NULL DEFAULT 0,
  owner_adress LONGTEXT NOT NULL,
  owner_tel VARCHAR(50) NOT NULL DEFAULT 0,
  PRIMARY KEY (owner_id),
  UNIQUE INDEX owner_cpf (owner_cpf),
  UNIQUE INDEX owner_tel (owner_tel)
) COLLATE = utf8_general_ci ENGINE = InnoDB AUTO_INCREMENT = 6;