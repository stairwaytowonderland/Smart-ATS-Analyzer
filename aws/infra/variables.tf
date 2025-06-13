variable "app_version" {
  description = "Version of the Streamlit app to deploy"
  type        = string
}

variable "app_name" {
  description = "Name of the Streamlit app to deploy"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy the Streamlit app"
  type        = string
  default     = "us-east-1"
}
