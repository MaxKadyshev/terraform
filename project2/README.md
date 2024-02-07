# Deploy AWS EC2 Instance hosted Linux and Windows AMI
## Goal
launch Linux and Windows based EC2 Instances in us-east-1 region
## Pre-Requisites
You must be having an AWS account to create infrastructure resources on AWS cloud
## Deployment
1. Create AWS EC2 Keypair in .pem format
1. Create Linux EC2 Instance with below configuration
   - Root volume of 10GB
   - Instance Type: t2.nano
   - Amazon Linux 2 AMI
   - Attach Key Pair created in step 1
   - Create and Attach Elastic IP
1. Create Windows EC2 Instance with below configuration
   - Root volume of 30 GB
   - Instance Type: t2.nano
   - Windows Server 2019 base
   - Attach Key Pair created in step 1
   - Create and Attach Elastic IP
1. Calculate estimated billing for both instances created in previous steps
## Validation
**NOTE:** You may need to convert the keys from .pem to .ppk if you are using putty to connect to the Linux EC2
1. Login to Linux EC2 Instance
1. Login to Windows EC2 Instance
