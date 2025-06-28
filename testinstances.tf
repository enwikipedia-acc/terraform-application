resource "openstack_compute_instance_v2" "testinstance11" {
  name            = "${var.resource_prefix}-testinstance11"
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

resource "openstack_compute_instance_v2" "testinstance11_legacy" {
  name            = "${var.resource_prefix}-testinstance11-legacy"
  image_id        = data.openstack_images_image_v2.bullseye.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
  ]

  network {
    uuid = data.openstack_networking_network_v2.legacy.id
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "openstack_compute_instance_v2" "testinstance12" {
  name            = "${var.resource_prefix}-testinstance12"
  image_id        = data.openstack_images_image_v2.bookworm.id
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

resource "cloudvps_puppet_prefix" "testinstances" {
  name = "accounts-testinstance"

  hiera = <<-EOT
    profile::systemd::timesyncd::ntp_servers:
      - ntp.ubuntu.com
  EOT
}