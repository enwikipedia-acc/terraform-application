resource "openstack_networking_secgroup_v2" "app" {
  name        = "${var.resource_prefix}-application"
  description = "Managed by Terraform; ACC application"
}
resource "openstack_networking_secgroup_v2" "app_target" {
  name        = "${var.resource_prefix}-application-target"
  description = "Managed by Terraform; ACC application target"
}
resource "openstack_networking_secgroup_v2" "db" {
  name        = "${var.resource_prefix}-db"
  description = "Managed by Terraform; ACC database"
}
resource "openstack_networking_secgroup_v2" "db_target" {
  name        = "${var.resource_prefix}-db-target"
  description = "Managed by Terraform; ACC database target"
}
