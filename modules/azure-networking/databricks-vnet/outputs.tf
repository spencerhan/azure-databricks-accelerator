output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "nsg_id" {
  value = azurerm_network_security_group.dbx_nsg.id
}

output "nsg_name" {
  value = azurerm_network_security_group.dbx_nsg.name
}

output "public_subnet_id" {
  value = azurerm_subnet.dbx_public.id
}

output "public_subnet_name" {
  value = azurerm_subnet.dbx_public.name
}

output "private_subnet_id" {
  value = azurerm_subnet.dbx_private.id
}

output "private_subnet_name" {
  value = azurerm_subnet.dbx_private.name
}

output "pep_subnet_id" {
  value = azurerm_subnet.pep.id
}

output "pep_subnet_name" {
  value = azurerm_subnet.pep.name
}

output "public_subnet_nsg_association_id" {
  value = azurerm_subnet_network_security_group_association.public_assoc.id
}

output "private_subnet_nsg_association_id" {
  value = azurerm_subnet_network_security_group_association.private_assoc.id
}
