resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-${var.server_name}"

  tags = {
    Name        = "Terraform State"
  }
}