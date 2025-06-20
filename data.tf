data "openstack_compute_flavor_v2" "small" {
  vcpus    = 1
  ram      = 2048
  min_disk = 15
}

data "openstack_networking_network_v2" "network" {
  external = false
  name     = "VLAN/legacy"
}

data "openstack_networking_network_v2" "dualstack" {
  external = false
  name     = "VXLAN/IPv6-dualstack"
}

data "openstack_networking_secgroup_v2" "default" {
  name = "default"
}

data "openstack_dns_zone_v2" "rootzone" {
  name = var.dns_zone
}


data "openstack_images_image_v2" "bullseye" {
  most_recent = true
  name        = "debian-11.0-bullseye"
}

data "openstack_images_image_v2" "bookworm" {
  most_recent = true
  name        = "debian-12.0-bookworm"
}