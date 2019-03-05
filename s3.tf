
resource "aws_s3_bucket" "music" {
  bucket = "harry-martland-music"
  acl    = "private"
}

resource "aws_s3_bucket" "backup" {
  bucket = "harry-martland-backup"
  acl    = "private"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.music.id}"

  lambda_function {
    lambda_function_arn = "arn:aws:lambda:eu-west-1:818032293643:function:S3Flack2Mp3"
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".flac"
  }
}