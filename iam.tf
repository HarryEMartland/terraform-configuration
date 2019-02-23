
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
      "Resource": ["arn:aws:iam::${var.account_id}:role/${var.lambdas[count.index]}"]
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "lambda-deploys" {
  user = "lambda-deploy-${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
}

resource "aws_iam_role" "HarryBotRetweet" {
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

resource "aws_iam_policy" "HarryBotRetweet" {
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

resource "aws_iam_role_policy_attachment" "HarryBotRetweet-logs" {
  policy_arn = "${aws_iam_policy.HarryBotRetweet.*.arn[count.index]}"
  role = "${aws_iam_role.HarryBotRetweet.*.name[count.index]}"
  count = "${length(var.lambdas)}"
}

resource "aws_iam_role_policy_attachment" "HarryBotRetweet-comprehend" {
  policy_arn = "arn:aws:iam::aws:policy/ComprehendReadOnly"
  role = "${aws_iam_role.HarryBotRetweet.*.name[1]}"
}