resource "azurerm_resource_group" "spoke" {
  name     = "${var.prefix}-${var.spoke_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "${var.prefix}-${var.spoke_name}-vnet"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = var.location
  address_space       = var.vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-application"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.app_subnet_cidr]
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.data_subnet_cidr]
}

resource "azurerm_route_table" "spoke_rt" {
  name                          = "${var.spoke_name}-default-rt"
  resource_group_name           = azurerm_resource_group.spoke.name
  location                      = var.location
  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name                   = "DefaultRouteToAzureFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.spoke_rt.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${var.spoke_name}-to-hub"
  resource_group_name          = azurerm_resource_group.spoke.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-${var.spoke_name}"
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}
