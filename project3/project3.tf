provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "p3_sg_1" {
  name = "terraform_project3_sg_1"
}

resource "aws_vpc_security_group_ingress_rule" "p3_sg_2" {
  security_group_id = aws_security_group.p3_sg_1.id
  ip_protocol       = "tcp"
  description       = "HTTP from public"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p3_sg_3" {
  security_group_id = aws_security_group.p3_sg_1.id
  ip_protocol       = "tcp"
  description       = "SSH from public"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p3_sg_4" {
  security_group_id = aws_security_group.p3_sg_1.id
  ip_protocol       = "tcp"
  description       = "Responds from my pc"
  from_port         = 32768
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "p3_sg_5" {
  security_group_id = aws_security_group.p3_sg_1.id
  ip_protocol       = "tcp"
  description       = "Requests from my pc"
  from_port         = 0
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_key_pair" "p3_kp_6" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsXk9JAI8OX1M4kTyKtG8oCtUY8Up8dFfIGWLWVsZK7 maxkadyshev@gmail.com"
}

resource "aws_instance" "p3_ec2_7" {
  ami                    = "ami-0cf10cdf9fcd62d37"
  instance_type          = "t2.nano"
  availability_zone      = "us-east-1a"
  tags                   = {
    Name                 = "Project3"
  }
  user_data              = file("project3.sh")
  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "aws_s3_bucket" "p3_s3b_12" {
  bucket = "project3ghym"
}

resource "aws_s3_bucket_acl" "p3_s3ba_13" {
  bucket     = aws_s3_bucket.p3_s3b_12.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.p3_s3boc_15]
}

resource "aws_s3_bucket_versioning" "p3_s3bv_14" {
  bucket   = aws_s3_bucket.p3_s3b_12.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "p3_s3boc_15" {
  bucket             = aws_s3_bucket.p3_s3b_12.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_ami_from_instance" "p3_amifi_16" {
  name               = "ami-project3"
  source_instance_id = aws_instance.p3_ec2_7.id
}

data "aws_ami" "p3_ami_17" {
  depends_on = [aws_ami_from_instance.p3_amifi_16]
  owners     = ["self"]
  filter {
    name     = "name"
    values   = ["ami-project3"]
  }
}

resource "aws_instance" "p3_ec2_18" {
  ami                       = data.aws_ami.p3_ami_17.id
  instance_type             = "t2.nano"
  availability_zone         = "us-east-1a"
  vpc_security_group_ids    = [aws_security_group.p3_sg_1.id]
  key_name                  = aws_key_pair.p3_kp_6.key_name
  tags                      = {
    Name                    = "Project3"
  }
  user_data                 = templatefile(
    "project3.sh.tpl",
    {
      ssm_cloudwatch_config = aws_ssm_parameter.p3_ssmp_21.value
    }
  )
  iam_instance_profile      = aws_iam_instance_profile.p3_iamip_28.name
  lifecycle {
    create_before_destroy   = true
    ignore_changes          = [user_data]
  }
}

resource "aws_eip" "p3_eip_8" {
  instance = aws_instance.p3_ec2_18.id
  domain   = "vpc"
}

resource "aws_ebs_volume" "p3_ebs_9" {
  availability_zone = "us-east-1a"
  size              = 5
}

resource "aws_volume_attachment" "p3_va_10" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.p3_ebs_9.id
  instance_id = aws_instance.p3_ec2_18.id
}

resource "aws_route53_record" "p3_r53r_11" {
  zone_id = "Z07770913SB0YCPM8QVN6"
  name    = "project3.ghym.ae"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.p3_eip_8.public_ip]
}

resource "aws_iam_role" "p3_iamr_19" {
  name               = "project3CloudWatchAgentServerRole"
  assume_role_policy = jsonencode({
    Version          = "2012-10-17"
    Statement        = [
      {
        Action       = "sts:AssumeRole"
        Effect       = "Allow"
        Principal    = {
          Service    = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags               = {
    tag-key          = "Project3"
  }
}

resource "aws_iam_role_policy" "p3_iamrp_20" {
  name           = "project3CloudWatchAgentServerRolePolicy"
  role           = aws_iam_role.p3_iamr_19.id
  policy         = jsonencode({
    Version      = "2012-10-17"
    Statement    = [
      {
        Action   = [
          "iam:PassRole",
          "ec2:CloudWatchAgentServerPolicy",
          "ec2:AssociateIamInstanceProfile",
          "ec2:ReplaceIamInstanceProfileAssociation",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_ssm_parameter" "p3_ssmp_21" {
  description = "amazon-cloudwatch-agent.json"
  name        = "project3"
  type        = "String"
  value       = file("project3.json")
}

resource "aws_cloudwatch_dashboard" "p3_cwd_22" {
  dashboard_name   = "project3"
  dashboard_body   = jsonencode({
    widgets        = [
      {
        type       = "metric"
        x          = 0
        y          = 0
        width      = 12
        height     = 6
        properties = {
          metrics  = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.p3_ec2_18.id ]
          ]
          period   = 10
          stat     = "Average"
          region   = "us-east-1"
          title    = "EC2 Instance CPU"
        }
      },
      {
        type       = "metric"
        x          = 0
        y          = 6
        width      = 12
        height     = 6
        properties = {
          metrics  = [
            ["AWS/EC2", "MemoryUtilization", "InstanceId", aws_instance.p3_ec2_18.id]
          ]
          period   = 10
          stat     = "Average"
          region   = "us-east-1"
          title    = "EC2 Instance RAM"
        }
      }
    ]
  })
}

resource "aws_sns_topic" "p3_snst_23" {
  name = "project3"
}

resource "aws_sns_topic_subscription" "p3_snsts_24" {
  topic_arn = aws_sns_topic.p3_snst_23.arn
  protocol  = "email"
  endpoint  = "maxkadyshev@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "p3_cwma_25" {
  alarm_name          = "project3CPU80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "cpu_usage_percent"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.p3_snst_23.arn]
  ok_actions          = [aws_sns_topic.p3_snst_23.arn]
}

resource "aws_cloudwatch_metric_alarm" "p3_cwma_26" {
  alarm_name          = "project3RAM60"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "mem_used_percent"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "This metric monitors ec2 memory utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.p3_snst_23.arn]
  ok_actions          = [aws_sns_topic.p3_snst_23.arn]
}

resource "aws_s3_bucket_lifecycle_configuration" "p3_s3blc_27" {
  bucket            = aws_s3_bucket.p3_s3b_12.id
  rule {
    id              = "project3"
    filter {
      prefix        = "/var/log/httpd/"
    }
    transition {
      days          = 30
      storage_class = "GLACIER"
    }
    expiration {
      days          = 90
    }
    status          = "Enabled"
  }
}

resource "aws_iam_instance_profile" "p3_iamip_28" {
  name = "project3"
  role = aws_iam_role.p3_iamr_19.name
}

# terraform apply -auto-approve
