data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "snet" {
  name                 = var.snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes     = var.address_prefixes

  default_outbound_access_enabled = var.default_outbound_access_enabled

  private_endpoint_network_policies             = var.private_endpoint_network_policies
  private_link_service_network_policies_enabled = contains(["NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.private_endpoint_network_policies) ? false : true
  service_endpoints                             = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegation == null ? [] : [var.delegation]
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, [])
      }
    }
  }

}
