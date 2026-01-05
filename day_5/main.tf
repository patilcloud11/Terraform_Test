resource "aws_instance" "day4" {
  ami = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  tags = {
    Name = "dev"
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "test-terraform-vishesh"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = "test-terraform-vishesh"
  
  
  versioning_configuration {
    status = "Suspended"
    
  }
  
}

