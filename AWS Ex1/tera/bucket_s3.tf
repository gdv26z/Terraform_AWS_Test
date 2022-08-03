# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "ex1_polybot_s3_bucket"
#   acl    = "private"

#   versioning = {
#     enabled = false
#   }

# }



# resource "aws_s3_bucket" "demos3" {
#     bucket = var.bucket_name 
#     acl = var.acl_value   

  

# }



resource "aws_s3_bucket" "b" {
    bucket = var.bucket_name 

  tags = {
    Name        = "My bucket"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl = var.acl_value   
}