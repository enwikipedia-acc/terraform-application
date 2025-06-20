locals {
  wmcs_internal_ranges = { IPv4 = "172.16.0.0/17", IPv6 = "2a02:ec80:a000::/56" }
}

resource "openstack_networking_secgroup_v2" "default" {
  name                 = "${var.resource_prefix}-default"
  description          = "Managed by Terraform; locally-managed default group"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "default_egress" {
  for_each = { IPv4 = "0.0.0.0/0", IPv6 = "::/0" }

  direction        = "egress"
  ethertype        = each.key
  remote_ip_prefix = each.value
  description      = "Outbound to internet"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default_v4_icmp" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "icmp"
  remote_ip_prefix = "172.16.0.0/17"
  description      = "WMCS ICMP"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default_v6_icmp" {
  direction        = "ingress"
  ethertype        = "IPv6"
  protocol         = "ipv6-icmp"
  remote_ip_prefix = "2a02:ec80:a000::/56"
  description      = "WMCS ICMP"

  security_group_id = openstack_networking_secgroup_v2.default.id
}
resource "openstack_networking_secgroup_rule_v2" "default_ssh" {
  for_each = local.wmcs_internal_ranges

  direction        = "ingress"
  ethertype        = each.key
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = each.value
  description      = "WMCS SSH"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default_nagios" {
  for_each = local.wmcs_internal_ranges

  direction        = "ingress"
  ethertype        = each.key
  protocol         = "tcp"
  port_range_min   = 5666
  port_range_max   = 5666
  remote_ip_prefix = each.value
  description      = "WMCS Nagios monitoring"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default_prometheus" {
  for_each = toset(["172.16.6.65/32", "172.16.0.229/32"])

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 9100
  port_range_max   = 9100
  remote_ip_prefix = each.value
  description      = "WMCS Prometheus monitoring"

  security_group_id = openstack_networking_secgroup_v2.default.id
}
