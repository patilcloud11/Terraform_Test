terraform {
  backend "s3" {
    bucket = "tfstate-vishesh-day6"
    key = "terraform.tfstate"
    region = "us-east-1"
    
    dynamodb_table = "dbtable"
    use_lockfile = true
  }
}