# This file contains a bridge to the legacy non-managed infrastructure

resource "openstack_dns_recordset_v2" "legacy_prod_app6" {
  name    = "app-legacy.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [openstack_compute_instance_v2.legacy_app7.access_ip_v4]
  ttl     = 900
}

resource "openstack_compute_instance_v2" "legacy_app6" {
  # This instance has a volume attached to it, which is not managed by Terraform.
  # Delete the volume attachmnt manually before destroying this instance.

  name            = "${var.resource_prefix}-appserver6"
  image_id        = data.openstack_images_image_v2.legacy_image.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
    data.openstack_networking_secgroup_v2.default.name,
    data.openstack_networking_secgroup_v2.legacy_web.name,

  ]

  network {
    uuid = data.openstack_networking_network_v2.network.id
  }

  lifecycle {
    ignore_changes = [
      image_id,
      network
    ]
  }
}


data "openstack_networking_secgroup_v2" "legacy_web" {
  name = "web"
}

resource "openstack_compute_instance_v2" "legacy_app7" {
  name            = "${var.resource_prefix}-appserver7"
  image_id        = data.openstack_images_image_v2.bullseye.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
  ]

  network {
    uuid = data.openstack_networking_network_v2.dualstack.id
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}