resource "aws_iam_role" "lambda_role" {
  name = "execution_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            Effect: "Allow",
            Action: [
                "sts:AssumeRole"
            ],
            Principal: {
                Service: [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_role" {
    name = "lambda_attach"
  roles = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
  
}


resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy"
  policy = jsonencode(
[
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"lambda:*"
			],
			"Resource": [
				"*"
			]
		}
	]
}

resource "aws_lambda_function" "lambda_vishesh" {
  function_name = "vishesh_lambda"
  role = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  filename = "lambda_function.zip"


  source_code_hash = filebase64sha256("lambda_function.zip")
}