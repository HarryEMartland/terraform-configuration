
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name                = "Lambda Errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "3600"
  statistic                 = "Sum"
  threshold                 = "0"
  alarm_description         = "Alarms in any lambda functions have errors"
  alarm_actions = ["arn:aws:sns:eu-west-1:818032293643:Alarms"]
}

