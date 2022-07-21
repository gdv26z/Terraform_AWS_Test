provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.my_Amazon_linux.id
  allocation_id = "eipalloc-02ea054c8065f1c11"
}


resource "aws_instance" "my_Amazon_linux" {
  ami                    = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Alexey",
    l_name = "Miha",
    names  = ["Vasya", "kolya", "Deny", "john", "Masha"]
  })
  tags = {
    Name = "Web_Server"
  }
  depends_on = [aws_instance.my_Amazon_linux_db]
}

resource "aws_instance" "my_Amazon_linux_db" {
  ami                    = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags = {
    Name = "DB_Server"
  }
}
resource "aws_instance" "my_Amazon_linux_app" {
  ami                    = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags = {
    Name = "Client_Server"
  }
  depends_on = [aws_instance.my_Amazon_linux_db, aws_instance.my_Amazon_linux]
}




resource "aws_security_group" "my_webserver" {
  name        = "web_server_secure_group"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
