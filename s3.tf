
resource "aws_s3_bucket" "music" {
  bucket = "harry-martland-music"
  acl    = "private"
  storage_class = "STANDARD_IA"
}

resource "aws_s3_bucket" "backup" {
  bucket = "harry-martland-backup"
  acl    = "private"
  storage_class = "GLACIER"
}