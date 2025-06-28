terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.0"
    }
  }

  required_version = ">= 1.9"
}

resource "openstack_dns_recordset_v2" "a" {
  name    = "${var.name}.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "A"
  records = [var.access_ip_v4]
  ttl     = 900
}

resource "openstack_dns_recordset_v2" "aaaa" {
  count = var.access_ip_v6 != null ? 1 : 0

  name    = "${var.name}.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "AAAA"
  records = [var.access_ip_v6]
  ttl     = 900
}