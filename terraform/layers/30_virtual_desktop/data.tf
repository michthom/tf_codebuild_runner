# Data sources to discover resources from previous layers
# Use tag filters to locate VPC, subnets, security groups, databases, etc.

# Example: Discover VPC from networking layer
# data "aws_vpc" "main" {
#   filter {
#     name   = "tag:Layer"
#     values = ["20_networking"]
#   }
#
#   filter {
#     name   = "tag:Environment"
#     values = [var.environment]
#   }
# }

# Example: Discover security groups from networking layer
# data "aws_security_groups" "application" {
#   filter {
#     name   = "tag:Layer"
#     values = ["20_networking"]
#   }
#
#   filter {
#     name   = "tag:Environment"
#     values = [var.environment]
#   }
#
#   filter {
#     name   = "tag:Name"
#     values = ["*app*"]
#   }
# }
