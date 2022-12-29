
resource "openstack_dns_recordset_v2" "prod_db" {
  name    = "db-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = ["db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"]
  ttl     = 180
}


