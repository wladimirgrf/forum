resource "aws_s3_bucket" "app_bucket" {
  bucket = "forum-files"
}

resource "aws_s3_bucket" "app_test_bucket" {
  bucket = "forum-test-files"
}
