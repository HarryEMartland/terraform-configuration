resource "aws_cloudwatch_dashboard" "lambda_dashbaord" {
  dashboard_name = "Lambda-Dashboard"

  dashboard_body = <<EOF
 {
    "start": "-PT24H",
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "LogMetrics", "foundTweets", { "label": "Found Tweets", "stat": "Maximum" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-1",
                "title": "Found Tweets",
                "period": 3600,
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "min": 0
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 9,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "LogMetrics", "chainTweet", { "label": "Chain Tweets", "stat": "Sum" } ],
                    [ "LogMetrics", "${aws_cloudwatch_log_metric_filter.totalTweetMetricFilter.name}", { "label": "Total Tweets", "stat": "Sum" } ],
                    [ "LogMetrics", "${aws_cloudwatch_log_metric_filter.retweetCountMetricFilter.name}", { "label": "Retweets", "stat": "Sum" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-1",
                "title": "Sent Tweets",
                "period": 3600,
                "yAxis": {
                    "left": {
                        "showUnits": true,
                        "min": 0
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 9,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Errors", "FunctionName", "CYFAutoAssign", { "stat": "Sum" } ],
                    [ "...", "HarryBotMeetuptweeter", { "stat": "Sum" } ],
                    [ "...", "HarryBotRetweet", { "stat": "Sum" } ],
                    [ "...", "LearnToCodesTwitterBot", { "stat": "Sum" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-1",
                "title": "Lambda Errors",
                "period": 3600
            }
        }
    ]
}
 EOF
}