module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "EX1_polybot-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = false
  }

}