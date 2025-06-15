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

variable "environment" {
  description = "Environment to deploy the Streamlit app"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "nonprod", "prod"], var.environment)
    error_message = "Environment must be one of 'dev', 'nonprod', or 'prod'."
  }
}

variable "required_tags" {
  description = "Tags that must be applied to all resources"
  type = object({
    # The following is here for convenience; tags should be merged with the local calculated tags to obtain actual values
    ManagedBy   = optional(string, null)
    Owner       = optional(string, null)
    App         = optional(string, null)
    Version     = optional(string, null)
    Environment = optional(string, null)
  })

  default = {}

  validation {
    condition     = alltrue([for key in keys(var.required_tags) : var.required_tags[key] == null])
    error_message = "All required_tags values must remain null; they are placeholders for reference and will be populated using locals."
  }
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(any)
  default     = {}
}
