
resource "aws_s3_bucket" "music" {
  bucket = "harry-martland-music"
  acl    = "private"
}

resource "aws_s3_bucket" "backup" {
  bucket = "harry-martland-backup"
  acl    = "private"
}
