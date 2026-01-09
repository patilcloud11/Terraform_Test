resource "aws_iam_policy" "policy" {
  name = "lambda_policy"
  policy = jsonencode({
	Version = "2012-10-17",
	Statement = [
		{
			Sid = "Statement1",
			Effect = "Allow",
			Action = [
				"events:*",
				"cloudwatch:*"
			],
			Resource = [
				"*",
				"*"
			]
		}
	]
})
}



resource "aws_iam_role" "lambda_event" {
  name = "role_lambda_event"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action = [
                "sts:AssumeRole"
            ],
            Principal = {
                Service = [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
})
}



resource "aws_iam_policy_attachment" "lambda_attach" {
    name = "lambda_event_attach"
  roles = [aws_iam_role.lambda_event.name]
  policy_arn = aws_iam_policy.policy.arn
}



resource "aws_lambda_function" "lambda_vishesh" {
  function_name = "vishesh_lambda"
  role = aws_iam_role.lambda_event.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  filename = "lambda_function.zip"


  source_code_hash = filebase64sha256("lambda_function.zip")
}



resource "aws_cloudwatch_event_rule" "every_three_min" {
name  = "every_three_min"
description = "Trigger lambda every three Min"
schedule_expression = "cron(0/3 * * * ? *)"
}


resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule = aws_cloudwatch_event_rule.every_three_min.name
  target_id = "lambda"
  arn = aws_lambda_function.lambda_vishesh.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_vishesh.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_three_min.arn
}