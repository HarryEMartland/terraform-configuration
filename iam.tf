
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
      "Resource": ["arn:aws:lambda:eu-west-1:818032293643:function:${var.lambdas[count.index]}"]
    },{
      "Action": ["iam:PassRole"],
      "Effect": "Allow"
    }
  ]
}
EOF
} #todo create function and limit the passrole

resource "aws_iam_access_key" "lambda-deploys" {
  user = "lambda-deploy-${var.lambdas[count.index]}"
  count = "${length(var.lambdas)}"
}