provider "aws" {
  region = "ap-southeast-2"
}

#Creation of S3 Bucket
resource "aws_s3_bucket" "uatwebsitejabrico" {
  bucket = var.aws_s3_bucket
}




#Policy for s3 to allow cloudfront OAC to get objects
resource "aws_s3_bucket_policy" "s3bucketpolicy1" {
  bucket = aws_s3_bucket.uatwebsitejabrico.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.uatwebsitejabrico.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "${aws_cloudfront_distribution.cloudfrontS3distribution.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "blockPublicAccess" {
  bucket                  = aws_s3_bucket.uatwebsitejabrico.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  s3_origin_id = "S3-Origin"
}
resource "aws_cloudfront_origin_access_control" "acces" {
  name                              = var.s3_origin_acessname
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



#creation of cloudfront for uatwebsitejabri
resource "aws_cloudfront_distribution" "cloudfrontS3distribution" {
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = false
  comment             = var.commentofcloudfront

  origin {
    domain_name              = aws_s3_bucket.uatwebsitejabrico.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.acces.id
  }


  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"


    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::104218330943:function/RewriteIndexHtml"

    }

  }



  # Required restrictions block - this fixes the red error
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:104218330943:certificate/c29ee9cc-a843-45e9-a649-8df3785568db"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = var.tag_of_cloudfront
  }
  aliases = var.cloudfront_name

  # Conditional error page handling - only for "front" workspace
  dynamic "custom_error_response" {
    for_each = terraform.workspace == "front" ? [1] : []
    content {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }
  }

}


