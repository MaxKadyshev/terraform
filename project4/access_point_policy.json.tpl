{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:${project4_region}:${project4_account}:accesspoint/${project4_name}",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "${project4_ip}"
        }
      }
    }
  ]
}
