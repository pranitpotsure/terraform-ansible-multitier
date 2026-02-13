# This block creates an S3 bucket for storing Terraform state files in a remote backend
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-remote-state-bucket-pranit"

  tags = {
    Name = "terraform-remote-state"
  }
}

# This block enables versioning for the S3 bucket, which allows you to keep multiple versions of the state file and recover from accidental deletions or overwrites.
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration { # this block defines the versioning configuration for the S3 bucket, in this case, it sets the versioning status to "Enabled" which means that all versions of the objects in the bucket will be retained and can be accessed or restored if needed.
    status = "Enabled"
  }
}

# This block enables server-side encryption for the S3 bucket, which ensures that the state files are encrypted at rest for security purposes.
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default { # this block defines the default server-side encryption settings for the S3 bucket, in this case, it specifies that all objects stored in the bucket will be encrypted using the AES256 encryption algorithm.
      sse_algorithm = "AES256" # this is the encryption algorithm used for server-side encryption
    }
  }
}
