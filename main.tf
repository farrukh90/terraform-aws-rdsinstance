resource "random_password" "password" {
  length           = 16
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "dbpass" {
  name  = var.db_name
  type  = "SecureString"
  value = random_password.password.result
}



resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  db_name              = var.db_name
  password             = random_password.password.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = var.publicly_accessible
}

output endpoint {
  value = aws_db_instance.default.address
}