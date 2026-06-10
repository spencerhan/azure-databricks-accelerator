output "st_id" {
  value = azurerm_storage_account.st.id
}

output "st_name" {
  value = azurerm_storage_account.st.name
}

output "st_primary_blob_endpoint" {
  value = azurerm_storage_account.st.primary_blob_endpoint
}

output "st_primary_dfs_endpoint" {
  value = azurerm_storage_account.st.primary_dfs_endpoint
}

output "abfss_root_url" {
  value = "abfss://${azurerm_storage_account.st.name}.dfs.core.windows.net/"
}


output "st_containers" {
  description = "List of all storage containers"
  value       = [for c in azurerm_storage_container.st_container : c.name]
}

output "st_filesystems" {
  description = "List of all storage data lake filesystems"
  value       = [for fs in azurerm_storage_data_lake_gen2_filesystem.uc_filesystem : fs.name]
}


output "st_filesystem_directories" {
  description = "Map of filesystem name to its directories"
  value = {
    for fs in azurerm_storage_data_lake_gen2_filesystem.uc_filesystem :
    fs.name => [
      for d in azurerm_storage_data_lake_gen2_path.uc_directory :
      d.path if d.filesystem_name == fs.name
    ]
  }
}

output "st_account_kind" {
  description = "The kind of the storage account"
  value       = azurerm_storage_account.st.account_kind
}

output "st_is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled"
  value       = azurerm_storage_account.st.is_hns_enabled
}

output "st_network_rules_applied" {
  description = "Whether network rules were applied"
  value       = var.network_rules != null
}