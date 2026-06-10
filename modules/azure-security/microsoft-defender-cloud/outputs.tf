output "storage_defender_id" {
  description = "The ID of the Storage Defender configuration."
  value       = azurerm_security_center_storage_defender.sa_defender.id
}

output "storage_account_id" {
  description = "The ID of the storage account with Defender enabled."
  value       = azurerm_security_center_storage_defender.sa_defender.storage_account_id
}

output "malware_scanning_enabled" {
  description = "Whether malware scanning on upload is enabled."
  value       = azurerm_security_center_storage_defender.sa_defender.malware_scanning_on_upload_enabled
}

output "sensitive_data_discovery_enabled" {
  description = "Whether sensitive data discovery is enabled."
  value       = azurerm_security_center_storage_defender.sa_defender.sensitive_data_discovery_enabled
}