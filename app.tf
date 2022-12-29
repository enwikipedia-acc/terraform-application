locals {
  blue_resource_prefix = "${var.resource_prefix}-appserver-b"
  green_resource_prefix = "${var.resource_prefix}-appserver-g"
}

module "bluegreen" {
  source  = "app.terraform.io/enwikipedia-acc/bluegreen/openstack"
  version = "0.2.0"

  blue_dns_name       = "${local.blue_resource_prefix}.${data.openstack_dns_zone_v2.rootzone.name}"
  green_dns_name      = "${local.green_resource_prefix}.${data.openstack_dns_zone_v2.rootzone.name}"
  live_environment    = var.live_instance
  staging_environment = var.staging_instance
}

module "application-blue" {
  source  = "app.terraform.io/enwikipedia-acc/waca-application/openstack"
  version = "0.0.0"
}

module "application-green" {
  source  = "app.terraform.io/enwikipedia-acc/waca-application/openstack"
  version = "0.0.0"
}