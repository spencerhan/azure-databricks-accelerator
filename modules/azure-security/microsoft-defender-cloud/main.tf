resource "azurerm_security_center_storage_defender" "sa_defender" {
  storage_account_id                          = var.storage_account_id
  override_subscription_settings_enabled      = true
  malware_scanning_on_upload_enabled          = var.malware_scanning_on_upload_enabled
  malware_scanning_on_upload_cap_gb_per_month = var.malware_scanning_on_upload_enabled ? var.malware_scanning_cap_gb_per_month : null
  sensitive_data_discovery_enabled            = var.sensitive_data_discovery_enabled
}