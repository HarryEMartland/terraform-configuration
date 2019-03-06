
resource "aws_cloudwatch_event_rule" "every-half-hour" {
  name        = "EveryHalfHour"
  description = "Runs every half hour at 36 and 06"
  schedule_expression = "cron(6,36 * ? * * *)"
}