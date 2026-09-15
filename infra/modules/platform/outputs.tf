output "load_balancer_ip" { value = digitalocean_loadbalancer.application.ip }
output "database_host" { value = digitalocean_database_cluster.postgres.private_host }

