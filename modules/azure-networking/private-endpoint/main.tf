resource "azurerm_private_endpoint" "this" {
  name                = var.pe_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  dynamic "private_service_connection" {
    for_each = var.private_service_connection == null ? [] : [var.private_service_connection]
    content {
      name                           = private_service_connection.value.name
      private_connection_resource_id = private_service_connection.value.private_connection_resource_id
      is_manual_connection           = private_service_connection.value.is_manual_connection
      subresource_names              = private_service_connection.value.subresource_names
      request_message                = private_service_connection.value.request_message
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group == null ? [] : [var.private_dns_zone_group]
    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }
} 