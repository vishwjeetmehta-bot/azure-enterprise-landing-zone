variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "vnet_cidr" { type = list(string) }
variable "firewall_subnet_cidr" { type = string }
variable "bastion_subnet_cidr" { type = string }
variable "gateway_subnet_cidr" { type = string }
variable "tags" { type = map(string) }
