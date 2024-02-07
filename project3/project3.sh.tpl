#!/bin/bash
set -e
sudo mkfs -t xfs /dev/xvdb
sudo mount /dev/xvdb /var/www/html
echo /dev/xvdb /var/www/html xfs defaults,nofail 0 2 | sudo tee -a /etc/fstab
sudo git clone https://bitbucket.org/dptrealtime/html-web-app/src/master/ /var/www/html/
echo ${ssm_cloudwatch_config} > /var/www/html/project3.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/var/www/html/project3.json
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent
