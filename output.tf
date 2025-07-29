output "cdnarn" {
  value = aws_cloudfront_distribution.cloudfrontS3distribution.arn

}
output "cdndname" {
  value = aws_cloudfront_distribution.cloudfrontS3distribution.domain_name
}

output "cloudfront_aliases" {
  value = aws_cloudfront_distribution.cloudfrontS3distribution.aliases
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.uatwebsitejabrico.bucket_domain_name
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.cloudfrontS3distribution.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.cloudfrontS3distribution.id
}