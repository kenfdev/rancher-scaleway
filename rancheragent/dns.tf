provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable "cloudflare_email" {}

variable "cloudflare_api_key" {}

variable "cloudflare_zone_id" {}

# resource "cloudflare_record" "rancher_worker_nodes" {
#   count  = "${var.count_agent_worker_nodes}"
#   domain = "${var.cloudflare_zone}"
#   name   = "default"
#   value  = "${scaleway_server.rancheragent_worker.*.public_ip[count.index]}"
#   type   = "A"
#   ttl    = 3600
# }

resource "cloudflare_record" "rancher_all_nodes" {
  count   = var.count_agent_all_nodes
  zone_id = var.cloudflare_zone_id
  name    = "gateway.openfaas"
  value   = scaleway_instance_server.rancheragent_all[count.index].public_ip
  type    = "A"
  ttl     = 3600
}
