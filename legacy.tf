# This file contains a bridge to the legacy non-managed infrastructure

data "openstack_compute_instance_v2" "accounts-db6" {
  id = "c07b5734-221d-4056-a5c2-fe995770fcf0"
}

resource "openstack_dns_recordset_v2" "legacy_prod_db" {
  name    = "db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [data.openstack_compute_instance_v2.accounts-db6.access_ip_v4]
  ttl     = 180
}
