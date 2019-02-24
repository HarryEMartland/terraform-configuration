
resource "aws_cloudwatch_log_metric_filter" "totalTweetMetricFilter" {
  name           = "totalTweet"
  pattern        = "{$.totalTweet = *}"
  log_group_name = "/aws/lambda/LearnToCodesTwitterBot"

  metric_transformation {
    name      = "totalTweet"
    namespace = "LogMetrics"
    value     = "$.totalTweet"
  }
}

resource "aws_cloudwatch_log_metric_filter" "retweetCountMetricFilter" {
  name           = "retweetCount"
  pattern        = "{$.retweetCount = *}"
  log_group_name = "/aws/lambda/HarryBotRetweet"

  metric_transformation {
    name      = "retweetCount"
    namespace = "LogMetrics"
    value     = "$.retweetCount"
  }
}