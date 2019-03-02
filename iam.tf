
variable "lambdas" {
  type = "list"
  default = ["LearnToCodesTwitterBot","HarryBotRetweet"]
}

resource "aws_iam_user" "read_only" {
  name = "read_only"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = "${aws_iam_user.read_only.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user" "lambda-deploys" {
  name = "lambda-deploy-${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
  tags = { tag-key = "lambda-deploy" }
}

resource "aws_iam_user_policy" "lambda-deploys" {
  name = "lambda-deploy-${var.lambdas[count.index]}"
  user = "${aws_iam_user.lambda-deploys.*.name[count.index]}"
  count = "${length(var.lambdas)}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:GetFunction",
        "lambda:UpdateFunctionConfiguration"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:lambda:eu-west-1:${var.account_id}:function:${var.lambdas[count.index]}"]
    },{
      "Action": ["iam:PassRole"],
      "Effect": "Allow",
      "Resource": ["${aws_iam_role.generic-lambda.*.arn[count.index]}"]
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "lambda-deploys" {
  user = "lambda-deploy-${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
}

resource "aws_iam_role" "generic-lambda" {
  name = "lambda-${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "generic-lambda-logs" {
  name = "${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
  description = "Allow the lambda function ${var.lambdas[count.index]} to log"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "learntocodes-lambda-db-access" {
  name = "learntocodes-lambda-db-access"
  description = "Allow learn to codes lambda to access dynamodb"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:UpdateItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:eu-west-1:818032293643:table/LearnToCodesTwitterBot"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "generic-lambda-logs" {
  policy_arn = "${aws_iam_policy.generic-lambda-logs.*.arn[count.index]}"
  role = "${aws_iam_role.generic-lambda.*.name[count.index]}"
  count = "${length(var.lambdas)}"
}

resource "aws_iam_role_policy_attachment" "HarryBotRetweet-comprehend" {
  policy_arn = "arn:aws:iam::aws:policy/ComprehendReadOnly"
  role = "${aws_iam_role.generic-lambda.*.name[1]}"
}

resource "aws_iam_role_policy_attachment" "LernToCodes-db-access" {
  policy_arn = "${aws_iam_policy.learntocodes-lambda-db-access.arn}"
  role = "${aws_iam_role.generic-lambda.*.name[0]}"
}