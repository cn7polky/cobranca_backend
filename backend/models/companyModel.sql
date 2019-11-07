CREATE TABLE cad_companies (
  company_id INT(11) NOT NULL AUTO_INCREMENT,
  company_name VARCHAR(250) NOT NULL DEFAULT '0',
  company_tel VARCHAR(250) NOT NULL DEFAULT '0',
  company_adress LONGTEXT NOT NULL,
  owner_id INT(11) NULL DEFAULT '0',
  company_active ENUM('Y', 'N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (company_id),
  UNIQUE INDEX company_tel (company_tel),
  INDEX owner_id (owner_id),
  CONSTRAINT owner_id FOREIGN KEY (owner_id) REFERENCES cad_owners (owner_id)
) COLLATE = 'utf8_general_ci' ENGINE = InnoDB AUTO_INCREMENT = 26;