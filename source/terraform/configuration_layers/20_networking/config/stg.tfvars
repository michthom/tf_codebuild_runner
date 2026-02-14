# Global variables (aws_region, environment, project_name, account_id) are provided via environments/stg.tfvars

# Layer-specific variables for 20_networking in stg environment
vpc_cidr = "10.1.0.0/16"
layer    = "20_networking"
