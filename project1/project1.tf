provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "p1_sg_1" {
  name = "terraform_project1_sg_1"
}

resource "aws_vpc_security_group_ingress_rule" "p1_sg_2" {
  security_group_id = aws_security_group.p1_sg_1.id
  ip_protocol       = "tcp"
  description       = "HTTP from public"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p1_sg_6" {
  security_group_id = aws_security_group.p1_sg_1.id
  ip_protocol       = "tcp"
  description       = "SSH from my pc"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p1_sg_7" {
  security_group_id = aws_security_group.p1_sg_1.id
  ip_protocol       = "tcp"
  description       = "Responds from my pc"
  from_port         = 32768
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "p1_sg_8" {
  security_group_id = aws_security_group.p1_sg_1.id
  ip_protocol       = "tcp"
  description       = "Requests from my pc"
  from_port         = 0
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "p1_ec2_0" {
  ami                    = "ami-061ea90489f8844ca"
  instance_type          = "t2.nano"
  vpc_security_group_ids = [aws_security_group.p1_sg_1.id]
  key_name               = aws_key_pair.p1_kp_4.key_name

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update httpd git
  sudo yum install -y httpd git
  sudo systemctl start httpd
  sudo systemctl enable httpd
  git clone https://bitbucket.org/dptrealtime/html-web-app.git
  cp -r ./html-web-app/* /var/www/html/
  EOF
}

resource "aws_eip" "p1_eip_3" {
  instance = aws_instance.p1_ec2_0.id
  domain   = "vpc"
}

resource "aws_key_pair" "p1_kp_4" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsXk9JAI8OX1M4kTyKtG8oCtUY8Up8dFfIGWLWVsZK7 maxkadyshev@gmail.com"
}

resource "aws_route53_record" "p1_r53r_5" {
  zone_id = "Z07770913SB0YCPM8QVN6"
  name    = "project1.ghym.ae"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.p1_eip_3.public_ip]
}

# terraform apply -auto-approve
