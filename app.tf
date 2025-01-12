module "application-blue" {
  source = "github.com/enwikipedia-acc/terraform-openstack-waca-application?ref=0.1.0"

  count = 1

  dns_name        = "${var.resource_prefix}-appserver-b.${data.openstack_dns_zone_v2.rootzone.name}"
  resource_prefix = "${var.resource_prefix}-appserver-b"
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
