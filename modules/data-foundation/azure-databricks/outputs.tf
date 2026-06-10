output "dbx_wks_resource_id" {
  description = "Resource ID of the Databricks workspace."
  value       = azurerm_databricks_workspace.dbx_wks.id
}

output "dbx_wks_id" {
  description = "ID of the Databricks workspace."
  value       = azurerm_databricks_workspace.dbx_wks.workspace_id
}




output "dbx_wks_name" {
  description = "Name of the Databricks workspace."
  value       = azurerm_databricks_workspace.dbx_wks.name
}

output "dbx_wks_url" {
  description = "Workspace URL for accessing Databricks."
  value       = azurerm_databricks_workspace.dbx_wks.workspace_url
}

output "dbx_mrg_id" {
  description = "ID of the managed resource group created/used by Databricks."
  value       = azurerm_databricks_workspace.dbx_wks.managed_resource_group_id
}

output "dbx_mrg_name" {
  description = "Name of the managed resource group created/used by Databricks."
  value       = azurerm_databricks_workspace.dbx_wks.managed_resource_group_name
}

output "dbx_access_connector_id" {
  description = "Resource ID of the Databricks Access Connector."
  value       = azurerm_databricks_access_connector.dbx_access_connector.id
}
output "dbx_access_connector_name" {
  description = "Name of the Databricks Access Connector."
  value       = azurerm_databricks_access_connector.dbx_access_connector.name
}

output "dbx_access_connector_principal_id" {
  description = "Principal ID of the Databricks Access Connector's managed identity."
  value       = azurerm_databricks_access_connector.dbx_access_connector.identity[0].principal_id
}
