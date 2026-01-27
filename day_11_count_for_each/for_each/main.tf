# variable "env" {
#   type = list(string)
#   default = [ "vish","dev" ]
# }

# resource "aws_instance" "name" {
#   ami = "ami-07ff62358b87c7116"
#   instance_type = "t3.micro"
#   for_each = toset(var.env)
#   tags = {
#     Name = each.value
#   }
# }


resource "aws_instance" "name" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  for_each = toset([
    "vish-server",
    "dev-server"
  ])
  

  tags = {
    Name = each.value
  }
}