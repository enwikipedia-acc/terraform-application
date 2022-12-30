resource "openstack_networking_secgroup_v2" "default" {
  name                 = "${var.resource_prefix}-default"
  description          = "Managed by Terraform; locally-managed default group"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "default-egress" {
  for_each = { IPv4 = "0.0.0.0/0", IPv6 = "::/0" }

  direction        = "egress"
  ethertype        = each.key
  remote_ip_prefix = each.value
  description      = "Outbound to internet"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default-icmp" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "icmp"
  remote_ip_prefix = "172.16.0.0/21"
  description      = "WMCS ICMP"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default-ssh" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "172.16.0.0/21"
  description      = "WMCS SSH"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default-nagios" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 5666
  port_range_max   = 5666
  remote_ip_prefix = "172.16.0.0/21"
  description      = "WMCS Nagios monitoring"

  security_group_id = openstack_networking_secgroup_v2.default.id
}

resource "openstack_networking_secgroup_rule_v2" "default-prometheus" {
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
