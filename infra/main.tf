module "platform" {
  source = "./modules/platform"

  environment          = var.environment
  region               = var.region
  droplet_size         = var.droplet_size
  database_size        = var.database_size
  ssh_key_fingerprints = var.ssh_key_fingerprints
  admin_cidrs          = var.admin_cidrs
}

