# Configure the Scaleway Provider
provider "scaleway" {
  organization = "${var.scw_org}"
  token        = "${var.scw_token}"
  region       = "${var.region}"
}

variable "scw_org" {}

variable "scw_token" {}

variable "prefix" {
  default = "yourname"
}

variable "rancher_version" {
  default = "latest"
}

variable "admin_password" {
  default = "admin"
}

variable "region" {
  default = "par1"
}

variable "docker_version_server" {
  default = "17.03"
}

variable "type" {
  default = "START1-S"
}

variable "rancher_server_url" {}

data "scaleway_image" "xenial" {
  architecture = "x86_64"
  name         = "Ubuntu Xenial"
}

resource "scaleway_server" "rancherserver" {
  count               = "1"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancherserver"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancherserver" {
  server = "${scaleway_server.rancherserver.id}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_server.rendered}"
}

data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"

  vars {
    admin_password        = "${var.admin_password}"
    docker_version_server = "${var.docker_version_server}"
    rancher_version       = "${var.rancher_version}"
    rancher_server_url    = "${var.rancher_server_url}"
  }
}

resource "scaleway_security_group" "allowall" {
  name        = "rancher-server-allowall"
  description = "allow all traffic"
}

resource "scaleway_security_group_rule" "all_accept" {
  security_group = "${scaleway_security_group.allowall.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
}

output "rancher-url" {
  value = ["https://${scaleway_server.rancherserver.public_ip}"]
}
