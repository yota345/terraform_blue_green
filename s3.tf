variable "region" {}
variable "s3_bucket_name" {}
variable "state_key" {}


resource "aws_s3_bucket" "terraform_s3_bucket" {
  bucket = "${var.s3_bucket_name}"
  acl = "private"
  versioning {
    enabled = true
  }
  tags {
    Name = "${var.s3_bucket_name}"
    Environment = "Production"
  }
}


data "terraform_remote_state" "terraform_remote_state" {
  backend = "s3"
  config {
    bucket = "${aws_s3_bucket.terraform_s3_bucket.id}"
    key = "${var.state_key}"
    region = "${var.region}"
  }
}
