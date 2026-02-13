# This file configures the backend for Terraform to use Amazon S3 for storing the state file and DynamoDB for state locking to prevent concurrent modifications to the state file. The backend configuration specifies the S3 bucket name, the key (path) for the state file, the AWS region, the DynamoDB table name for state locking, and enables encryption for the state file in S3.
terraform {
  backend "s3" {
    bucket         = "my-terraform-remote-state-bucket-pranit" # this is the name of the S3 bucket where the Terraform state file will be stored
    key            = "prod-ha/terraform.tfstate"               # this is the path within the S3 bucket where the Terraform state file will be stored, it helps to organize state files for different environments or projects
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock" # this is the name of the DynamoDB table that will be used for state locking, it helps to prevent concurrent modifications to the state file by multiple users or processes
    encrypt        = true                   # this is used to enable encryption for the state file stored in S3, it ensures that the state file is encrypted at rest for security purposes
  }
}
