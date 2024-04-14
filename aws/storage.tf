resource "aws_s3_bucket" "app_bucket" {
  bucket = "161401c5-forum-files"
}

resource "aws_s3_bucket" "app_test_bucket" {
  bucket = "161401c5-forum-test-files"
}
