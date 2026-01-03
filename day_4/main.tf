resource "aws_instance" "name" {
  ami = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  tags = {
    name = "dev"
  }
}