# Create Origin Access Control for CloudFront
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "cloudfront_s3_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Define CloudFront cache policy
data "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
  name = "Managed-CachingOptimized"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.cloud-resume-challenge.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    origin_id                = aws_route53_zone.root.name
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["www.${aws_route53_zone.root.name}", "${aws_route53_zone.root.name}"]

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.cloudfront_cache_policy.id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_route53_zone.root.name

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
