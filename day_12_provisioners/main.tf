



resource "aws_key_pair" "keys" {
  key_name = "test"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "test" {
  ami = "ami-07ff62358b87c7116"
  key_name = aws_key_pair.keys.key_name
  instance_type = "t3.micro"

connection {
  type = "ssh"
  host = aws_instance.test.public_ip
  user = "ec2-user"
  private_key = file("~/.ssh/id_ed25519")
}

provisioner "remote-exec" {
  inline = [ 
    "sudo yum update",
      "sudo yum install -y nginx"
   ]
}
}

