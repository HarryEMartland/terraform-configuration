
resource "aws_s3_bucket" "music" {
  bucket = "hm-music"
  acl    = "private"
}

resource "aws_s3_bucket" "backup" {
  bucket = "hm-backup"
  acl    = "private"
}