locals {
  production_app_instance_ip4 = openstack_compute_instance_v2.legacy_app6.access_ip_v4
  production_db_instance_ip4 = openstack_compute_instance_v2.legacy_db7.access_ip_v4
}