resource "openstack_networking_secgroup_v2" "app" {
  name        = "${var.resource_prefix}-application"
  description = "Managed by Terraform; ACC application"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "db" {
  name        = "${var.resource_prefix}-db"
  description = "Managed by Terraform; ACC database"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "db-v4-mysql-remote" {
  direction       = "ingress"
  ethertype       = "IPv4"
  protocol        = "tcp"
  port_range_min  = 3306
  port_range_max  = 3306
  remote_group_id = openstack_networking_secgroup_v2.app.id
  description     = "MySQL inbound from application server"

  security_group_id = openstack_networking_secgroup_v2.db.id
}

resource "openstack_networking_secgroup_rule_v2" "db-v4-mysql" {
  direction       = "ingress"
  ethertype       = "IPv4"
  protocol        = "tcp"
  port_range_min  = 3306
  port_range_max  = 3306
  remote_group_id = openstack_networking_secgroup_v2.db.id
  description     = "MySQL inbound from instances in this group"

  security_group_id = openstack_networking_secgroup_v2.db.id
}

resource "openstack_networking_secgroup_rule_v2" "app-v4-http" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "172.16.0.0/21"
  description      = "HTTP inbound from within WMCS"

  security_group_id = openstack_networking_secgroup_v2.app.id
}

