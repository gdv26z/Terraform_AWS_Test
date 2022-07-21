provider "aws" {
  region = "eu-central-1"
}


resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"

}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS Mysql"
  type        = "SecureString"
  value       = random_string.rds_password.result

}


data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}


output "rds_password" {
  value = nonsensitive(data.aws_ssm_parameter.my_rds_password.value)
}
