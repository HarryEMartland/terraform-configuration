
data "aws_s3_bucket" "music" {
  bucket = "hm-music"
}

data "aws_s3_bucket" "backup" {
  bucket = "hm-backup"
}