# This file contains a bridge to the legacy non-managed infrastructure

data "openstack_compute_instance_v2" "accounts-db6" {
  id = "c07b5734-221d-4056-a5c2-fe995770fcf0"
}

resource "openstack_dns_recordset_v2" "legacy_prod_db" {
  name    = "db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [data.openstack_compute_instance_v2.accounts-db6.access_ip_v4]
  ttl     = 180
}

data "openstack_images_image_v2" "legacy_image" {
  most_recent = true
  name        = "debian-12.0-bookworm"
}

resource "openstack_compute_instance_v2" "legacy_db7" {
  name            = "accounts-db7"
  image_id        = data.openstack_images_image_v2.legacy_image.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = []

  metadata = {
    terraform   = "Yes"
    environment = "Legacy"
  }

  network {
    uuid = data.openstack_networking_network_v2.network.id
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}