provider "aws" {

}
resource "aws_instance" "my_Ubutu" {
  ami           = "ami-065deacbcaac64cf2"
  instance_type = "t2.micro"
  count         = 2

}
resource "aws_instance" "my_Amazon_linux" {
  ami           = "ami-0a1ee2fb28fe05df3"
  instance_type = "t2.micro"
  tags = {
    Name    = "my Amazon server"
    owner   = "Alexey"
    project = "terraform remote state"
  }
}
