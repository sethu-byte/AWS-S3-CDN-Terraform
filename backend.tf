terraform {
  backend "s3" {
    bucket = "YourS3-Bucket"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
