######## Instance types ########

data "openstack_compute_flavor_v2" "small" {
  vcpus    = 1
  ram      = 2048
  min_disk = 15
}

######## Subnets ########

data "openstack_networking_network_v2" "legacy" {
  external = false
  name     = "VLAN/legacy"
}

data "openstack_networking_network_v2" "dualstack" {
  external = false
  name     = "VXLAN/IPv6-dualstack"
}

######## Default Security group ########

data "openstack_networking_secgroup_v2" "default" {
  name = "default"
}

######## DNS zone ########

data "openstack_dns_zone_v2" "rootzone" {
  name = var.dns_zone
}

######## Images ########

data "openstack_images_image_v2" "bullseye" {
  most_recent = true
  name        = "debian-11.0-bullseye"
}

data "openstack_images_image_v2" "bookworm" {
  most_recent = true
  name        = "debian-12.0-bookworm"
}