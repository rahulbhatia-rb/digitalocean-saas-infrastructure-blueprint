variable "environment" { type = string }
variable "region" { type = string }
variable "droplet_size" { type = string }
variable "database_size" { type = string }
variable "ssh_key_fingerprints" { type = list(string) }
variable "admin_cidrs" { type = list(string) }
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/20"
}

