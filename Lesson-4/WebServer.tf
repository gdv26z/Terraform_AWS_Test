provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_Amazon_linux" {
  ami           = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type = "t2.micro"
  tags = {
    Name = "WebServer"
  }
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Alexey",
    l_name = "Miha",
    names  = ["Vasya", "kolya", "Deny", "john", "Masha"]
  })

}

resource "aws_security_group" "my_webserver" {
  name        = "web_server_secure_group"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_servers"
  }
}
