variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "server_name" {
  description = "Server Name"
  type        = string
}

variable "image_tag" {
  description = "Image Tag"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = number
}
