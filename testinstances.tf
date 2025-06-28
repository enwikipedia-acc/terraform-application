resource "openstack_compute_instance_v2" "testinstance11" {
  name            = "${var.resource_prefix}-test11"
  image_id        = data.openstack_images_image_v2.bullseye.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name
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

resource "openstack_compute_instance_v2" "testinstance12" {
  name            = "${var.resource_prefix}-test12"
  image_id        = data.openstack_images_image_v2.bookworm.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name
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

resource "openstack_dns_recordset_v2" "test11" {
  name    = "test11.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [openstack_compute_instance_v2.testinstance11.access_ip_v4]
  ttl     = 900
}

resource "openstack_dns_recordset_v2" "test12" {
  name    = "test12.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [openstack_compute_instance_v2.testinstance12.access_ip_v4]
  ttl     = 900
}
