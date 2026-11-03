output "hub_resource_group_name" {
  description = "Name of the central hub resource group"
  value       = azurerm_resource_group.hub.name
}

output "hub_vnet_id" {
  description = "Resource ID of the central hub virtual network"
  value       = module.hub_network.vnet_id
}

output "azure_firewall_private_ip" {
  description = "Private IP address of Azure Firewall for next-hop routing"
  value       = module.azure_firewall.firewall_private_ip
}

output "azure_firewall_public_ip" {
  description = "Public IP address of Azure Firewall for outbound SNAT"
  value       = module.azure_firewall.firewall_public_ip
}

output "spoke_vnet_ids" {
  description = "Map of spoke names to their provisioned Virtual Network IDs"
  value       = { for k, v in module.spokes : k => v.vnet_id }
}
