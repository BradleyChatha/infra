#### Personal Website ####

resource "aws_acm_certificate" "bradley_chatha_dev" {
  domain_name       = "bradley.chatha.dev"
  provider          = aws.us_east_1
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "bradley_chatha_dev" {
  certificate_arn         = aws_acm_certificate.bradley_chatha_dev.arn
  provider                = aws.us_east_1
  validation_record_fqdns = [for record in aws_route53_record.bradley_chatha_dev_acm_validation : record.fqdn]
}