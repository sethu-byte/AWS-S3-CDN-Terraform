variable "aws_s3_bucket" {
  description = "Jabri-Gatsby-website UAT"
  type        = string
}


variable "cloudfront_name" {
  type = list(string)
}

variable "commentofcloudfront" {
  type = string
}

variable "tag_of_cloudfront" {
  type = string
}

variable "s3_origin_acessname" {
  type = string
}