resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "alexey-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Artist"
  range_key      = "SongTitle"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "SongTitle"
    type = "S"
  }

 

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  

  tags = {
    Name        = "alexey-table-1"
    Environment = "production"
  }
}