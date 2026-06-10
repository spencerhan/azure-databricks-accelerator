# =============================================================================
# Pattern 3 — Frontend AND backend private connectivity (with NCC for serverless)
#
# - VNet injection ENABLED.
# - Workspace public network access DISABLED — the frontend (web UI / REST API)
#   is reachable ONLY via the `databricks_ui_api` and `browser_authentication`
#   private endpoints. Users must connect from on-prem (ExpressRoute/VPN) or a
#   jump host inside the VNet.
# - Backend SCC traffic uses the same `databricks_ui_api` PE.
# - Storage & Key Vault private endpoints only.
# - A Network Connectivity Configuration (NCC) is created and bound to the
#   workspace so serverless compute (jobs, model serving, SQL warehouses) can
#   reach storage and Key Vault over Databricks-managed private endpoints.
#
# References:
#   - https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link
#   - https://learn.microsoft.com/en-us/azure/databricks/security/network/serverless-network-security/ncc
# =============================================================================

target_environment   = "dev"
connectivity_pattern = "full-private"
region               = "australiaeast"
region_shortname     = "aue"
name_prefix          = "dbxacc"

tenant_id = "REPLACE_WITH_TENANT_ID"

vnet_address_space  = ["10.150.0.0/20"]
public_subnet_cidr  = "10.150.0.0/24"
private_subnet_cidr = "10.150.1.0/24"
pep_subnet_cidr     = "10.150.2.0/26"

storage_public_network_access_enabled   = false
key_vault_public_network_access_enabled = false

tags = {
  Owner      = "platform-team"
  CostCentre = "0000"
}
