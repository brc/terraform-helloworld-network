# Set environment-related variables.
#
# These are automatically pulled in by the root terragrunt.hcl configuration and
# are available to child configurations.
#
locals {
  environment = "prod"
}
