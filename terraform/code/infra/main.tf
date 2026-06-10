# =============================================================================
# Resource Group
# =============================================================================
module "rg" {
  source      = "../../../modules/azure-core/resource-group"
  rg_name     = local.rg_name
  rg_location = var.region
  tags        = local.tags
  enable_lock = false
}

# =============================================================================
# Networking (only when VNet injection is needed)
# =============================================================================
module "networking" {
  count               = local.needs_vnet_injection ? 1 : 0
  source              = "../../../modules/azure-networking/databricks-vnet"
  location            = var.region
  resource_group_name = module.rg.rg_name
  vnet_name           = local.vnet_name
  nsg_name            = local.nsg_name
  public_subnet_name  = local.public_subnet_name
  private_subnet_name = local.private_subnet_name
  pep_subnet_name     = local.pep_subnet_name
  address_space       = var.vnet_address_space
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  pep_subnet_cidr     = var.pep_subnet_cidr
  tags                = local.tags
}

# =============================================================================
# Private DNS zones (only for private patterns)
# =============================================================================
module "dns_dbx" {
  count         = local.needs_workspace_pe ? 1 : 0
  source        = "../../../modules/azure-networking/private-dns-zone"
  dns_zone_name = "privatelink.azuredatabricks.net"
  rg_name       = module.rg.rg_name
  vnet_id       = module.networking[0].vnet_id
  tags          = local.tags
}

# Storage/KV private DNS zones only make sense when a VNet exists to link them
# to. They are gated on both pattern flags AND vnet injection.
module "dns_blob" {
  count         = local.storage_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source        = "../../../modules/azure-networking/private-dns-zone"
  dns_zone_name = "privatelink.blob.core.windows.net"
  rg_name       = module.rg.rg_name
  vnet_id       = module.networking[0].vnet_id
  tags          = local.tags
}

module "dns_dfs" {
  count         = local.storage_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source        = "../../../modules/azure-networking/private-dns-zone"
  dns_zone_name = "privatelink.dfs.core.windows.net"
  rg_name       = module.rg.rg_name
  vnet_id       = module.networking[0].vnet_id
  tags          = local.tags
}

module "dns_kv" {
  count         = local.kv_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source        = "../../../modules/azure-networking/private-dns-zone"
  dns_zone_name = "privatelink.vaultcore.azure.net"
  rg_name       = module.rg.rg_name
  vnet_id       = module.networking[0].vnet_id
  tags          = local.tags
}

# =============================================================================
# Storage account (ADLS Gen2)
# =============================================================================
module "storage" {
  source                          = "../../../modules/data-foundation/storage-account"
  st_name                         = local.st_name
  resource_group_name             = module.rg.rg_name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  is_hns_enabled                  = true
  public_network_access_enabled   = var.storage_public_network_access_enabled
  default_to_oauth_authentication = true
  blob_versioning_enabled         = true
  blob_delete_retention_days      = 7
  container_delete_retention_days = 7
  tags                            = local.tags
  containers = {
    uc = {
      access_type    = "private"
      container_name = "unity-catalog-storage"
      enable_lock    = false
      directories    = ["catalog"]
    }
  }
  role_assignments = {}
}

# =============================================================================
# Key Vault (RBAC mode, generic per-workspace KV)
# =============================================================================
module "key_vault" {
  source                        = "../../../modules/azure-security/key-vault"
  kv_name                       = local.kv_name
  resource_group_name           = module.rg.rg_name
  location                      = var.region
  tenant_id                     = var.tenant_id
  kv_sku_name                   = "standard"
  kv_soft_delete_retention_days = 7
  kv_purge_protection_enabled   = false
  rbac_authorization_enabled    = true
  public_network_access_enabled = var.key_vault_public_network_access_enabled
  tags                          = local.tags
  kv_role_assignments           = {}
  kv_access_assignments         = {}
}

# =============================================================================
# Databricks workspace
# =============================================================================
module "dbx" {
  source                                = "../../../modules/data-foundation/azure-databricks"
  dbx_workspace_name                    = local.dbx_workspace_name
  dbx_access_connector_name             = local.dbx_access_connector_name
  location                              = var.region
  resource_group_name                   = module.rg.rg_name
  dbx_mrg_name                          = local.dbx_managed_rg_name
  sku                                   = var.dbx_workspace_sku
  public_network_access_enabled         = local.dbx_public_network_access_enabled
  network_security_group_rules_required = local.dbx_nsg_rules_required
  dbx_custom_parameters                 = local.dbx_custom_parameters
  role_assignments                      = local.dbx_role_assignments
  tags                                  = local.tags
}

# =============================================================================
# Grant the Databricks access connector storage-data access
# =============================================================================
module "storage_role_assignment" {
  source      = "../../../modules/azure-governance/role-assignment"
  scope       = module.storage.st_id
  assignments = local.storage_data_contributor_assignments
}

# =============================================================================
# Private endpoints
# =============================================================================
module "st_blob_pep" {
  count               = local.storage_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source              = "../../../modules/azure-networking/private-endpoint"
  pe_name             = local.st_blob_pe_name
  location            = var.region
  resource_group_name = module.rg.rg_name
  subnet_id           = module.networking[0].pep_subnet_id
  tags                = local.tags
  private_service_connection = {
    name                           = "${local.st_blob_pe_name}-conn"
    private_connection_resource_id = module.storage.st_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group = {
    name                 = "${local.st_blob_pe_name}-dnszg"
    private_dns_zone_ids = [module.dns_blob[0].private_dns_zone_id]
  }
}

module "st_dfs_pep" {
  count               = local.storage_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source              = "../../../modules/azure-networking/private-endpoint"
  pe_name             = local.st_dfs_pe_name
  location            = var.region
  resource_group_name = module.rg.rg_name
  subnet_id           = module.networking[0].pep_subnet_id
  tags                = local.tags
  private_service_connection = {
    name                           = "${local.st_dfs_pe_name}-conn"
    private_connection_resource_id = module.storage.st_id
    subresource_names              = ["dfs"]
    is_manual_connection           = false
  }
  private_dns_zone_group = {
    name                 = "${local.st_dfs_pe_name}-dnszg"
    private_dns_zone_ids = [module.dns_dfs[0].private_dns_zone_id]
  }
}

module "kv_pep" {
  count               = local.kv_pe_enabled && local.needs_vnet_injection ? 1 : 0
  source              = "../../../modules/azure-networking/private-endpoint"
  pe_name             = local.kv_pe_name
  location            = var.region
  resource_group_name = module.rg.rg_name
  subnet_id           = module.networking[0].pep_subnet_id
  tags                = local.tags
  private_service_connection = {
    name                           = "${local.kv_pe_name}-conn"
    private_connection_resource_id = module.key_vault.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group = {
    name                 = "${local.kv_pe_name}-dnszg"
    private_dns_zone_ids = [module.dns_kv[0].private_dns_zone_id]
  }
}

# Workspace backend (SCC relay) — needed for both private patterns
module "dbx_pep_uiapi" {
  count               = local.needs_workspace_pe ? 1 : 0
  source              = "../../../modules/azure-networking/private-endpoint"
  pe_name             = local.dbx_pe_ui_name
  location            = var.region
  resource_group_name = module.rg.rg_name
  subnet_id           = module.networking[0].pep_subnet_id
  tags                = local.tags
  private_service_connection = {
    name                           = "${local.dbx_pe_ui_name}-conn"
    private_connection_resource_id = module.dbx.dbx_wks_resource_id
    subresource_names              = ["databricks_ui_api"]
    is_manual_connection           = false
  }
  private_dns_zone_group = {
    name                 = "${local.dbx_pe_ui_name}-dnszg"
    private_dns_zone_ids = [module.dns_dbx[0].private_dns_zone_id]
  }
}

# Browser auth — only for full-private (frontend private link)
module "dbx_pep_browser" {
  count               = local.needs_browser_pe ? 1 : 0
  source              = "../../../modules/azure-networking/private-endpoint"
  pe_name             = local.dbx_pe_browser_name
  location            = var.region
  resource_group_name = module.rg.rg_name
  subnet_id           = module.networking[0].pep_subnet_id
  tags                = local.tags
  private_service_connection = {
    name                           = "${local.dbx_pe_browser_name}-conn"
    private_connection_resource_id = module.dbx.dbx_wks_resource_id
    subresource_names              = ["browser_authentication"]
    is_manual_connection           = false
  }
  private_dns_zone_group = {
    name                 = "${local.dbx_pe_browser_name}-dnszg"
    private_dns_zone_ids = [module.dns_dbx[0].private_dns_zone_id]
  }
}
