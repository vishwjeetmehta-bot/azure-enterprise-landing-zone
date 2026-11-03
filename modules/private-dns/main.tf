locals {
  dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.database.windows.net",
    "privatelink.azurecr.io"
  ]
}

resource "azurerm_private_dns_zone" "zones" {
  for_each            = toset(locals.dns_zones)
  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_links" {
  for_each              = azurerm_private_dns_zone.zones
  name                  = "${replace(each.key, ".", "-")}-hub-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
