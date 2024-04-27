locals {
  db_instance_postgres_database_url = "postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.db_instance_postgres.address}:${aws_db_instance.db_instance_postgres.port}/${aws_db_instance.db_instance_postgres.db_name}"
}

resource "aws_db_instance" "db_instance_postgres" {
  db_name            = "forum"
  engine             = "postgres"
  instance_class     = "db.t4g.small"
  ca_cert_identifier = "rds-ca-rsa2048-g1"

  allocated_storage   = 5
  apply_immediately   = true
  skip_final_snapshot = true

  identifier = "forum-pg"
  username   = var.database_username
  password   = var.database_password

  parameter_group_name = aws_db_parameter_group.parameter_group_postgres.name

  db_subnet_group_name   = aws_db_subnet_group.subnet_group_rds.name
  vpc_security_group_ids = [aws_security_group.security_group_postgres.id]
}

resource "aws_db_subnet_group" "subnet_group_rds" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_b.id,
    aws_subnet.subnet_private_c.id,
  ]
}

resource "aws_security_group" "security_group_postgres" {
  name = "postgres-security-group"

  vpc_id = aws_vpc.vpc_private.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      aws_subnet.subnet_private_a.cidr_block,
      aws_subnet.subnet_private_b.cidr_block,
      aws_subnet.subnet_private_c.cidr_block
    ]
  }
}

resource "aws_db_parameter_group" "parameter_group_postgres" {
  name   = "custom-postgres16"
  family = "postgres16"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

resource "aws_lambda_function" "migration_function" {
  function_name = "forum-migrations"
  handler       = "main.handler"
  runtime       = "nodejs20.x"

  timeout     = 10
  memory_size = 1024

  role             = aws_iam_role.iam_role.arn
  filename         = data.archive_file.migration_file.output_path
  source_code_hash = data.archive_file.migration_file.output_base64sha256

  vpc_config {
    security_group_ids = [aws_security_group.security_group_lambda.id]

    subnet_ids = [
      aws_subnet.subnet_private_a.id,
      aws_subnet.subnet_private_b.id,
      aws_subnet.subnet_private_c.id,
    ]
  }

  environment {
    variables = {
      DATABASE_URL = local.db_instance_postgres_database_url
    }
  }
}

resource "null_resource" "migration_build" {
  count = 1

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      npm i --prefix ..
      npm i --prefix ./migrations
      npm run build --prefix ./migrations
    EOT
  }
}

data "archive_file" "migration_file" {
  depends_on  = [null_resource.migration_build]
  type        = "zip"
  source_dir  = "./migrations/dist"
  output_path = "./migrations/lambda.zip"
}

resource "aws_lambda_invocation" "migration_run" {
  function_name = aws_lambda_function.migration_function.function_name

  input = jsonencode({})

  triggers = {
    always_run = timestamp()
  }
}

resource "aws_cloudwatch_log_group" "migration_log_group" {
  name = "/aws/lambda/${aws_lambda_function.migration_function.function_name}"
}
