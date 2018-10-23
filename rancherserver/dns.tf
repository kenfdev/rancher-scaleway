provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cloudflare_zone" {}

resource "cloudflare_record" "rancherserver" {
  domain = "${var.cloudflare_zone}"
  name   = "rancher"
  value  = "${scaleway_server.rancherserver.public_ip}"
  type   = "A"
  ttl    = 3600
}
