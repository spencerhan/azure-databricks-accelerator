# =============================================================================
# Network Connectivity Configuration (NCC)
#
# Only deployed for the "full-private" pattern. NCC provides private connectivity
# from Databricks serverless compute (jobs, model serving, SQL warehouses) to the
# workspace's storage and key vault over private endpoints managed by Databricks.
#
# Docs: https://learn.microsoft.com/en-us/azure/databricks/security/network/serverless-network-security/serverless-firewall
# =============================================================================

module "ncc" {
  count                       = local.needs_ncc ? 1 : 0
  source                      = "../../../modules/data-foundation/databricks-assets/ncc"
  ncc_name                    = local.ncc_name
  region                      = var.region
  workspace_id                = local.workspace_id
  storage_account_resource_id = local.storage_account_id
  key_vault_resource_id       = local.key_vault_id

  providers = {
    databricks = databricks.account
  }
}
