terraform {
  backend "s3" {
    bucket = "jabri-tfstatefiles"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}