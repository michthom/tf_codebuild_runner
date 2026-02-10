# Global variables (aws_region, environment, project_name, account_id) are provided via environments/dev.tfvars

# Layer-specific variables for 20_networking in dev environment
vpc_cidr = "10.0.0.0/16"
layer    = "20_networking"
