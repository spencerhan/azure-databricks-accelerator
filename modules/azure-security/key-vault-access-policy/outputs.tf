output "key_vault_access_policy_ids" {
  description = "The IDs of the created Key Vault access policies."
  value       = [for ap in azurerm_key_vault_access_policy.access_policy : ap.id]
}

output "key_vault_access_policy_object_ids" {
  description = "The object IDs (principal IDs) for which access policies were created."
  value       = [for ap in azurerm_key_vault_access_policy.access_policy : ap.object_id]
}