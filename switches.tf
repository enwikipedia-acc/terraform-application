locals {
  production_app_instance_ip4 = "app-legacy.${data.openstack_dns_zone_v2.rootzone.name}"
  production_db_instance_ip4 = openstack_compute_instance_v2.legacy_db7.access_ip_v4
}