resource "digitalocean_vpc" "this" {
  name     = "saas-${var.environment}"
  region   = var.region
  ip_range = var.vpc_cidr
}

resource "digitalocean_droplet" "service" {
  for_each = toset(["application", "algorithm"])

  name       = "${var.environment}-${each.key}"
  image      = "ubuntu-24-04-x64"
  region     = var.region
  size       = var.droplet_size
  vpc_uuid   = digitalocean_vpc.this.id
  ssh_keys   = var.ssh_key_fingerprints
  monitoring = true
  tags       = ["saas", var.environment, each.key]
}

resource "digitalocean_database_cluster" "postgres" {
  name                 = "${var.environment}-postgres"
  engine               = "pg"
  version              = "16"
  size                 = var.database_size
  region               = var.region
  node_count           = var.environment == "production" ? 2 : 1
  private_network_uuid = digitalocean_vpc.this.id
}

resource "digitalocean_database_firewall" "postgres" {
  cluster_id = digitalocean_database_cluster.postgres.id
  dynamic "rule" {
    for_each = digitalocean_droplet.service
    content {
      type  = "droplet"
      value = rule.value.id
    }
  }
}

resource "digitalocean_loadbalancer" "application" {
  name     = "${var.environment}-application"
  region   = var.region
  vpc_uuid = digitalocean_vpc.this.id

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 8080
  }

  healthcheck {
    protocol = "http"
    port     = 8080
    path     = "/healthz"
  }

  droplet_ids = [digitalocean_droplet.service["application"].id]
}

resource "digitalocean_firewall" "services" {
  name        = "${var.environment}-services"
  droplet_ids = values(digitalocean_droplet.service)[*].id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.admin_cidrs
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "8080"
    source_load_balancer_uids = [digitalocean_loadbalancer.application.id]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
