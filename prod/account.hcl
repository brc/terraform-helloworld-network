# Set account-related variables.
#
# These are automatically pulled in by the root terragrunt.hcl configuration and
# are available to child configurations.
#
locals {
  google_account_name = "prod"
  google_project_id   = "id-me-helloworld"
}
