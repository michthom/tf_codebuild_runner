# Outputs from data storage layer are discovered by downstream layers via tags
# Tag your data storage resources appropriately for discovery by networking and virtual desktop layers
output "local_dependents" {
  value = local.dependents
}
