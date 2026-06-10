terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_databricks_access_connector" "dbx_access_connector" {
  name                = var.dbx_access_connector_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
  provider = azurerm
}

resource "azurerm_databricks_workspace" "dbx_wks" {
  name                = var.dbx_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "premium"
  tags                = var.tags

  # If provided, Databricks managed RG will use this name
  managed_resource_group_name = var.dbx_mrg_name

  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.network_security_group_rules_required


  dynamic "custom_parameters" {
    for_each = var.dbx_custom_parameters == null ? [] : [var.dbx_custom_parameters]
    content {
      virtual_network_id   = custom_parameters.value.vnet_id
      public_subnet_name   = custom_parameters.value.public_subnet_name
      private_subnet_name  = custom_parameters.value.private_subnet_name
      storage_account_name = custom_parameters.value.dbx_storage_account_name
      # These must be the NSG association IDs for the respective subnets
      public_subnet_network_security_group_association_id  = custom_parameters.value.public_subnet_nsg_association_id
      private_subnet_network_security_group_association_id = custom_parameters.value.private_subnet_nsg_association_id
      no_public_ip                                         = custom_parameters.value.no_public_ip
    }
  }
  provider = azurerm
}


module "role_assignment" {
  source      = "../../azure-governance/role-assignment"
  scope       = azurerm_databricks_workspace.dbx_wks.id
  assignments = var.role_assignments != null ? var.role_assignments : {}
}