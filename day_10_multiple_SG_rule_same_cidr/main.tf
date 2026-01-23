# resource "aws_security_group" "name" {
#   name = "internal"
#   description = "allow"


# ingress {

# from_port = 22
# to_port = 22
# protocol = "tcp"
# cidr_blocks = ["0.0.0.0/0"]
# }


# ingress {
#     from_port = 80
#     to_port = 80
#     protocol ="tcp"
#     cidr_blocks = ["0.0.0.0/0"]   
# }


# egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
# }

# tags = {
#     Name ="sg1"
# }
# }



resource "aws_security_group" "name" {
  name = "internal_sg"
  description = "allow"


ingress = [
    for port in [22, 3000, 80, 443] :{
        description = "inbound rules"
        from_port = port
        to_port = port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
        
    }
]

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "sg2"
}
}