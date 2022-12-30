locals {
  blue_resource_prefix  = "${var.resource_prefix}-appserver-b"
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
  source = "github.com/enwikipedia-acc/terraform-openstack-waca-application"
  # version = "0.0.0"
  count = module.bluegreen.blue_count

  dns_name        = module.bluegreen.blue_dns_name
  resource_prefix = local.blue_resource_prefix
  environment     = "blue"
  instance_type   = data.openstack_compute_flavor_v2.small.id
  network         = data.openstack_networking_network_v2.network.id
  dns_zone_id     = data.openstack_dns_zone_v2.rootzone.id
  image_name      = "debian-11.0-bullseye"

  security_groups = [
    data.openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
  ]
}

module "application-green" {
  source = "github.com/enwikipedia-acc/terraform-openstack-waca-application"
  # version = "0.0.0"
  count = module.bluegreen.green_count

  dns_name        = module.bluegreen.green_dns_name
  resource_prefix = local.green_resource_prefix
  environment     = "green"
  instance_type   = data.openstack_compute_flavor_v2.small.id
  network         = data.openstack_networking_network_v2.network.id
  dns_zone_id     = data.openstack_dns_zone_v2.rootzone.id
  image_name      = "debian-11.0-bullseye"

  security_groups = [
    data.openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
  ]
}
