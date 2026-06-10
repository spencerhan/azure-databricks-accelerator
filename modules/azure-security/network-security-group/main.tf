resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = var.nsg_rule_name
  priority                    = var.nsg_rule_priority
  direction                   = var.nsg_rule_direction
  access                      = var.nsg_rule_access
  protocol                    = var.protocol
  source_port_ranges          = toset(var.source_port_ranges)
  destination_port_ranges     = toset(var.destination_port_ranges)
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}

