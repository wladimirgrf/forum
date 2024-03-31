resource "aws_lambda_function" "lambda_function" {
  function_name = "forum-lambda"
  publish       = true

  handler = "main.handler"
  runtime = "nodejs20.x"

  timeout     = 10
  memory_size = 512

  environment {
    variables = {
      JWT_PRIVATE_KEY = base64encode(tls_private_key.app_key.private_key_pem)
      JWT_PUBLIC_KEY  = base64encode(tls_private_key.app_key.public_key_pem)

      AWS_BUCKET_NAME = aws_s3_bucket.app_bucket.bucket

      REDIS_HOST = aws_elasticache_cluster.cluster_redis.cache_nodes[0].address
      REDIS_PORT = aws_elasticache_cluster.cluster_redis.cache_nodes[0].port

      DATABASE_URL = "postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.db_instance_postgres.address}:${aws_db_instance.db_instance_postgres.port}/${aws_db_instance.db_instance_postgres.db_name}"
    }
  }

  role             = aws_iam_role.iam_role.arn
  filename         = data.archive_file.lambda_file.output_path
  source_code_hash = data.archive_file.lambda_file.output_base64sha256
}

resource "null_resource" "lambda_build" {
  count = 1

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      npm ci
      npm run build
    EOT
  }
}

data "archive_file" "lambda_file" {
  depends_on  = [null_resource.lambda_build]
  type        = "zip"
  source_dir  = "../dist"
  output_path = "../lambda.zip"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}
