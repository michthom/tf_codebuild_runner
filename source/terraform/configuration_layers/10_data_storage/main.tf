# 10_data_storage layer - Data storage resources
# Depends on: 00_prerequisites (discovered via tags)
# Resources: RDS, DynamoDB, S3, ElastiCache, etc.


# FIXME - this causes a failure if not present - which is
# too brutal if simply planning the deployment before anything is applied

# Ensure 00_prerequisites was applied
data "aws_ssm_parameter" "prereq_00_prerequisites" {
  name = "/${var.environment}/module/00_prerequisites/applied"
}

# Dummy resource for illustration
resource "aws_ssm_parameter" "dummy_entry" {
  name  = "/${var.environment}/resource/${var.layer}/dummy_entry"
  type  = "String"
  value = "This is a dummy entry for the ${var.layer} layer in ${var.environment} environment"

  tags = merge(
    local.common_tags,
    {
      Purpose       = "Illustration",
      PrereqApplied = data.aws_ssm_parameter.prereq_00_prerequisites.value
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

# Advertise dependency on provider 00_prerequisites to prevent accidental destroy
resource "aws_ssm_parameter" "dependency_on_00_prerequisites" {
  name  = "/${var.environment}/dependency/00_prerequisites/requiredby/${var.layer}"
  type  = "String"
  value = timestamp()

  tags = merge(
    local.common_tags,
    {
      Purpose   = "DependencyAdvertise",
      Provider  = "00_prerequisites",
      Dependent = var.layer
    }
  )
}

# Example: RDS database instance
# resource "aws_db_instance" "main" {
#   identifier     = "${var.project_name}-${var.environment}-db"
#   engine         = "postgres"
#   engine_version = "15.3"
#   instance_class = var.db_instance_class
#
#   allocated_storage     = var.db_allocated_storage
#   storage_encrypted     = true
#   kms_key_id           = data.aws_kms_key.terraform_state.arn
#
#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project_name}-${var.environment}-db"
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
