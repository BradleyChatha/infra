#### Personal Website ####
#
# This S3 bucket is fronted by CloudFront as a very cheap way to serve a static website.
# 
####

resource "aws_s3_bucket" "bradley_chatha_dev" {
  bucket        = "bradley-chatha-dev-website"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bradley_chatha_dev" {
  bucket = aws_s3_bucket.bradley_chatha_dev.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "bradley_chatha_dev" {
  bucket = aws_s3_bucket.bradley_chatha_dev.bucket

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "bradley_chatha_dev" {
  bucket = aws_s3_bucket.bradley_chatha_dev.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"] # OPTIONS is not allowed, so I assume it's handled correctly
    allowed_origins = ["https://${aws_route53_record.bradley_chatha_dev_cname.fqdn}"]
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "bradley_chatha_dev_s3" {
  policy_id = "bradley-chatha-dev-website"
  
  statement {
    sid = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bradley_chatha_dev.arn}/*"]
    
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.bradley_chatha_dev.arn]
    }
    
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}
resource "aws_s3_bucket_policy" "bradley_chatha_dev" {
  bucket = aws_s3_bucket.bradley_chatha_dev.bucket
  policy = data.aws_iam_policy_document.bradley_chatha_dev_s3.json
}