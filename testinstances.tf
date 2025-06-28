resource "openstack_compute_instance_v2" "testinstance11" {
  name            = "${var.resource_prefix}-test11"
  image_id        = data.openstack_images_image_v2.bullseye.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name
  ]

  network {
    uuid = data.openstack_networking_network_v2.dualstack.id
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "openstack_compute_instance_v2" "testinstance12" {
  name            = "${var.resource_prefix}-test12"
  image_id        = data.openstack_images_image_v2.bookworm.id
  flavor_id       = data.openstack_compute_flavor_v2.small.id
  user_data       = null
  security_groups = [
    openstack_networking_secgroup_v2.default.name,
    openstack_networking_secgroup_v2.app.name
  ]

  network {
    uuid = data.openstack_networking_network_v2.dualstack.id
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

module "dns_test11" {
  source = "./modules/dns"

  access_ip_v4 = openstack_compute_instance_v2.testinstance11.access_ip_v4
  access_ip_v6 = openstack_compute_instance_v2.testinstance11.access_ip_v6
  name         = "test11" 
}

module "dns_test12" {
  source = "./modules/dns"

  access_ip_v4 = openstack_compute_instance_v2.testinstance12.access_ip_v4
  access_ip_v6 = openstack_compute_instance_v2.testinstance12.access_ip_v6
  name         = "test12" 
}

moved {
  from = openstack_dns_recordset_v2.test11
  to = module.dns_test11.openstack_dns_recordset_v2.a
}

moved {
  from = openstack_dns_recordset_v2.test12
  to = module.dns_test12.openstack_dns_recordset_v2.a
}