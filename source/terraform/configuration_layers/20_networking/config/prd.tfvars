# Global variables (aws_region, environment, project_name, account_id) are provided via environments/prd.tfvars

# Layer-specific variables for 20_networking in prd environment
vpc_cidr = "10.2.0.0/16"
layer    = "20_networking"
