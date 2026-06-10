output "connectivity_pattern" {
  value = var.connectivity_pattern
}

output "resource_group_name" {
  value = module.rg.rg_name
}

output "resource_group_id" {
  value = module.rg.rg_id
}

output "vnet_id" {
  value = local.needs_vnet_injection ? module.networking[0].vnet_id : null
}

output "vnet_name" {
  value = local.needs_vnet_injection ? module.networking[0].vnet_name : null
}

output "pep_subnet_id" {
  value = local.needs_vnet_injection ? module.networking[0].pep_subnet_id : null
}

output "storage_account_id" {
  value = module.storage.st_id
}

output "storage_account_name" {
  value = module.storage.st_name
}

output "key_vault_id" {
  value = module.key_vault.key_vault_id
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  value = module.key_vault.key_vault_uri
}

output "dbx_workspace_id" {
  value = module.dbx.dbx_wks_id
}

output "dbx_workspace_name" {
  value = module.dbx.dbx_wks_name
}

output "dbx_workspace_url" {
  value = module.dbx.dbx_wks_url
}

output "dbx_workspace_resource_id" {
  value = module.dbx.dbx_wks_resource_id
}

output "dbx_access_connector_id" {
  value = module.dbx.dbx_access_connector_id
}

output "dbx_access_connector_principal_id" {
  value = module.dbx.dbx_access_connector_principal_id
}

# Convenience flags downstream roots use to decide what to do
output "needs_ncc" {
  value       = local.is_full_private
  description = "True when the deployed pattern requires an NCC for serverless compute."
}
