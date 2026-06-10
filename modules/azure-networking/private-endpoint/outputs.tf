output "pe_id" {
  description = "The ID of the Azure Private Endpoint."
  value       = azurerm_private_endpoint.this.id
}

output "pe_name" {
  description = "The name of the Azure Private Endpoint."
  value       = azurerm_private_endpoint.this.name
}

output "pe_nic_id" {
  description = "The ID of the primary network interface attached to the private endpoint."
  value       = try(azurerm_private_endpoint.this.network_interface[0].id, null)
}

output "pe_private_ip_address" {
  description = "The allocated private IP address for the private endpoint service connection."
  value       = try(azurerm_private_endpoint.this.private_service_connection[0].private_ip_address, null)
}