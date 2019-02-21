
resource "aws_cloudwatch_log_metric_filter" "totalTweetMetricFilter" {
  name           = "totalTweet"
  pattern        = "{$.totalTweet = *}"
  log_group_name = "/aws/lambda/LearnToCodesTwitterBot"

  metric_transformation {
    name      = "totalTweet"
    namespace = "LogMetrics"
    value     = "$.tweetCount"
  }
}
