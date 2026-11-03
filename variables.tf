variable "prefix" {
  description = "Standard naming prefix for enterprise landing zone resources"
  type        = string
  default     = "alz"
}

variable "environment" {
  description = "Target deployment environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "primary_location" {
  description = "Primary Azure region for hub and shared connectivity"
  type        = string
  default     = "eastus"
}

variable "hub_vnet_cidr" {
  description = "Address space for the Hub Virtual Network"
  type        = list(string)
  default     = ["10.100.0.0/16"]
}

variable "firewall_subnet_cidr" {
  description = "Dedicated subnet CIDR for Azure Firewall (must be /26 or larger)"
  type        = string
  default     = "10.100.0.0/26"
}

variable "bastion_subnet_cidr" {
  description = "Subnet CIDR for Azure Bastion Host"
  type        = string
  default     = "10.100.1.0/26"
}

variable "gateway_subnet_cidr" {
  description = "Subnet CIDR for ExpressRoute / VPN Gateway"
  type        = string
  default     = "10.100.2.0/27"
}

variable "workload_spokes" {
  description = "Map of spoke workloads to provision and peer with Hub"
  type = map(object({
    vnet_cidr     = list(string)
    app_subnet    = string
    data_subnet   = string
    enable_egress = bool
  }))
  default = {
    "corp-apps" = {
      vnet_cidr     = ["10.101.0.0/16"]
      app_subnet    = "10.101.1.0/24"
      data_subnet   = "10.101.2.0/24"
      enable_egress = true
    }
    "data-platform" = {
      vnet_cidr     = ["10.102.0.0/16"]
      app_subnet    = "10.102.1.0/24"
      data_subnet   = "10.102.2.0/24"
      enable_egress = true
    }
  }
}

variable "tags" {
  description = "Resource tags applied to all landing zone resources for governance and FinOps"
  type        = map(string)
  default = {
    Owner          = "Cloud Architecture & DevOps"
    Architect      = "Vishwjeet Kumar Mehta"
    Framework      = "Microsoft Cloud Adoption Framework (CAF)"
    SecurityTier   = "Enterprise Zero-Trust"
    ProvisionedBy  = "Terraform"
  }
}
