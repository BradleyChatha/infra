#### Personal Website ####

data "aws_route53_zone" "chatha_dev" {
  name = "chatha.dev."
}

resource "aws_route53_record" "bradley_chatha_dev_cname" {
  zone_id = data.aws_route53_zone.chatha_dev.zone_id
  name    = "bradley.chatha.dev"
  type    = "CNAME"
  ttl     = 3600 # 1 hour - will increase to 1 day once I'm happy with the setup
  records = [aws_cloudfront_distribution.bradley_chatha_dev.domain_name]
}

resource "aws_route53_record" "bradley_chatha_dev_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.bradley_chatha_dev.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 3600
  type    = each.value.type
  zone_id = data.aws_route53_zone.chatha_dev.zone_id
}