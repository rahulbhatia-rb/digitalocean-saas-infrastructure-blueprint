output "load_balancer_ip" { value = module.platform.load_balancer_ip }
output "database_host" {
  value     = module.platform.database_host
  sensitive = true
}

