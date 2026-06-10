output "secret_scope_id" {
  description = "The name of the Databricks secret scope."
  value       = databricks_secret_scope.dbx_secret_scope
}

output "secret_scope_name" {
  description = "The name of the Databricks secret scope."
  value       = databricks_secret_scope.dbx_secret_scope.name
}

output "key_vault_resource_id" {
  description = "The resource ID of the Azure Key Vault associated with the secret scope."
  value       = var.key_vault_id
}

output "key_vault_dns_name" {
  description = "The DNS name of the Azure Key Vault associated with the secret scope."
  value       = var.key_vault_uri
}