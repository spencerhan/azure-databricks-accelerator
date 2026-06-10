output "nsg_rule_id" {
  description = "The ID of the Network Security Rule."
  value       = azurerm_network_security_rule.nsg_rules.id
}

output "nsg_rule_name" {
  description = "The name of the Network Security Rule."
  value       = azurerm_network_security_rule.nsg_rules.name
}