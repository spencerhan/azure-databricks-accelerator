output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat.id
}

output "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  value       = azurerm_nat_gateway.nat.name
}

output "public_ip_id" {
  description = "The ID of the public IP associated with the NAT Gateway"
  value       = azurerm_public_ip.nat_pip.id
}

output "public_ip_address" {
  description = "The public IP address for stable egress traffic"
  value       = azurerm_public_ip.nat_pip.ip_address
}

