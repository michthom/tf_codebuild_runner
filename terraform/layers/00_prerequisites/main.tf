# 00_prerequisites layer - Lowest level resources
# These resources never change per environment and form the foundation for all other layers
# Add your prerequisites resources here (e.g., KMS keys, IAM roles, S3 buckets for shared state, etc.)

# Dummy resource for illustration
resource "aws_ssm_parameter" "dummy_entry" {
  name  = "/${var.environment}/resource/${var.layer}/dummy_entry"
  type  = "String"
  value = "This is a dummy entry for the ${var.layer} layer in ${var.environment} environment"

  tags = merge(
    local.common_tags,
    {
      Purpose = "Illustration"
    }
  )
}
#
# Signal that this module has been applied
resource "aws_ssm_parameter" "module_applied" {
  name  = "/${var.environment}/module/${var.layer}/applied"
  type  = "String"
  value = timestamp()

  tags = merge(
    local.common_tags,
    {
      Purpose = "ModuleApplied"
    }
  )
}

# Example: KMS key for encryption
# resource "aws_kms_key" "terraform_state" {
#   description             = "KMS key for Terraform state encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
#
#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project_name}-tf-state-key"
#     }
#   )
# }

# Prevent destroying this provider if any dependent layers advertise a dependency
data "aws_ssm_parameters_by_path" "dependents" {
  path      = "/${var.environment}/dependency/${var.layer}/requiredby"
  recursive = false
}

locals {
  dependents = try(data.aws_ssm_parameters_by_path.dependents.names, [])
}
