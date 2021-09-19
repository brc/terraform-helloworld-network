# These are populated by root configuration.
variable "google_project_id" {}
variable "google_region" {}

module "admin_vpc" {
    source = "github.com/invsblduck/terraform-module-google-vpc//vpc?ref=v0.0.1"

    vpc_project_id  = var.google_project_id
    vpc_region      = var.google_region
    vpc_name        = "vpc-admin"
    vpc_subnet_desc = "Admin network for Ops mgmt"
    vpc_subnet_name = "admin-net01"
    vpc_subnet_cidr = "10.1.1.0/24"
}
