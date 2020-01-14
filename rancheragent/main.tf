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

variable "count_agent_all_nodes" {
  default = "3"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
}

variable "admin_password" {
  default = "admin"
}

variable "cluster_name" {
  default = "quickstart"
}

variable "region" {
  default = "par1"
}

variable "zone" {
  default = "fr-par-1"
}

variable "docker_version_agent" {
  default = "19.03"
}

variable "type" {
  default = "DEV1-S"
}

variable "rancher_server_address" {}

resource "scaleway_instance_server" "rancheragent_all" {
  count             = var.count_agent_all_nodes
  image             = "ubuntu-bionic"
  type              = var.type
  name              = "${var.prefix}-rancheragent-${count.index}-all"
  security_group_id = scaleway_instance_security_group.allowall.id
  enable_dynamic_ip = true
  cloud_init = templatefile("${path.module}/files/userdata_agent", {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = var.rancher_server_address
  })
  root_volume {
    size_in_gb            = 40
    delete_on_termination = false
  }
}

resource "scaleway_instance_server" "rancheragent_etcd" {
  count             = var.count_agent_etcd_nodes
  image             = "ubuntu-bionic"
  type              = var.type
  name              = "${var.prefix}-rancheragent-${count.index}-etcd"
  security_group_id = scaleway_instance_security_group.allowall.id
  enable_dynamic_ip = true
  cloud_init = templatefile("${path.module}/files/userdata_agent", {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = var.rancher_server_address
  })
  root_volume {
    size_in_gb            = 40
    delete_on_termination = false
  }
}

resource "scaleway_instance_server" "rancheragent_controlplane" {
  count             = var.count_agent_controlplane_nodes
  image             = "ubuntu-bionic"
  type              = var.type
  name              = "${var.prefix}-rancheragent-${count.index}-controlplane"
  security_group_id = scaleway_instance_security_group.allowall.id
  enable_dynamic_ip = true
  cloud_init = templatefile("${path.module}/files/userdata_agent", {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = var.rancher_server_address
  })
  root_volume {
    size_in_gb            = 40
    delete_on_termination = false
  }
}

resource "scaleway_instance_server" "rancheragent_worker" {
  count             = var.count_agent_worker_nodes
  image             = "ubuntu-bionic"
  type              = var.type
  name              = "${var.prefix}-rancheragent-${count.index}-worker"
  security_group_id = scaleway_instance_security_group.allowall.id
  enable_dynamic_ip = true
  cloud_init = templatefile("${path.module}/files/userdata_agent", {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = var.rancher_server_address
  })
  root_volume {
    size_in_gb            = 40
    delete_on_termination = false
  }
}

resource "scaleway_instance_security_group" "allowall" {
  name        = "${var.prefix}-rancher-agent-allowall"
  description = "allow all traffic"

  inbound_rule {
    action   = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }
}
