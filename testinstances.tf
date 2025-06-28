resource "openstack_compute_instance_v2" "testinstance11" {
  name            = "${var.resource_prefix}-test11"
  image_id        = data.openstack_images_image_v2.bullseye.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
    openstack_networking_secgroup_v2.testinstance.name,
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
  name            = "${var.resource_prefix}-test11-legacy"
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
  name            = "${var.resource_prefix}-test12"
  image_id        = data.openstack_images_image_v2.bookworm.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name,
    openstack_networking_secgroup_v2.testinstance.name,
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

module "dns_test11" {
  source = "./modules/dns"

  access_ip_v4 = openstack_compute_instance_v2.testinstance11.access_ip_v4
  access_ip_v6 = openstack_compute_instance_v2.testinstance11.access_ip_v6
  name         = "test11" 
}

module "dns_test11_legacy" {
  source = "./modules/dns"

  access_ip_v4 = openstack_compute_instance_v2.testinstance11_legacy.access_ip_v4
  # access_ip_v6 = openstack_compute_instance_v2.testinstance11_legacy.access_ip_v6
  name         = "test11-legacy" 
}

module "dns_test12" {
  source = "./modules/dns"

  access_ip_v4 = openstack_compute_instance_v2.testinstance12.access_ip_v4
  access_ip_v6 = openstack_compute_instance_v2.testinstance12.access_ip_v6
  name         = "test12" 
}

resource "openstack_networking_secgroup_v2" "testinstance" {
  name        = "${var.resource_prefix}-testinstance"
  description = "Managed by Terraform"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "udp_in" {
  for_each = { IPv4 = "0.0.0.0/0", IPv6 = "::/0" }

  direction        = "ingress"
  ethertype        = each.key
  protocol         = "udp"
  port_range_min   = 123
  port_range_max   = 123
  remote_ip_prefix = each.value
  description      = "NTP inbound"

  security_group_id = openstack_networking_secgroup_v2.testinstance.id
}

resource "openstack_networking_secgroup_rule_v2" "udp_out" {
  for_each = { IPv4 = "0.0.0.0/0", IPv6 = "::/0" }

  direction        = "egress"
  ethertype        = each.key
  protocol         = "udp"
  port_range_min   = 123
  port_range_max   = 123
  remote_ip_prefix = each.value
  description      = "NTP outbound"

  security_group_id = openstack_networking_secgroup_v2.testinstance.id
}