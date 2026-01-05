

resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-vishesh-day6"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = "tfstate-vishesh-day6"

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_instance" "day6" {
  ami = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  tags = {
    Name = "State"
  }
}