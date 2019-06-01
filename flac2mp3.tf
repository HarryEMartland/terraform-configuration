
resource "aws_iam_policy" "S3Flac2mp5-s3-access" {
  name = "S3Flac2mp5-s3-access"
  description = "Allow S3Flac2Mp3 to read and write to s3"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::harry-martland-music/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "S3Flac2mp5-sqs-access" {
  name = "S3Flac2mp5-sqs-access"
  description = "Allow S3Flac2Mp3 to receive and send to sqs queue"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:SendMessage"
            ],
            "Resource": [
                "${aws_sqs_queue.flac2mp3.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "S3Flac2mp5-s3-access" {
  policy_arn = "${aws_iam_policy.S3Flac2mp5-s3-access.arn}"
  role = "${aws_iam_role.generic-lambda.*.name[2]}"
}

resource "aws_iam_role_policy_attachment" "S3Flac2mp5-sqs-access" {
  policy_arn = "${aws_iam_policy.S3Flac2mp5-sqs-access.arn}"
  role = "${aws_iam_role.generic-lambda.*.name[2]}"
}

/*resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.music.id}"

  queue {
    queue_arn     = "${aws_sqs_queue.flac2mp3.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".flac"
  }
}*/

resource "aws_sqs_queue" "flac2mp3" {
  name                        = "flac2mp3"
  fifo_queue                  = false
  visibility_timeout_seconds = 60
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:flac2mp3",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.music.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_lambda_event_source_mapping" "flac2mp3-queue" {
  event_source_arn = "${aws_sqs_queue.flac2mp3.arn}"
  function_name    = "arn:aws:lambda:eu-west-1:818032293643:function:S3Flack2Mp3"
  batch_size = 1
}