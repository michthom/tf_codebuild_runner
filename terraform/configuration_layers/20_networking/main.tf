# 20_networking layer - Network infrastructure
# Depends on: 00_prerequisites, 10_data_storage (discovered via tags)
# Resources: VPC, Subnets, Security Groups, NACLs, Route tables, etc.

// Ensure 00_prerequisites was applied
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

# Add your networking resources here

# Prevent destroying this provider if any dependent layers advertise a dependency
data "aws_ssm_parameters_by_path" "dependents" {
  path      = "/${var.environment}/dependency/${var.layer}/requiredby"
  recursive = false
}

locals {
  dependents = try(data.aws_ssm_parameters_by_path.dependents.names, [])
}
