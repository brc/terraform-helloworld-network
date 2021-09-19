# -----------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
#
# Terragrunt is a thin wrapper for Terraform that provides extra tools for
# working with multiple Terraform modules, remote state, and locking.
#
# See https://github.com/gruntwork-io/terragrunt
# -----------------------------------------------------------------------------

# These will be available to all downstream child configurations.
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  gcp_account = local.account_vars.locals.google_account_name
  gcp_project = local.account_vars.locals.google_project_id
  gcp_region  = local.region_vars.locals.google_region
}


# Generate terraform block
# FIXME move this to env dirs so qa can use different versions than prod
generate "terraform" {
  path      = "gen-terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "= 1.0.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 3.84.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 3.84.0"
    }
  }
}
EOF
}

# Generate provider blocks
generate "provider" {
  path      = "gen-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.gcp_project}"
  region  = "${local.gcp_region}"
}

provider "google-beta" {
  project = "${local.gcp_project}"
  region  = "${local.gcp_region}"
}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
