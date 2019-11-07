CREATE TABLE cad_plans (
  plan_id INT(11) NOT NULL AUTO_INCREMENT,
  plan_value DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  plan_valueday DECIMAL(10, 2) NOT NULL DEFAULT '0.00',
  plan_days INT(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (plan_id)
) ENGINE = InnoDB;

INSERT INTO cad_plans (plan_values, plan_11, plan_24)
VALUES
	(300, 30, 15),
	(400, 40, 20),
	(500, 50, 25),
	(600, 60, 30),
	(700, 70, 35),
	(800, 80, 40),
	(900, 90, 45),
	(1000, 100, 50),
	(1100, 110, 55),
	(1200, 120, 60),
	(1300, 130, 65),
	(1400, 140, 70),
	(1500, 150, 75),
	(2000, 200, 100)