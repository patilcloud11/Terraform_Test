# resource "aws_instance" "name" {
#   ami = "ami-07ff62358b87c7116"
#   instance_type = "t3.micro"
#   count = 2
#   tags = {
#     Name = "vish"
#   }
# }

variable "env" {
  type = list(string)
  default = [ "vish","dev" ]
}

resource "aws_instance" "name" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  count = length(var.env)
  tags = {
    Name = var.env[count.index]
  }
}