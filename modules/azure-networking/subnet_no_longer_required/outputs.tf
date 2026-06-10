output "subnet_id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.this.name
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet."
  value       = azurerm_subnet.this.address_prefixes
}

output "subnet_resource_group_name" {
  description = "The resource group name of the subnet."
  value       = azurerm_subnet.this.resource_group_name
}

output "subnet_virtual_network_name" {
  description = "The virtual network name of the subnet."
  value       = azurerm_subnet.this.virtual_network_name
}