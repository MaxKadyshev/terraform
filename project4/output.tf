output "IP_address" {
  value = data.http.p4_6.body
}

output "Validation_command" {
  value = "aws s3 cp $(mktemp) s3://${aws_s3_access_point.p4_8.arn}"
}
