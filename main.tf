resource "azurerm_resource_group" "hub" {
  name     = "${var.prefix}-hub-${var.environment}-rg"
  location = var.primary_location
  tags     = var.tags
}

module "hub_network" {
  source               = "./modules/hub-network"
  resource_group_name  = azurerm_resource_group.hub.name
  location             = azurerm_resource_group.hub.location
  vnet_name            = "${var.prefix}-hub-vnet-${var.environment}"
  vnet_cidr            = var.hub_vnet_cidr
  firewall_subnet_cidr = var.firewall_subnet_cidr
  bastion_subnet_cidr  = var.bastion_subnet_cidr
  gateway_subnet_cidr  = var.gateway_subnet_cidr
  tags                 = var.tags
}

module "azure_firewall" {
  source              = "./modules/azure-firewall"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  firewall_name       = "${var.prefix}-fw-${var.environment}"
  subnet_id           = module.hub_network.firewall_subnet_id
  tags                = var.tags
}

module "private_dns" {
  source              = "./modules/private-dns"
  resource_group_name = azurerm_resource_group.hub.name
  hub_vnet_id         = module.hub_network.vnet_id
  tags                = var.tags
}

module "spokes" {
  for_each            = var.workload_spokes
  source              = "./modules/spoke-workload"
  spoke_name          = each.key
  environment         = var.environment
  prefix              = var.prefix
  location            = var.primary_location
  vnet_cidr           = each.value.vnet_cidr
  app_subnet_cidr     = each.value.app_subnet
  data_subnet_cidr    = each.value.data_subnet
  hub_vnet_name       = module.hub_network.vnet_name
  hub_vnet_id         = module.hub_network.vnet_id
  hub_rg_name         = azurerm_resource_group.hub.name
  firewall_private_ip = module.azure_firewall.firewall_private_ip
  tags                = var.tags
}
