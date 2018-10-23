provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cloudflare_zone" {}

# resource "cloudflare_record" "rancher_worker_nodes" {
#   count  = "${var.count_agent_worker_nodes}"
#   domain = "${var.cloudflare_zone}"
#   name   = "default"
#   value  = "${scaleway_server.rancheragent_worker.*.public_ip[count.index]}"
#   type   = "A"
#   ttl    = 3600
# }

# resource "cloudflare_record" "rancher_all_nodes" {
#   count  = "${var.count_agent_all_nodes}"
#   domain = "${var.cloudflare_zone}"
#   name   = "default"
#   value  = "${scaleway_server.rancheragent_all.*.public_ip[count.index]}"
#   type   = "A"
#   ttl    = 3600
# }
