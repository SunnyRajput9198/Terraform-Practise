#  Output format for count loop
# output "ec2_arn" {
#     description = "ARN of the EC2 instance"
#     value       = aws_instance.my_instance[*].arn
# }

# output "ec2_public_ip" {
#     description = "Public IP address of the EC2 instance"
#     value       = aws_instance.my_instance[*].public_ip
# }

# output "s3_bucket_name" {
#     description = "Name of the S3 bucket"
#     value       = aws_s3_bucket.my_bucket.bucket
# }

# output format for for_each loop
output "ec2_public_ip" {
    value = [
        for instance in aws_instance.my_instance : instance.public_ip
    ]
}

# output "dynamodb_table_name" {
#     description = "Name of the DynamoDB table"
#     value       = aws_dynamodb_table.my_app_table.name
# }