variable "allow_port" {
  type = map(string)
  default = {
    "22" = "115.98.37.0/24"
    "80" = "0.0.0.0/0"
    "443" = "0.0.0.0/0"
    "8080" = "10.0.0.0/16"
    "9000" = "192.168.0.0/24"
  }
}

resource "aws_security_group" "my_sg" {
  name = "sg_diff_cidr"
  description = "allow"
  
dynamic "ingress" {
    for_each = var.allow_port
    content {
      from_port = ingress.key
      to_port = ingress.key
      protocol = "tcp"
      cidr_blocks = [ingress.value]
      description = "allow access ${ingress.key}"
    }
  
}

egress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "sg_diff_cidr"

}
}
