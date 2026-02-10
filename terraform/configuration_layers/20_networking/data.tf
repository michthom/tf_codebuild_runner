# Data sources to discover resources from prerequisites and data storage layers
# These filters use tags to locate resources without remote state references

# Example: Discover data storage resources
# data "aws_db_instance" "main" {
#   db_instance_identifier = "${var.project_name}-${var.environment}-db"
#
#   filter {
#     name   = "tag:Layer"
#     values = ["10_data_storage"]
#   }
# }
