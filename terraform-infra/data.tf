# This file defines the data sources for the Terraform configuration. It retrieves the most recent Amazon Linux 2023 AMI (Amazon Machine Image) that is owned by Amazon and has the specified name and virtualization type. This AMI will be used to launch EC2 instances in the infrastructure.
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"] 

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
