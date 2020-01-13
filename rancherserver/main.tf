# Configure the Scaleway Provider
provider "scaleway" {
  access_key      = var.scw_access_key
  organization_id = var.scw_org
  secret_key      = var.scw_token
  region          = var.region
  zone            = var.zone
}

variable "scw_access_key" {}

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

variable "zone" {
  default = "fr-par-1"
}

variable "docker_version_server" {
  default = "19.03"
}

variable "type" {
  default = "DEV1-S"
}

variable "rancher_server_url" {}

resource "scaleway_instance_server" "rancherserver" {
  image             = "ubuntu-bionic"
  type              = var.type
  name              = "${var.prefix}-rancherserver"
  security_group_id = scaleway_instance_security_group.allowall.id
  enable_dynamic_ip = true
  cloud_init = templatefile("${path.module}/files/userdata_server", {
    admin_password        = var.admin_password
    docker_version_server = var.docker_version_server
    rancher_version       = var.rancher_version
    rancher_server_url    = var.rancher_server_url
  })
  root_volume {
    size_in_gb            = 20
    delete_on_termination = false
  }
}

resource "scaleway_instance_security_group" "allowall" {
  name        = "rancher-server-allowall"
  description = "allow all traffic"

  inbound_rule {
    action   = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }
}

output "rancher-url" {
  value = ["https://${scaleway_instance_server.rancherserver.public_ip}"]
}
