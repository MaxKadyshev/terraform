provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "p4_1" {
  bucket = "project4ghym"
}

resource "aws_s3_bucket_public_access_block" "p4_2" {
  bucket = aws_s3_bucket.p4_1.id
}

resource "aws_s3_bucket_acl" "p4_3" {
  bucket     = aws_s3_bucket.p4_1.id
  acl        = "public-read-write"
  depends_on = [
    aws_s3_bucket_public_access_block.p4_2,
    aws_s3_bucket_ownership_controls.p4_7
  ]
}

resource "aws_s3_bucket_versioning" "p4_4" {
  bucket   = aws_s3_bucket.p4_1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "p4_5" {
  bucket              = aws_s3_bucket.p4_1.id
  policy              = templatefile(
    "bucket_policy.json.tpl",
    {
      project4_ip     = data.http.p4_6.body,
      project4_bucket = aws_s3_bucket.p4_1.bucket
    }
  )
}

data "http" "p4_6" {
  url = "https://ifconfig.me/ip"
}

resource "aws_s3_bucket_ownership_controls" "p4_7" {
  bucket             = aws_s3_bucket.p4_1.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_access_point" "p4_8" {
  bucket                    = aws_s3_bucket.p4_1.bucket
  name                      = "project4"
  public_access_block_configuration {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

resource "aws_s3control_access_point_policy" "p4_9" {
  access_point_arn     = aws_s3_access_point.p4_8.arn
  policy               = templatefile(
    "access_point_policy.json.tpl",
    {
      project4_ip      = data.http.p4_6.body,
      project4_region  = aws_s3_bucket.p4_1.region,
      project4_account = aws_s3_access_point.p4_8.account_id,
      project4_name    = aws_s3_access_point.p4_8.name
    }
  )
}

# terraform apply -auto-approve
