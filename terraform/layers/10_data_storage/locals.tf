locals {
  # Merge environment-specific tags with layer-specific tags
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
