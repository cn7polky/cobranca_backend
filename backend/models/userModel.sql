CREATE TABLE IF NOT EXISTS cad_users (
  user_id int(11) NOT NULL AUTO_INCREMENT,
  user_name varchar(250) NOT NULL DEFAULT 0,
  user_email varchar(150) NOT NULL DEFAULT 0,
  user_tel varchar(100) NOT NULL DEFAULT 0,
  user_pass varchar(200) NOT NULL DEFAULT 0,
  user_level int(11) DEFAULT 0,
  user_active enum('Y', 'N') DEFAULT 'N',
  PRIMARY KEY (user_id),
  UNIQUE KEY user_email (user_email)
) ENGINE = InnoDB AUTO_INCREMENT = 14 DEFAULT CHARSET = utf8;