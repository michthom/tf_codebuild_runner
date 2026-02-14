# Outputs from prerequisites layer are discovered by downstream layers via tags
# Ensure all resources in this layer are properly tagged with Layer = "00_prerequisites"
output "local_dependents" {
  value = local.dependents
}
