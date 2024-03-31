resource "aws_db_instance" "db_instance_postgres" {
  db_name            = "forum"
  engine             = "postgres"
  instance_class     = "db.t4g.small"
  ca_cert_identifier = "rds-ca-rsa2048-g1"

  allocated_storage   = 5
  publicly_accessible = true
  apply_immediately   = true
  skip_final_snapshot = true

  identifier = "forum-pg"
  username   = var.database_username
  password   = var.database_password

  parameter_group_name   = aws_db_parameter_group.parameter_group_postgres.name
  vpc_security_group_ids = [aws_security_group.security_group_postgres.id]
}

resource "aws_db_parameter_group" "parameter_group_postgres" {
  name   = "custom-postgres16"
  family = "postgres16"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

resource "aws_security_group" "security_group_postgres" {
  name = "postgres-security-group"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "db_migration" {
  count = 1

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      npm ci
      export DATABASE_URL="postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.db_instance_postgres.address}:${aws_db_instance.db_instance_postgres.port}/${aws_db_instance.db_instance_postgres.db_name}"
      npm run db:migrate
    EOT
  }
}
