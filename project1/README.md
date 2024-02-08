# Setup Apache Webserver on AWS EC2 Instance
## Goal
Deploy Apache Webserver on Linux Instance and host a simple HTML based web application
## Pre-Requisites
1. You must be having an AWS account to create infrastructure resources on AWS cloud
1. [Source Code](https://bitbucket.org/dptrealtime/html-web-app/src/master/)
## Pre-Deployment
Customize the application dependencies mentioned below on AWS EC2 instance
1. Install Apache Web Server
1. Install Git
1. Configure Apache to start automatically after the instance reboot
## Deployment
### Infrastructure Setup
1. Create Security Group allowing port 22 from custom IP source ( Your workstation IP ) and port 80 from public
1. Create Key-Pair and download the private key
1. Create t2.nano type EC2 instance using Amazon Linux2 AMI
1. Create Elastic IP and associate the IP to EC2 instance
1. Create Route53 hosted zone with your domain name and configure A record pointing to the EC2 EIP
### Application Setup
1. Use Git commands and clone the source code from Bit Bucket repository provided in the pre-requisites
1. Deploy the source code into web server document root folder – /var/www/html 
## Validation
Verify if you are able to access the web application from internet browser
## Destroy
Destroy the resources once the testing is over to save the billing
