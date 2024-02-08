# Deploy HTML based static web application on AWS EC2
## Goal
Deploy HTML based static website on Amazon EC2 instance and configure logging, monitoring, alerts.  This project hosting static web application on Apache Web Server to serve the web pages to internet clients. 
## Pre-Requisites
1. You must be having an AWS account to create infrastructure resources on AWS cloud
1. [Source Code](https://bitbucket.org/dptrealtime/html-web-app/src/master/)
## Pre-Deployment
Customize the application dependencies mentioned below on AWS EC2 instance and create the Golden AMI
1. AWS CLI
1. Install Apache Web Server
1. Install Git
1. Configure Apache to start automatically after the instance reboot
## Deployment
### Infrastructure Setup
1. Create Security Group allowing port 22 from custom IP source ( Your workstation IP ) and port 80 from public
1. Create Key-Pair and download the private key
1. Create t2.nano type EC2 instance using Golden AMI
1. Create Elastic IP and associate the IP to EC2 instance
1. Create GP2 type EBS volume named /dev/xvdb of size 5GB in same AZ where EC2 was created
1. Attach EBS volume to EC2 instance
1. Create Route53 hosted zone with your domain name and configure A record pointing to the EC2 EIP
1. Create private S3 bucket and enable versioning
### Application Setup
1. Create File System on xvdb volume and mount it on /var/www/html directory
1. Use Git commands and clone the source code from Bit Bucket repository provided in the pre-requisites
1. Deploy the source code into web server document root folder – /var/www/html
## Post-Deployment
1. Configure Cloudwatch agent to monitor Memory utilization of EC2 instance
1. Create Cloudwatch Dashboard to monitor CPU & Memory metrics of the EC2 instance
1. Configure SNS topic and subscribe e-mail to the Topic
1. Configure Cloudwatch alarm with 1 data point and 5 minutes interval rate to notify to SNS topic when average CPU utilization is greater than 80% threshold
1. Configure Cloudwatch alarm with 1 data point and 5 minutes interval rate to notify to SNS topic when average Memory utilization is greater than 60% threshold
1. Use AWS CLI commands to push webserver logs to S3 bucket
1. Configure S3 life cycle rules to transit previous version objects to Glacier after 30 days and delete the objects after 90 days of object creation date
## Validation
Verify if you are able to access the web application from internet browser
## Destroy
Destroy the resources once the testing is over to save the billing
