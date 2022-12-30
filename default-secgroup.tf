resource "openstack_networking_secgroup_v2" "default" {
  name                 = "${var.resource_prefix}-default"
  description          = "Managed by Terraform; locally-managed default group"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "default-egress" {
  for_each         = { IPv4 = "0.0.0.0/0", IPv6 = "::/0" }

  direction        = "egress"
  ethertype        = each.key
  remote_ip_prefix = each.value
  description      = "Outbound to internet"

  security_group_id = openstack_networking_secgroup_v2.default.id
}
