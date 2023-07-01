# This file contains a bridge to the legacy non-managed infrastructure

data "openstack_compute_instance_v2" "accounts-db6" {
  id = "c07b5734-221d-4056-a5c2-fe995770fcf0"
}

resource "openstack_dns_recordset_v2" "legacy_prod_db" {
  name    = "db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [data.openstack_compute_instance_v2.accounts-db6.access_ip_v4]
  ttl     = 15
}

data "openstack_images_image_v2" "legacy_image" {
  most_recent = true
  name        = "debian-12.0-bookworm"
}

resource "openstack_compute_instance_v2" "legacy_db7" {
  name            = "${var.resource_prefix}-db7"
  image_id        = data.openstack_images_image_v2.legacy_image.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.db.name,
  ]

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

resource "openstack_blockstorage_volume_v3" "legacy_db7" {
  name        = "${var.resource_prefix}-db7"
  description = "Application database; managed by Terraform"
  size        = 5
}

resource "openstack_compute_volume_attach_v2" "legacy_db7" {
  instance_id = openstack_compute_instance_v2.legacy_db7.id
  volume_id   = openstack_blockstorage_volume_v3.legacy_db7.id
  device      = "/dev/sdb"
}

resource "openstack_blockstorage_volume_v3" "legacy_db7_backup" {
  name        = "${var.resource_prefix}-db7-backup"
  description = "Application database; managed by Terraform"
  size        = 2
}

resource "openstack_compute_volume_attach_v2" "legacy_db7_backup" {
  instance_id = openstack_compute_instance_v2.legacy_db7.id
  volume_id   = openstack_blockstorage_volume_v3.legacy_db7_backup.id
  device      = "/dev/sdc"
}
