resource "aws_s3_bucket" "terraform_state" {
  bucket = var.release_bucket_name

  tags = {
    Name        = "Terraform State"
  }
}