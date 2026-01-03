terraform {
  backend "s3" {
    bucket = "test-terraform-vishesh"
    key = "terraform.tfstate"
    region = "us-east-1"
    
    use_lockfile = false
    
  }
}