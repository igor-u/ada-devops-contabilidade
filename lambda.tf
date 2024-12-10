data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "function_sns_policy" {
  name   = "function-sns-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SNSFullAccess",
            "Effect": "Allow",
            "Action": "sns:*",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "function_sns_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_sns_policy.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/tekuchi_lambda_function"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tekuchi_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.tekuchi_bucket.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "tekuchi_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "tekuchi_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  layers = [aws_lambda_layer_version.python_mysql_layer.arn]
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      DB_ENDPOINT = aws_db_instance.tekuchi_db_instance.address
      SNS_TOPIC_ARN = aws_sns_topic.tekuchi_sns_topic.arn
    }
  }
  depends_on = [ aws_lambda_layer_version.python_mysql_layer, aws_cloudwatch_log_group.lambda_log_group ]
}

resource "null_resource" "wait_for_lambda_trigger" {
  depends_on   = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = aws_s3_bucket.tekuchi_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.tekuchi_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on   = [null_resource.wait_for_lambda_trigger]
}

resource "aws_lambda_layer_version" "python_mysql_layer" {
  filename   = "${path.module}/lambda-layers/python.zip"
  layer_name = "python-mysql-connector-layer"

  source_code_hash = data.archive_file.lambda.output_base64sha256
  
  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tekuchi_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.tekuchi_sns_topic.arn
}
