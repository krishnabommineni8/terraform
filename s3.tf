# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-srikanth-bucket-11032024" # Replace with your desired bucket name
  acl    = "private"                     # Set the bucket access control list (ACL)

  tags = {
    Name = "My S3 Bucket"
  }
}