variable "root_domain_name" {
  type    = string
  default = "galzmarc.com"
}

resource "aws_route53_zone" "root" {
  name = var.root_domain_name
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = var.root_domain_name
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"
  subject_alternative_names = [
    "*.${var.root_domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validate_records" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.root.zone_id
  ttl             = "60"
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_validate" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validate_records : record.fqdn]

  timeouts {
    create = "5m"
  }
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.root.zone_id
  name            = aws_route53_zone.root.name
  type            = "NS"
  ttl             = 172800

  records = [
    aws_route53_zone.root.name_servers[0],
    aws_route53_zone.root.name_servers[1],
    aws_route53_zone.root.name_servers[2],
    aws_route53_zone.root.name_servers[3],
  ]
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.root.zone_id
  name    = aws_route53_zone.root.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.root.zone_id
  name    = "www.${aws_route53_zone.root.name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}