provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "p2_ec2_0" {
  ami                    = "ami-0cf10cdf9fcd62d37"
  instance_type          = "t2.nano"
  key_name               = aws_key_pair.p2_kp_2.key_name
  vpc_security_group_ids = [aws_security_group.p2_sg_7.id]
  root_block_device {
    volume_size          = 10
  }
}

resource "aws_key_pair" "p2_kp_2" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsXk9JAI8OX1M4kTyKtG8oCtUY8Up8dFfIGWLWVsZK7 maxkadyshev@gmail.com"
}

resource "aws_eip" "p2_ei_3" {
  instance = aws_instance.p2_ec2_0.id
}

resource "aws_instance" "p2_ec2_5" {
  ami                    = "ami-0aca05dd8c2f99518"
  instance_type          = "t2.nano"
  key_name               = aws_key_pair.p2_kp_2.key_name
  vpc_security_group_ids = [aws_security_group.p2_sg_7.id]
  root_block_device {
    volume_size          = 30
  }
}

resource "aws_eip" "p2_ei_6" {
  instance = aws_instance.p2_ec2_5.id
}

resource "aws_security_group" "p2_sg_7" {
  name = "terraform_project2_sg_7"
}

resource "aws_vpc_security_group_ingress_rule" "p2_sg_8" {
  security_group_id = aws_security_group.p2_sg_7.id
  ip_protocol       = "tcp"
  description       = "SSH from public"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p2_sg_9" {
  security_group_id = aws_security_group.p2_sg_7.id
  ip_protocol       = "tcp"
  description       = "RDP from public"
  from_port         = 3389
  to_port           = 3389
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "p2_sg_10" {
  security_group_id = aws_security_group.p2_sg_7.id
  ip_protocol       = "tcp"
  description       = "Responds from my pc"
  from_port         = 32768
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}

data "aws_pricing_product" "p2_pc_11" {
  service_code = "AmazonEC2"
  filters {
    field = "instanceType"
    value = "t2.nano"
  }
  filters {
    field = "operatingSystem"
    value = "Linux"
  }
  filters {
    field = "location"
    value = "US East (N. Virginia)"
  }
  filters {
    field = "capacitystatus"
    value = "Used"
  }
}

data "aws_pricing_product" "p2_pc_12" {
  service_code = "AmazonEC2"
  filters {
    field = "instanceType"
    value = "t2.nano"
  }
  filters {
    field = "operatingSystem"
    value = "Windows"
  }
  filters {
    field = "location"
    value = "US East (N. Virginia)"
  }
  filters {
    field = "capacitystatus"
    value = "Used"
  }
  filters {
    field = "licenseModel"
    value = "No License required"
  }
}

output "p2_pc_13" {
  value = data.aws_pricing_product.p2_pc_11.result
}

output "p2_pc_14" {
  value = data.aws_pricing_product.p2_pc_12.result
}

# terraform apply -auto-approve
