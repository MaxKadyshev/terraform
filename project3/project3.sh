#!/bin/bash
sudo yum update xfsprogs httpd git curl amazon-cloudwatch-agent
sudo yum install -y xfsprogs httpd git curl amazon-cloudwatch-agent
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
echo "0 0 * * * aws s3 cp /var/log/httpd s3://project3ghym/ --recursive" | sudo crontab - -u ec2-user
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/log/httpd/
