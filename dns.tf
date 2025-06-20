resource "openstack_dns_recordset_v2" "prod_app" {
  name    = "app-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = ["app-legacy.${data.openstack_dns_zone_v2.rootzone.name}"]
  ttl     = 180
}

resource "openstack_dns_recordset_v2" "prod_db" {
  name    = "db-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = ["db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"]
  ttl     = 900
}

locals {
  proxy_hostname         = var.resource_prefix
}

resource "cloudvps_web_proxy" "application_proxy" {
  hostname = local.proxy_hostname
  domain   = var.proxy_domain
  backends = ["http://${local.production_app_instance_ip4}:80"]
}

resource "cloudvps_web_proxy" "application_proxy_dev" {
  hostname = "${local.proxy_hostname}-dev"
  domain   = var.proxy_domain
  backends = ["http://${local.production_app_instance_ip4}:80"]
}

resource "cloudvps_web_proxy" "wmflabs_application_proxy" {
  hostname = local.proxy_hostname
  domain   = "wmflabs.org"
  backends = ["http://${local.production_app_instance_ip4}:80"]
}

resource "cloudvps_web_proxy" "wmflabs_application_proxy_dev" {
  hostname = "${local.proxy_hostname}-dev"
  domain   = "wmflabs.org"
  backends = ["http://${local.production_app_instance_ip4}:80"]
}
