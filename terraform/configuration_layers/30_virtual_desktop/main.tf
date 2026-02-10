# 30_virtual_desktop layer - Virtual desktop infrastructure
# Depends on: 00_prerequisites, 10_data_storage, 20_networking (discovered via tags)
# Resources: AppStream, WorkSpaces, related security groups, IAM roles, etc.

# Dummy resource for illustration
resource "aws_ssm_parameter" "dummy_entry" {
  name  = "/${var.environment}/resource/${var.layer}/dummy_entry"
  type  = "String"
  value = "This is a dummy entry for the ${var.layer} layer in ${var.environment} environment"
  tags = merge(
    local.common_tags,
    {
      Purpose = "Illustration",
    }
  )
}

# FIXME - these cause a failure if not present - which is
# too brutal if simply planning the deployment before anything is applied

# Ensure 10_data_storage and 20_networking were applied
data "aws_ssm_parameter" "prereq_10_data_storage" {
  name = "/${var.environment}/module/10_data_storage/applied"
}

data "aws_ssm_parameter" "prereq_20_networking" {
  name = "/${var.environment}/module/20_networking/applied"
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
      Purpose         = "ModuleApplied",
      Prereq10Applied = data.aws_ssm_parameter.prereq_10_data_storage.value,
      Prereq20Applied = data.aws_ssm_parameter.prereq_20_networking.value
    }
  )
}

# Advertise dependency on provider 10_data_storage
resource "aws_ssm_parameter" "dependency_on_10_data_storage" {
  name  = "/${var.environment}/dependency/10_data_storage/requiredby/${var.layer}"
  type  = "String"
  value = timestamp()

  tags = merge(
    local.common_tags,
    {
      Purpose   = "DependencyAdvertise",
      Provider  = "10_data_storage",
      Dependent = var.layer
    }
  )
}

# Advertise dependency on provider 20_networking
resource "aws_ssm_parameter" "dependency_on_20_networking" {
  name  = "/${var.environment}/dependency/20_networking/requiredby/${var.layer}"
  type  = "String"
  value = timestamp()

  tags = merge(
    local.common_tags,
    {
      Purpose   = "DependencyAdvertise",
      Provider  = "20_networking",
      Dependent = var.layer
    }
  )
}

# Prevent destroying this provider if any dependent layers advertise a dependency
data "aws_ssm_parameters_by_path" "dependents" {
  path      = "/${var.environment}/dependency/${var.layer}/requiredby"
  recursive = false
}

locals {
  dependents = try(data.aws_ssm_parameters_by_path.dependents.names, [])
}

# Add your virtual desktop resources here
