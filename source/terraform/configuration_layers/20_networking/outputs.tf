# Tag all outputs appropriately so downstream layers can discover them
output "local_dependents" {
  value = local.dependents
}
