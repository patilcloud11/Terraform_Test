module "aws_instance" {
  source = "../day_8_module"
  ami_id = "ami-07ff62358b87c7118"
  type = "t3.micro"

}

module "aws_s3_bucket" {
  source = "../day_8_module"
    bucketname = "vishesh-patil-bucket-1302"
}