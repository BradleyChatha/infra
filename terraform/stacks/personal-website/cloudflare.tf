#### Personal Website ####

resource "aws_cloudfront_distribution" "bradley_chatha_dev" {
  aliases             = ["bradley.chatha.dev"]
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"

  default_cache_behavior {
    allowed_methods        = ["HEAD", "OPTIONS", "GET"]
    cached_methods         = ["HEAD", "OPTIONS", "GET"]
    cache_policy_id        = aws_cloudfront_cache_policy.bradley_chatha_dev.id
    target_origin_id       = local.bradley_chatha_dev_s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name              = aws_s3_bucket.bradley_chatha_dev.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bradley_chatha_dev.id
    origin_id                = local.bradley_chatha_dev_s3_origin_id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.bradley_chatha_dev.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "bradley_chatha_dev" {
  name                              = "bradley-chatha-dev-website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "bradley_chatha_dev" {
  name        = "bradley-chatha-dev-website"
  default_ttl = 300

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
