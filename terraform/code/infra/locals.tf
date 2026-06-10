locals {
  # ---- Pattern flags ---------------------------------------------------------
  is_public            = var.connectivity_pattern == "public"
  is_backend_private   = var.connectivity_pattern == "backend-private"
  is_full_private      = var.connectivity_pattern == "full-private"
  needs_vnet_injection = local.is_backend_private || local.is_full_private
  needs_workspace_pe   = local.is_backend_private || local.is_full_private
  needs_browser_pe     = local.is_full_private

  # ---- Effective flags (respect explicit overrides) -------------------------
  storage_pe_enabled = var.create_storage_private_endpoints == null ? !local.is_public : var.create_storage_private_endpoints
  kv_pe_enabled      = var.create_key_vault_private_endpoint == null ? !local.is_public : var.create_key_vault_private_endpoint

  # ---- Naming ---------------------------------------------------------------
  base = "${var.name_prefix}-${var.target_environment}-${var.region_shortname}"

  rg_name                   = "${local.base}-rg"
  vnet_name                 = "${local.base}-vnet"
  nsg_name                  = "${local.base}-nsg"
  public_subnet_name        = "${local.base}-dbx-host-snet"
  private_subnet_name       = "${local.base}-dbx-container-snet"
  pep_subnet_name           = "${local.base}-pep-snet"
  kv_name                   = substr(replace("${var.name_prefix}-kv-${var.target_environment}-${random_string.suffix.result}", "_", "-"), 0, 24)
  st_name                   = substr(lower(replace("${var.name_prefix}st${var.target_environment}${random_string.suffix.result}", "-", "")), 0, 24)
  dbx_workspace_name        = "${local.base}-dbw"
  dbx_managed_rg_name       = "${local.base}-dbw-managed-rg"
  dbx_access_connector_name = "${local.base}-dbac"
  dbx_pe_ui_name            = "${local.base}-dbw-uiapi-pep"
  dbx_pe_browser_name       = "${local.base}-dbw-browser-pep"
  st_blob_pe_name           = "${local.base}-st-blob-pep"
  st_dfs_pe_name            = "${local.base}-st-dfs-pep"
  kv_pe_name                = "${local.base}-kv-pep"

  # The Databricks bootstrap (DBFS) storage account name passed via custom_parameters.
  # Must be 3-24 lowercase alphanumeric and globally unique.
  dbx_bootstrap_storage_name = substr(lower(replace("${var.name_prefix}dbx${var.target_environment}${random_string.suffix.result}", "-", "")), 0, 24)

  # ---- Tags -----------------------------------------------------------------
  default_tags = {
    "Accelerator"         = "azure-databricks"
    "ConnectivityPattern" = var.connectivity_pattern
    "Environment"         = var.target_environment
    "ManagedBy"           = "Terraform"
  }
  tags = merge(local.default_tags, var.tags)

  # ---- Databricks workspace network settings -------------------------------
  dbx_public_network_access_enabled = !local.is_full_private
  dbx_nsg_rules_required            = local.is_public ? "AllRules" : "NoAzureDatabricksRules"

  dbx_custom_parameters = local.needs_vnet_injection ? {
    vnet_id                           = module.networking[0].vnet_id
    public_subnet_name                = module.networking[0].public_subnet_name
    private_subnet_name               = module.networking[0].private_subnet_name
    public_subnet_nsg_association_id  = module.networking[0].public_subnet_nsg_association_id
    private_subnet_nsg_association_id = module.networking[0].private_subnet_nsg_association_id
    dbx_storage_account_name          = local.dbx_bootstrap_storage_name
    no_public_ip                      = true
  } : null

  # ---- Role assignments -----------------------------------------------------
  dbx_role_assignments = merge(
    {
      for idx, principal_id in var.principal_ids_dbx_readers :
      "dbx_reader_${idx}" => {
        principal_id         = principal_id
        role_definition_name = "Reader"
      }
    },
    {
      for idx, principal_id in var.principal_ids_dbx_contributors :
      "dbx_contributor_${idx}" => {
        principal_id         = principal_id
        role_definition_name = "Contributor"
      }
    }
  )

  storage_data_contributor_assignments = {
    dbx_access_connector = {
      principal_id         = module.dbx.dbx_access_connector_principal_id
      role_definition_name = "Storage Blob Data Contributor"
      description          = "Allow the Databricks access connector to read/write storage data"
    }
  }
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
  keepers = {
    env = var.target_environment
  }
}
