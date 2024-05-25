resource "aws_lambda_function" "service_function" {
  function_name = "forum-service"
  handler       = "main.handler"
  runtime       = "nodejs20.x"

  timeout     = 10
  memory_size = 512

  role             = aws_iam_role.iam_role.arn
  filename         = data.archive_file.service_file.output_path
  source_code_hash = data.archive_file.service_file.output_base64sha256

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
      JWT_PRIVATE_KEY = base64encode(tls_private_key.app_key.private_key_pem)
      JWT_PUBLIC_KEY  = base64encode(tls_private_key.app_key.public_key_pem)

      AWS_BUCKET_NAME = aws_s3_bucket.app_bucket.bucket

      REDIS_HOST = aws_elasticache_cluster.cluster_redis.cache_nodes[0].address
      REDIS_PORT = aws_elasticache_cluster.cluster_redis.cache_nodes[0].port

      DATABASE_URL = local.db_instance_postgres_database_url
    }
  }
}

resource "null_resource" "service_build" {
  count = 1

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      npm i --prefix ..
      npm run build --prefix ..
    EOT
  }
}

data "archive_file" "service_file" {
  depends_on  = [null_resource.service_build]
  type        = "zip"
  source_dir  = "../dist"
  output_path = "../lambda.zip"
}

resource "aws_cloudwatch_log_group" "service_log_group" {
  name = "/aws/lambda/${aws_lambda_function.service_function.function_name}"
}
