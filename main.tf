terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }

    cloudvps = {
      source  = "terraform.wmcloud.org/registry/cloudvps"
      version = "~> 0.3"
    }
  }

  backend "s3" {
    key    = "workload/application.tfstate"
    region = "us-east-1"
  }

  required_version = "~> 1.9.0"
}

provider "openstack" {
  tenant_name = var.project
}

provider "cloudvps" {
  os_project_id = var.project
}
