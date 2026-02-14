# Data sources to discover resources from 00_prerequisites layer
# These filters use tags to locate resources without remote state references

# Example: Discover KMS key from prerequisites layer
# data "aws_kms_key" "terraform_state" {
#   key_id = "alias/${var.project_name}-tf-state"
# }
