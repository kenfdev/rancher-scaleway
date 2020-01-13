provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable "cloudflare_email" {}

variable "cloudflare_api_key" {}

variable "cloudflare_zone_id" {}

resource "cloudflare_record" "rancherserver" {
  zone_id = var.cloudflare_zone_id
  name    = "rancher"
  value   = scaleway_instance_server.rancherserver.public_ip
  type    = "A"
  ttl     = 3600
}
