resource "aws_db_instance" "db_instance_postgres" {
  db_name            = "forum"
  engine             = "postgres"
  instance_class     = "db.t4g.small"
  ca_cert_identifier = "rds-ca-rsa2048-g1"

  allocated_storage = 5

  identifier = "forum-pg"
  username   = var.database_username
  password   = var.database_password

  parameter_group_name = aws_db_parameter_group.parameter_group_postgres.name
}

resource "aws_db_parameter_group" "parameter_group_postgres" {
  name   = "custom-postgres16"
  family = "postgres16"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}
