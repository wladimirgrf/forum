resource "aws_api_gateway_rest_api" "api_gateway" {
  name                     = "forum-api"
  minimum_compression_size = 1000000
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeployment = sha1(timestamp())
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.gateway_integration,
    aws_api_gateway_integration.gateway_integration_options
  ]
}

resource "aws_api_gateway_stage" "gateway_stage" {
  stage_name = "prod"

  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
}

resource "aws_api_gateway_resource" "gateway_resource" {
  path_part = "{proxy+}"

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
}

resource "aws_api_gateway_method" "gateway_method" {
  http_method   = "ANY"
  authorization = "NONE"

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
}

resource "aws_api_gateway_integration" "gateway_integration" {
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri         = aws_lambda_function.service_function.invoke_arn
  http_method = aws_api_gateway_method.gateway_method.http_method
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id = uuid()
  action       = "lambda:InvokeFunction"
  principal    = "apigateway.amazonaws.com"

  function_name = aws_lambda_function.service_function.function_name
  source_arn    = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

# CORS POLICY
resource "aws_api_gateway_method" "gateway_method_options" {
  http_method   = "OPTIONS"
  authorization = "NONE"

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
}

resource "aws_api_gateway_integration" "gateway_integration_options" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.gateway_method_options.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_method_response" "gateway_method_response_options" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.gateway_method_options.http_method

  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "gateway_integration_response_options" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.gateway_method_options.http_method

  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
  }

  depends_on = [
    aws_api_gateway_integration.gateway_integration_options,
    aws_api_gateway_method_response.gateway_method_response_options,
  ]
}
# CORS POLICY
