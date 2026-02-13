# This block creates a DynamoDB table for Terraform state locking in a remote backend
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST" # this is used to specify the billing mode for the DynamoDB table, PAY_PER_REQUEST means that you only pay for the read and write requests that you make to the table, it is a cost-effective option for tables with unpredictable or low traffic patterns
  hash_key     = "LockID" # this is used to specify the primary key for the DynamoDB table, it is used to uniquely identify each lock entry in the table, it is required for state locking to work properly

  attribute { # this block defines the attributes for the DynamoDB table, in this case, it defines a single attribute named "LockID" of type string (S) which is used as the primary key for the table
    name = "LockID"
    type = "S"
  }
}
