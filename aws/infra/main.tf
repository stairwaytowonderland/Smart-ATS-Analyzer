locals {
  tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      App         = var.app_name
      Version     = var.app_version
    },
  )
}

module "serverless-streamlit-app" {
  source          = "aws-ia/serverless-streamlit-app/aws"
  app_name        = var.app_name
  aws_region      = var.aws_region
  app_version     = var.app_version
  path_to_app_dir = "../../src"
  tags            = local.tags
}
