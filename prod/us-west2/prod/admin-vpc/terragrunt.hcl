# Terragrunt will copy the source module specified below into a temporary
# directory, along with any files in the current working directory, and
# and execute your Terraform commands in that folder.

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
