{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "Project4",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": "arn:aws:s3:::${project4_bucket}",
    "Condition": {
      "IpAddress": {
        "aws:SourceIp": "${project4_ip}"
      }
    }
 }]
}
