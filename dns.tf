resource "openstack_dns_recordset_v2" "prod_app" {
  name    = "app-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = [module.bluegreen.live_dns_name]
  ttl     = 180
}

resource "openstack_dns_recordset_v2" "prod_db" {
  name    = "db-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = ["db-legacy.${data.openstack_dns_zone_v2.rootzone.name}"]
  ttl     = 15
}

locals {
  proxy_hostname         = "${var.resource_prefix}${var.proxy_suffix}"
  staging_proxy_hostname = "${local.proxy_hostname}-staging"
}

resource "cloudvps_web_proxy" "application_proxy" {
  hostname = local.proxy_hostname
  domain   = var.proxy_domain
  backends = ["http://app-prod.${trimsuffix(data.openstack_dns_zone_v2.rootzone.name, ".")}:80"]
}

resource "cloudvps_web_proxy" "application_proxy_dev" {
  hostname = "${local.proxy_hostname}-dev"
  domain   = var.proxy_domain
  backends = ["http://app-prod.${trimsuffix(data.openstack_dns_zone_v2.rootzone.name, ".")}:80"]
}

resource "cloudvps_web_proxy" "staging_proxy" {
  count = module.bluegreen.staging_count

  hostname = local.staging_proxy_hostname
  domain   = var.proxy_domain
  backends = ["http://${trimsuffix(module.bluegreen.staging_dns_name, ".")}:80"]
}


resource "cloudvps_web_proxy" "staging_proxy_dev" {
  count = module.bluegreen.staging_count

  hostname = "${local.staging_proxy_hostname}-dev"
  domain   = var.proxy_domain
  backends = ["http://${trimsuffix(module.bluegreen.staging_dns_name, ".")}:80"]
}
