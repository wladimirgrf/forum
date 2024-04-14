resource "aws_iam_role" "iam_role" {
  name = "forum-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "apigateway.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "iam_policy" {
  name = "forum-iam-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:PutObject"
        ]
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "attachment"
  roles      = [aws_iam_role.iam_role.name]
  policy_arn = aws_iam_policy.iam_policy.arn
}
