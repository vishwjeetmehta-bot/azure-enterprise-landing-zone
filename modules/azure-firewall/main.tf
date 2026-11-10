resource "azurerm_public_ip" "fw_pip" {
  name                = "${var.firewall_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                     = "${var.firewall_name}-policy"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
  tags                     = var.tags
}

resource "azurerm_firewall" "hub_fw" {
  name                = var.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ip-config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}
