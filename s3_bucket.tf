# Create S3 bucket
resource "aws_s3_bucket" "cloud-resume-challenge" {
  bucket = "${var.account_id}-cloud-resume-challenge"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.cloud-resume-challenge.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload files to S3 bucket
resource "aws_s3_object" "html" {
  bucket       = aws_s3_bucket.cloud-resume-challenge.id
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
  source_hash  = filemd5("./index.html")
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.cloud-resume-challenge.id
  key          = "styles.css"
  source       = "./styles.css"
  content_type = "text/css"
  source_hash  = filemd5("./styles.css")
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.cloud-resume-challenge.id
  key          = "script.js"
  source       = "./script.js"
  content_type = "application/javacsript"
  source_hash  = filemd5("./script.js")
}

resource "aws_s3_object" "img" {
  bucket       = aws_s3_bucket.cloud-resume-challenge.id
  key          = "aws_cloud_practitioner.png"
  source       = "./aws_cloud_practitioner.png"
  content_type = "image/png"
}

# Modify the bucket policy to only allow access from CloudFront
resource "aws_s3_bucket_policy" "cdn-oac-bucket-policy" {
  bucket = aws_s3_bucket.cloud-resume-challenge.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid       = "AllowCloudFrontServicePrincipalReadOnly"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cloud-resume-challenge.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}