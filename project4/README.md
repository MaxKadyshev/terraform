# Deploy S3 Bucket policy
## Goal
Goal of this project to create public S3 Bucket in AWS cloud and update Bucket policy to allow access to the bucket only from whitelisted public IPs.
## Pre-Requisites
1. AWS IAM user access key & secret key accessing S3.
1. Visual Studio Code configured to develop Terraform IaC
## IaC Deployment
1. Create S3 Bucket in ‘us-east-1’ region 
1. Enable Bucket versioning
1. Update Bucket ACL to public access.
1. Create IAM policy to allow Bucket objects only from the specific whitelisted public IP (Get the public IP of your system to whitelist the IP)
1. Update Bucket Policy with the IAM policy that created in step 3.
## Validation
1. Upload Object to Bucket using AWS CLI
1. Access the Objects using Object URL from public browser(While your system has same public IP whitelisted)
1. Access the Objects using Object URL from public browser (While your system has different public IP, Reconnect to internet might change your public IP for testing.)
