
resource "aws_lambda_function" "S3Flack2Mp3" {
  function_name    = "S3Flack2Mp3"
  role             = "${aws_iam_role.generic-lambda.*.arn[2]}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
}